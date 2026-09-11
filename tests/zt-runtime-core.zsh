#!/bin/zsh

#------------------------------------------------------------------------------
# zt-runtime-core.zsh
# Тип: Runtime Integration Test
# Назначение: проверить constructors и zt-check на временном Zettelkasten
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset extended_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-runtime-core.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

export ZK_HOME="$fixture"
mkdir -p "$fixture/notes" "$fixture/all-todays" "$fixture/workspaces" "$fixture/.scripts"

source "$repo/scripts/lib/asciidoc.zsh"

typeset -a constructors types titles
constructors=(note memo todo diary topic)
types=(note memo todo diary topic)
titles=('Runtime Note' 'Runtime Memo' 'Runtime Todo' 'Runtime Diary' 'Runtime Topic')

for index in {1..5}; do
  kind="${constructors[$index]}"
  case "$kind" in
    topic) file="$("$repo/scripts/objects/topic-create.zsh" "${titles[$index]}" 'runtime-topic')" ;;
    *) file="$("$repo/scripts/objects/${kind}-create.zsh" "${titles[$index]}")" ;;
  esac

  document_path="$fixture/notes/$file"
  [[ -f "$document_path" ]] || { print -u2 -- "FAIL: $kind constructor did not create $file"; exit 1; }
  [[ "$file" == [0-9a-f]##-[0-9a-f]##-[0-9a-f]##-[0-9a-f]##-[0-9a-f]##.adoc ]] || { print -u2 -- "FAIL: invalid UUID filename: $file"; exit 1; }
  [[ "$(zk_attr_value "$document_path" type)" == "${types[$index]}" ]] || { print -u2 -- "FAIL: invalid type for $file"; exit 1; }
  [[ "$(zk_attr_value "$document_path" docfilename)" == "$file" ]] || { print -u2 -- "FAIL: invalid docfilename for $file"; exit 1; }
  rg -qF ":doclink: link:${file}[${titles[$index]}]" "$document_path" || { print -u2 -- "FAIL: invalid doclink for $file"; exit 1; }

  if [[ "$kind" == diary ]]; then
    print -r -- "$file" > "$fixture/.last-diary"
  fi
done

"$repo/scripts/zt-check.zsh" >/dev/null || { print -u2 -- 'FAIL: zt-check rejected valid runtime fixture'; exit 1; }

# CHECK-003/CHECK-022: body/code pseudo-metadata and placeholder links are not header metadata.
typeset -a note_files
note_files=("${(@f)$(find "$fixture/notes" -type f -name '*.adoc' | sort)}")
note_file="${note_files[1]}"
print -r -- $'\n----\n:deprecated:\nlink:missing.adoc[fixture]\n----' >> "$note_file"
"$repo/scripts/zt-check.zsh" >/dev/null || { print -u2 -- 'FAIL: zt-check parsed code-block pseudo metadata/link'; exit 1; }

# CHECK-002: a genuinely broken link must fail validation.
print -r -- $'\nlink:missing.adoc[Broken]' >> "$note_file"
if "$repo/scripts/zt-check.zsh" >/dev/null 2>&1; then
  print -u2 -- 'FAIL: zt-check accepted a broken link'
  exit 1
fi

print -r -- 'PASS: runtime constructors and zt-check temporary-Vault integration'
