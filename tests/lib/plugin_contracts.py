"""Behavior contracts exercised through public entrypoints in disposable vaults."""
import json
import os
import re
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import uuid

REPO = Path(__file__).resolve().parents[2]
GROUP = sys.argv[1] if __name__ == "__main__" else None
MAPPING = {
    "diary": {"zt-diary.zsh": "diary/zt-diary.zsh"},
    "inbox": {"zt-inbox.zsh": "inbox/capture.zsh", "zt-processed.zsh": "inbox/processed.zsh"},
    "workspace": {f"zt-workspace-{op}.zsh": f"workspace/zt-workspace-{op}.zsh"
                  for op in ("create", "add", "open", "remove")},
}


class Vault:
    def __init__(self, root):
        self.root = root
        self.home = root / "vault with spaces"
        self.home.mkdir()
        self.bin = root / "bin"
        self.bin.mkdir()
        self.env = dict(os.environ, ZK_HOME=str(self.home), EDITOR="vim --literal",
                        PATH=str(self.bin) + os.pathsep + os.environ["PATH"],
                        FIXTURE=str(root), TMPDIR=str(root), LC_ALL="en_US.UTF-8" if sys.platform == "darwin" else "C.UTF-8")
        self.env.pop("ZETTELKASTEN_ROOT", None)
        self.scripts = REPO / ".scripts"
        stub = '''#!/usr/bin/env python3
import json, os, pathlib, sys
root = pathlib.Path(os.environ['FIXTURE'])
name = pathlib.Path(sys.argv[0]).name
if name in ('uuid', 'uuidgen'):
    if os.environ.get('FAIL_UUID'): sys.exit(1)
    counter = root / 'uuid-counter'
    n = int(counter.read_text()) + 1 if counter.exists() else 1
    counter.write_text(str(n))
    print(f'{n:08x}-0000-1000-8000-000000000001')
elif name == 'date':
    values = {'+%Y-%m-%d': '2026-09-05', '+%d-%m-%Y': '05-09-2026',
              '+%H.%M': '10.15', '+%Y-%m-%d-%H%M%S': '2026-09-05-101500',
              '+%Y-%m-%dT%H:%M:%S%z': '2026-09-05T10:15:00+0500'}
    print(values[sys.argv[1]])
elif name == 'vim':
    with (root / 'editor-log').open('a') as log: log.write(json.dumps(sys.argv[1:]) + '\\n')
    sys.exit(int(os.environ.get('EDITOR_EXIT', '0')))
elif name == 'fzf':
    rows = sys.stdin.read().splitlines()
    with (root / 'fzf-log').open('a') as log:
        log.write(json.dumps({'args': sys.argv[1:], 'rows': rows}) + '\\n')
    prompt = next(a for a in sys.argv if a.startswith('--prompt='))
    if os.environ.get('CANCEL') in ('all', prompt): sys.exit(130)
    if prompt == '--prompt=workspace> ':
        print(rows[0] if rows else '')
    else:
        needles = json.loads(os.environ.get('SELECT', '[]'))
        print('\\n'.join(r for r in rows if not needles or any(n in r for n in needles)))
elif name in ('ln', 'link', 'rm', 'mv'):
    if name in ('ln', 'link') and os.environ.get('FAIL_LN'): sys.exit(1)
    if name == 'rm' and os.environ.get('FAIL_RM') == sys.argv[-1]: sys.exit(1)
    if name == 'mv' and os.environ.get('FAIL_MV') and 'zk-workspace-remove.' in sys.argv[1]: sys.exit(1)
    os.execv(os.environ['REAL_' + name.upper()], [name] + sys.argv[1:])
'''
        for name in ("uuid", "uuidgen", "date", "vim", "fzf", "ln", "link", "rm", "mv"):
            path = self.bin / name
            path.write_text(stub)
            path.chmod(0o755)
        for name in ("ln", "link", "rm", "mv"):
            self.env["REAL_" + name.upper()] = shutil.which(name)

    def run(self, name, *args, input="", code=0, **env):
        result = subprocess.run([str(self.scripts / name), *map(str, args)],
                                input=input, text=True, capture_output=True, timeout=30,
                                cwd=self.root, env=dict(self.env, **env))
        assert (result.returncode == code if code is not None else result.returncode != 0), (
            name, result.returncode, result.stdout, result.stderr)
        return result

    def note(self, name, kind="note", deprecated=False):
        notes = self.home / "notes"
        notes.mkdir(exist_ok=True)
        path = notes / (name + ".adoc")
        path.write_text(f"= {name}\n:type: {kind}\n:description: {name} описание\n" +
                        (":deprecated:\n" if deprecated else "") + "\nbody\n")
        return path

    def snapshot(self):
        return {str(p.relative_to(self.home)): p.read_bytes()
                for p in self.home.rglob("*") if p.is_file()}

    def isolate_scripts(self):
        self.scripts = self.root / "installed" / ".scripts"
        shutil.copytree(REPO / ".scripts", self.scripts)


