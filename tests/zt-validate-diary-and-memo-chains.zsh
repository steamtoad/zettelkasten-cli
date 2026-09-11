#!/bin/zsh

#------------------------------------------------------------------------------
# zt-validate-diary-and-memo-chains.zsh
# Тип: Integration Test
# Назначение: проверить Diary/Memo chain guards на временном Vault
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-chain-validation.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM
mkdir -p "$fixture/bin"

print -r -- '#!/bin/zsh
print -r -- "00000006-0000-1000-8000-000000000001"' > "$fixture/bin/uuid"
print -r -- '#!/bin/zsh
print -r -- "00000006-0000-1000-8000-000000000001"' > "$fixture/bin/uuidgen"
print -r -- '#!/bin/zsh
case "$1" in
  +%Y-%m-%d) print -r -- 2026-09-05 ;;
  +%d-%m-%Y) print -r -- 05-09-2026 ;;
  +%H.%M) print -r -- 10.15 ;;
  *) command date "$@" ;;
esac' > "$fixture/bin/date"
print -r -- '#!/bin/zsh
head -n 1' > "$fixture/bin/fzf"
print -r -- '#!/bin/zsh
exit 0' > "$fixture/bin/vim"
chmod +x "$fixture/bin/uuid" "$fixture/bin/uuidgen" "$fixture/bin/date" "$fixture/bin/fzf" "$fixture/bin/vim"

a='00000001-0000-1000-8000-000000000001.adoc'
b='00000002-0000-1000-8000-000000000001.adoc'
c='00000003-0000-1000-8000-000000000001.adoc'
d='00000004-0000-1000-8000-000000000001.adoc'
note='00000005-0000-1000-8000-000000000001.adoc'

reset_vault() {
  rm -rf -- "$fixture/vault"
  mkdir -p "$fixture/vault/notes" "$fixture/vault/all-todays" "$fixture/vault/workspaces" "$fixture/vault/.scripts"
  export ZK_HOME="$fixture/vault"
  export PATH="$fixture/bin:$PATH"
}

write_document() {
  local file="$1"
  local type="$2"
  local date_value="${3:-2026-09-05}"
  {
    print -r -- "= $type $file"
    print -r -- ":date: $date_value"
    print -r -- ":type: $type"
    print -r -- ":keywords: $type"
    print -r -- ':author: test'
    print -r -- ":description: $type fixture"
    print -r -- ":doclink: link:${file}[${type} fixture]"
    print -r -- ":docfilename: $file"
    print -r -- ''
    print -r -- 'fixture'
  } > "$ZK_HOME/notes/$file"
}

expect_failure() {
  local needle="$1"
  shift
  if "$@" >"$fixture/out" 2>"$fixture/err"; then
    print -ru2 -- "FAIL: command unexpectedly succeeded: $*"
    exit 1
  fi
  rg -qF -- "$needle" "$fixture/out" "$fixture/err" || {
    print -ru2 -- "FAIL: expected $needle from $*"
    exit 1
  }
}

reset_vault
"$repo/scripts/zt-check.zsh" >/dev/null || {
  print -ru2 -- 'FAIL: initialized empty Vault was rejected'
  exit 1
}

write_document "$note" note
print -r -- "$note" > "$ZK_HOME/.last-diary"
cp -R "$ZK_HOME" "$fixture/before-pointer"
expect_failure 'DIARY_POINTER_TYPE' "$repo/scripts/zt-diary.zsh"
diff -r "$fixture/before-pointer" "$ZK_HOME" >/dev/null || {
  print -ru2 -- 'FAIL: Diary pointer-type preflight mutated Vault'
  exit 1
}

reset_vault
write_document "$a" diary
write_document "$b" diary
print -r -- "| link:${b}[Следующая запись]" >> "$ZK_HOME/notes/$a"
print -r -- "link:${a}[Предыдущая запись]" >> "$ZK_HOME/notes/$b"
print -r -- "$b" > "$ZK_HOME/.last-diary"
"$repo/scripts/zt-check.zsh" >/dev/null || {
  print -ru2 -- 'FAIL: reciprocal same-date Diary chain was rejected'
  exit 1
}

awk '!/Предыдущая запись/' "$ZK_HOME/notes/$b" > "$fixture/without-previous"
mv "$fixture/without-previous" "$ZK_HOME/notes/$b"
expect_failure 'DIARY_LINK_RECIPROCITY' "$repo/scripts/zt-check.zsh"

reset_vault
write_document "$a" diary
write_document "$b" diary
print -r -- "link:${b}[Предыдущая запись]" >> "$ZK_HOME/notes/$a"
print -r -- "| link:${b}[Следующая запись]" >> "$ZK_HOME/notes/$a"
print -r -- "link:${a}[Предыдущая запись]" >> "$ZK_HOME/notes/$b"
print -r -- "| link:${a}[Следующая запись]" >> "$ZK_HOME/notes/$b"
print -r -- "$b" > "$ZK_HOME/.last-diary"
expect_failure 'DIARY_CHAIN_GRAPH' "$repo/scripts/zt-check.zsh"

reset_vault
write_document "$a" memo
print -r -- $'\n----\n| link:previous.adoc[Следующее memo]\n----' >> "$ZK_HOME/notes/$a"
print -r -- 'real continuation' | "$repo/scripts/zt-continue.zsh" >/dev/null || {
  print -ru2 -- 'FAIL: code-block Memo example prevented first real continuation'
  exit 1
}
rg -qF 'Следующее memo' "$ZK_HOME/notes/$a" || {
  print -ru2 -- 'FAIL: Continue did not create a primary Memo link'
  exit 1
}
rg -qF 'Ветка:' "$ZK_HOME/notes/$a" && {
  print -ru2 -- 'FAIL: code-block Memo example incorrectly created a branch'
  exit 1
}

reset_vault
write_document "$a" memo
print -r -- $'\n----\n| link:previous.adoc[Следующее memo]\n----' >> "$ZK_HOME/notes/$a"
write_document "$b" memo
write_document "$c" memo
write_document "$d" memo
print -r -- "| link:${b}[Следующее memo]" >> "$ZK_HOME/notes/$a"
print -r -- "| link:${c}[Ветка: c]" >> "$ZK_HOME/notes/$a"
print -r -- "| link:${d}[Ветка: d]" >> "$ZK_HOME/notes/$a"
for target in "$b" "$c" "$d"; do
  print -r -- "link:${a}[Предыдущее memo]" >> "$ZK_HOME/notes/$target"
done
"$repo/scripts/zt-check.zsh" >/dev/null || {
  print -ru2 -- 'FAIL: permitted Memo branches or code example were rejected'
  exit 1
}
print -r -- "| link:${c}[Следующее memo]" >> "$ZK_HOME/notes/$a"
expect_failure 'MEMO_MULTIPLE_NEXT' "$repo/scripts/zt-check.zsh"

print -r -- 'PASS: Diary and Memo chain validation'
