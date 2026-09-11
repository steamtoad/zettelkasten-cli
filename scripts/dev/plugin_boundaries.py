"""Conservative static check of repository-local Zsh dependency paths.

This is not a shell interpreter: computed source paths must use the explicit
directory idioms below, or the check fails for review. It never executes code.
"""
import os
from pathlib import Path
import re
import shlex
import sys

ALLOWED = {
    "lib": {"lib"},
    "objects": {"lib"},
    "zettelkasten": {"lib", "objects", "zettelkasten"},
    "diary": {"lib", "objects", "diary"},
    "inbox": {"lib", "inbox"},
    "workspace": {"lib", "workspace"},
}


def substitutions(text):
    """Extract executable substitutions, honoring literal single quotes/comments."""
    output, nested = [], []
    quote = None
    i = 0
    while i < len(text):
        char = text[i]
        if char == "\\" and quote != "'" and i + 1 < len(text):
            output.append(text[i:i + 2])
            i += 2
            continue
        if char == "#" and quote is None and (i == 0 or text[i - 1].isspace()):
            end = text.find("\n", i)
            end = len(text) if end < 0 else end
            output.append(text[i:end])
            i = end
            continue
        if char == "'" and quote != '"':
            quote = None if quote == "'" else "'"
        elif char == '"' and quote != "'":
            quote = None if quote == '"' else '"'
        if quote != "'" and (text.startswith("$(", i) or char == "`"):
            backtick = char == "`"
            start = i + (1 if backtick else 2)
            j, depth, inner_quote = start, 1, None
            while j < len(text):
                c = text[j]
                if c == "\\" and inner_quote != "'":
                    j += 2
                    continue
                if backtick and c == "`":
                    break
                if c == "'" and inner_quote != '"':
                    inner_quote = None if inner_quote == "'" else "'"
                elif c == '"' and inner_quote != "'":
                    inner_quote = None if inner_quote == '"' else '"'
                elif not backtick and inner_quote is None:
                    if c == "(":
                        depth += 1
                    elif c == ")":
                        depth -= 1
                        if depth == 0:
                            break
                j += 1
            if j == len(text):
                raise ValueError("unterminated command substitution")
            nested.append((text.count("\n", 0, start), text[start:j]))
            # Preserve line numbers and mark computed assignment values unknown.
            output.append("$COMPUTED" + "\n" * text[i:j + 1].count("\n"))
            i = j + 1
            continue
        output.append(char)
        i += 1
    return "".join(output), nested


def commands(text, offset=0):
    """Read whole shell statements so multiline quoted awk stays a literal."""
    text, nested = substitutions(text)
    lexer = shlex.shlex(text, posix=True, punctuation_chars=";&|()\n")
    lexer.whitespace = " \t\r"
    lexer.whitespace_split = True
    entries, words, line = [], [], 1
    for token in lexer:
        if token and set(token) <= set(";&|()\n"):
            if words:
                entries.append((offset + line, words))
                words = []
            line = lexer.lineno
        else:
            if not words:
                line = lexer.lineno
            words.append(token)
    if words:
        entries.append((offset + line, words))
    for line, body in nested:
        entries.extend(commands(body, offset + line))
    return sorted(entries, key=lambda item: item[0])


def check(root):
    errors = []
    count = 0
    for owner, allowed in ALLOWED.items():
        if not (root / owner).is_dir():
            errors.append(f"missing layer: {owner}")
            continue
        for file in sorted((root / owner).rglob("*.zsh")):
            variables = {}

            def resolve(value):
                value = value.strip('"\'')
                if value in ("${0:A:h}", "${${(%):-%N}:A:h}"):
                    return str(file.parent)
                value = value.replace("${${(%):-%N}:A:h}", str(file.parent))
                for name, path in sorted(variables.items(), key=lambda item: -len(item[0])):
                    value = value.replace("${" + name + ":h}", str(Path(path).parent))
                    value = value.replace("${" + name + "}", path)
                    value = re.sub(r"\$" + re.escape(name) + r"\b", lambda _: path, value)
                return value if "$" not in value and "`" not in value else None

            try:
                statements = commands(file.read_text())
            except ValueError as error:
                errors.append(f"{file.relative_to(root)}: unparsed dependency: {error}")
                continue
            for number, words in statements:
                if not words:
                    continue
                # Assignment-only segments define accepted explicit path idioms.
                assignment = re.fullmatch(r"([A-Za-z_][A-Za-z_0-9]*)=(.*)", words[0])
                if assignment and len(words) == 1:
                    value = resolve(assignment[2])
                    if value is not None:
                        variables[assignment[1]] = value
                    else:
                        variables.pop(assignment[1], None)
                    continue
                while words and words[0] in ("if", "then", "else", "elif", "do", "!", "command", "builtin", "{"):
                    words.pop(0)
                if not words:
                    continue
                command = words[0]
                dependency = None
                if command in ("source", "."):
                    dependency = words[1] if len(words) > 1 else ""
                elif command == "exec":
                    if len(words) > 1 and (words[1].endswith(".zsh") or "/" in words[1]):
                        dependency = words[1]
                elif command in ("zsh", "bash", "sh"):
                    dependency = next((w for w in words[1:] if w.endswith(".zsh")), None)
                elif command.endswith(".zsh"):
                    dependency = command
                if dependency is None:
                    continue
                resolved = resolve(dependency)
                label = f"{file.relative_to(root)}:{number}"
                if resolved is None:
                    errors.append(f"{label}: unresolved dependency: {dependency}")
                    continue
                if not Path(resolved).is_absolute():
                    errors.append(f"{label}: unanchored relative dependency: {dependency}")
                    continue
                target = Path(resolved).resolve()
                try:
                    layer = target.relative_to(root).parts[0]
                except ValueError:
                    layer = "outside-repository"
                count += 1
                if layer not in allowed:
                    errors.append(f"{label}: forbidden dependency {owner} -> {layer}: {dependency}")
                elif not target.is_file():
                    errors.append(f"{label}: missing dependency: {dependency}")
    return count, errors


if __name__ == "__main__":
    root = Path(os.environ.get("ZK_SCRIPTS_ROOT", Path(__file__).resolve().parents[1])).resolve()
    count, errors = check(root)
    for error in errors:
        print("ERROR: " + error, file=sys.stderr)
    if errors:
        sys.exit(10)
    print(f"PASS: plugin boundaries ({count} local dependencies)")