def diary(v):
    state = v.home / ".last-diary"
    first = v.run("zt-diary.zsh")
    one = state.read_text().strip()
    assert uuid.UUID(one[:-5]).version == 1
    body = (v.home / "notes" / one).read_text()
    for attr in ("date", "type", "keywords", "author", "description", "doclink", "docfilename"):
        assert f":{attr}:" in body
    assert ":type: diary" in body and f":docfilename: {one}" in body
    assert "= Diary - 05-09-2026" in body
    assert first.stdout == f"link:{one}[Diary - 05-09-2026]\n"
    # Existing Diary reports the link even when Vim exits nonzero.
    v.run("zt-diary.zsh", EDITOR_EXIT="37")
    two = state.read_text().strip()
    assert two != one
    assert f"| link:{two}[Следующая запись]" in (v.home / "notes" / one).read_text()
    assert f"link:{one}[Предыдущая запись]" in (v.home / "notes" / two).read_text()
    assert (v.home / "all-todays/2026-09-05.adoc").read_text() == (
        "= Заметки за 05-09-2026\n\n" + "".join(
            f"* 10.15 - link:../notes/{n}[Diary - 05-09-2026]\n" for n in (one, two)))
    assert [json.loads(s) for s in (v.root / "editor-log").read_text().splitlines()] == [
        [str(v.home / "notes" / n)] for n in (one, two)]
    before = v.snapshot()
    v.run("zt-diary.zsh", code=None, FAIL_UUID="1")
    assert v.snapshot() == before
    state.write_text("../outside.adoc\n")
    before = v.snapshot()
    assert "invalid .last-diary" in v.run("zt-diary.zsh", code=None).stderr
    assert v.snapshot() == before
    state.write_text(two + "\n")
    shutil.rmtree(v.home / "all-todays")
    (v.home / "all-todays").write_text("blocked")
    prior = (v.home / "notes" / two).read_bytes()
    v.run("zt-diary.zsh", code=None)
    assert state.read_text() == two + "\n"
    assert (v.home / "notes" / two).read_bytes() == prior
    (v.home / "all-todays").unlink()
    v.isolate_scripts()
    with (v.scripts / "lib/asciidoc.zsh").open("a") as f:
        f.write('''\nprint() {
  if [[ "$*" == *'| link:'* && "$*" == *'Следующая запись'* ]]; then return 74; fi
  builtin print "$@"
}
''')
    v.run("zt-diary.zsh", code=None)
    assert state.read_text() == two + "\n"
    assert (v.home / "notes" / two).read_bytes() == prior


def inbox(v):
    for args in ((), ("",), (" \t",), ("a\nb",), ("a\rb",)):
        v.run("zt-inbox.zsh", *args, code=None)
    assert v.run("zt-inbox.zsh", code=None).stderr == 'Usage: zt-inbox.zsh "Title"\n'
    assert not (v.home / "inbox").exists()
    result = v.run("zt-inbox.zsh", "Тема", "с пробелами", EDITOR_EXIT="37", code=37)
    raw = Path(result.stdout.strip())
    assert raw == v.home / "inbox/raw/2026-09-05-101500.adoc"
    assert raw.read_text() == "= Тема с пробелами\n:captured-at: 2026-09-05T10:15:00+0500\n:source: manual\n\n"
    assert json.loads((v.root / "editor-log").read_text()) == ["--literal", str(raw)]
    second = Path(v.run("zt-inbox.zsh", "Еще").stdout.strip())
    assert second.name == "2026-09-05-101500-1.adoc"
    original = raw.read_bytes()
    v.run("zt-inbox.zsh", "Нет редактора", EDITOR="nonexistent-editor-fixture", code=None)
    assert (raw.parent / "2026-09-05-101500-2.adoc").exists()
    assert v.run("zt-processed.zsh", code=None).stderr == "Usage: zt-processed.zsh FILE\n"
    for args in ((), (raw, second)):
        v.run("zt-processed.zsh", *args, code=None)
    outside = v.root / "outside.adoc"
    outside.write_text("outside")
    (raw.parent / "escape.adoc").symlink_to(outside)
    nested = raw.parent / "nested/inside.adoc"
    nested.parent.mkdir()
    nested.write_text("nested")
    for path in (outside, raw.parent / "escape.adoc", nested, "missing.adoc"):
        v.run("zt-processed.zsh", path, code=None)
    assert outside.read_text() == "outside" and nested.read_text() == "nested"
    destination = v.home / "inbox/processed" / raw.name
    v.run("zt-processed.zsh", raw, FAIL_LN="1", code=None)
    assert raw.read_bytes() == original and not destination.exists()
    v.run("zt-processed.zsh", raw, FAIL_RM=str(raw), code=None)
    assert raw.read_bytes() == original and not destination.exists()
    destination.write_text("existing")
    v.run("zt-processed.zsh", raw, code=None)
    assert destination.read_text() == "existing" and raw.read_bytes() == original
    destination.unlink()
    assert v.run("zt-processed.zsh", raw.name).stdout == str(destination) + "\n"
    assert not raw.exists() and destination.read_bytes() == original
    v.run("zt-processed.zsh", second)
    assert not (v.home / "notes").exists() and not (v.home / "all-todays").exists()
    v.isolate_scripts()
    v.env.pop("ZK_HOME")
    fallback = Path(v.run("zt-inbox.zsh", "Fallback").stdout.strip())
    assert fallback.parent == v.scripts.parent / "inbox/raw"
    v.run("zt-processed.zsh", fallback)
    other = v.root / "alternate"
    capture = Path(v.run("zt-inbox.zsh", "Alternate", ZETTELKASTEN_ROOT=str(other)).stdout.strip())
    assert capture.parent == other / "inbox/raw"


def workspace(v):
    for title in ("", "  ", ".", "..", ".hidden", "a/b", "a\\b"):
        v.run("zt-workspace-create.zsh", input=title + "\n", code=None)
    assert not (v.home / "workspaces").exists()
    result = v.run("zt-workspace-create.zsh", input="  Рабочее место  \n")
    assert result.stdout == "workspaces/Рабочее-место.adoc\n"
    path = v.home / result.stdout.strip()
    assert path.read_text() == "= Рабочее место\n\n== Документы\n\n"
    v.run("zt-workspace-create.zsh", input="Рабочее место\n", code=None)
    docs = [v.note(str(uuid.UUID(int=n, version=1)), kind) for n, kind in
            enumerate(("note", "memo", "todo", "topic", "diary"), 1)]
    deprecated = v.note("archived", deprecated=True)
    v.note("invalid", "unsupported")
    hashes = {p: p.read_bytes() for p in (v.home / "notes").iterdir()}
    before = path.read_bytes()
    v.run("zt-workspace-add.zsh", CANCEL="all")
    v.run("zt-workspace-open.zsh", CANCEL="all")
    assert path.read_bytes() == before
    v.run("zt-workspace-add.zsh")
    added = path.read_bytes()
    for p in docs:
        assert f"* link:../notes/{p.name}[{p.stem} описание]" in path.read_text()
    assert "archived.adoc" not in path.read_text() and "invalid.adoc" not in path.read_text()
    v.run("zt-workspace-add.zsh")
    assert path.read_bytes() == added
    assert v.run("zt-workspace-open.zsh").stdout.encode() == added
    with path.open("a") as f:
        f.write("\n== Вручную\n\n* link:../notes/archived.adoc[Old]\n* link:../notes/missing.adoc[Broken]\n")
        for delimiter in ("----", "....", "____", "****", "====", "++++", "////", "```"):
            f.write(f"\n{delimiter}\n* link:../notes/example.adoc[Example]\n{delimiter}\n")
    path.chmod(0o640)
    before = path.read_bytes()
    v.run("zt-workspace-remove.zsh", CANCEL="--prompt=remove documents> ")
    assert path.read_bytes() == before
    v.run("zt-workspace-remove.zsh", FAIL_MV="1", code=None)
    assert path.read_bytes() == before and path.stat().st_mode & 0o777 == 0o640
    v.run("zt-workspace-remove.zsh", SELECT=json.dumps([docs[0].name, "archived.adoc", "missing.adoc"]))
    body = path.read_text()
    assert docs[0].name not in body and "archived.adoc" not in body and "missing.adoc" not in body
    assert all(p.name in body for p in docs[1:]) and body.count("example.adoc") == 8
    assert path.stat().st_mode & 0o777 == 0o640
    rows = [json.loads(s) for s in (v.root / "fzf-log").read_text().splitlines()]
    for call in rows:
        assert "--delimiter=\x1f" in call["args"] and "--with-nth=1" in call["args"]
        if "--prompt=remove documents> " in call["args"]:
            assert "--multi" in call["args"]
            assert not any("example.adoc" in r for r in call["rows"])
        if "--prompt=add documents> " in call["args"]:
            assert "--multi" in call["args"] and len(call["rows"]) == 5
    assert any(any(r.startswith("deprecated - ") for r in call["rows"]) for call in rows)
    assert any(any(r.startswith("broken - ") for r in call["rows"]) for call in rows)
    assert all(p.read_bytes() == data for p, data in hashes.items())


def structure(v):
    old = {"diary": "zettelkasten/zt-diary.zsh", "workspace": "zettelkasten/lib/workspace.zsh"}
    if GROUP in old:
        assert not (REPO / ".scripts" / old[GROUP]).exists(), "old canonical path remains"
    v.isolate_scripts() if v.scripts == REPO / ".scripts" else None
    for public, canonical in MAPPING[GROUP].items():
        wrapper = REPO / ".scripts" / public
        source = wrapper.read_text()
        assert f'exec "$script_dir/{canonical}" "$@"' in source
        assert len([s for s in source.splitlines() if s and not s.startswith("#")]) == 2
        assert os.access(wrapper, os.X_OK) and os.access(REPO / ".scripts" / canonical, os.X_OK)
        target = v.scripts / canonical
        target.write_text('#!/bin/zsh\nprint -rl -- "$@"\nprint -ru2 -- "forwarded stderr"\nexit 37\n')
        target.chmod(0o755)
        result = v.run(public, "first arg", "", "Юникод * ?", code=37)
        assert result.stdout == "first arg\n\nЮникод * ?\n"
        assert result.stderr == "forwarded stderr\n"
    instructions = (REPO / "AGENTS.MD").read_text()
    for public in MAPPING[GROUP]:
        skill = {"zt-diary.zsh": "zettelkasten-diary", "zt-inbox.zsh": "zettelkasten-inbox-capture",
                 "zt-processed.zsh": "zettelkasten-inbox-processed"}.get(public, public.replace("zt-", "zettelkasten-").removesuffix(".zsh"))
        assert re.search(re.escape(public) + r"\s+-> " + re.escape(skill) + r"\b", instructions)


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix=f"zt-{GROUP}-contract-") as tmp:
        vault = Vault(Path(tmp).resolve())
        globals()[GROUP](vault)
        if "--behavior-only" not in sys.argv:
            structure(vault)
    print(f"PASS: {GROUP} public behavior" + (" and plugin structure" if "--behavior-only" not in sys.argv else " (baseline)"))
