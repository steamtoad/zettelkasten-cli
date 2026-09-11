#!/bin/zsh

#------------------------------------------------------------------------------
# zt-fix-atomic-document-writes.zsh
# Тип: Runtime Regression Test
# Назначение: проверить атомарную замену и exclusive create на временных файлах
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset null_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-write-safety.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

source "$repo/scripts/lib/asciidoc.zsh"

hash_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{ print $1 }'
  else
    sha256sum "$1" | awk '{ print $1 }'
  fi
}

mode_file() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' -- "$1"
  fi
}

note="$fixture/Note with space.adoc"
print -rl -- '= Note' ':type: note' '' '== Связи' '' '* link:old.adoc[Old]' > "$note"
chmod 0644 "$note"
before_hash="$(hash_file "$note")"
before_mode="$(mode_file "$note")"

function awk() { return 1 }
if zk_append_related_link "$note" '== Связи' 'Topic' 'link:new.adoc[New]'; then
  print -ru2 -- 'FAIL: failed preparation was reported as success'
  exit 1
fi
unfunction awk

[[ "$(hash_file "$note")" == "$before_hash" ]] || {
  print -ru2 -- 'FAIL: failed preparation changed the destination bytes'
  exit 1
}
[[ "$(mode_file "$note")" == "$before_mode" ]] || {
  print -ru2 -- 'FAIL: failed preparation changed the destination mode'
  exit 1
}

zk_append_related_link "$note" '== Связи' 'Topic' 'link:new.adoc[New]'
rg -qF '* Topic: link:new.adoc[New]' "$note" || {
  print -ru2 -- 'FAIL: successful atomic replacement omitted the new link'
  exit 1
}
[[ "$(mode_file "$note")" == "$before_mode" ]] || {
  print -ru2 -- 'FAIL: successful replacement changed the destination mode'
  exit 1
}
typeset -a related_temps
related_temps=("$fixture"/.Note\ with\ space.adoc.related.*(N))
(( ${#related_temps} == 0 )) || {
  print -ru2 -- 'FAIL: successful replacement left a prepared file'
  exit 1
}

collision="$fixture/collision.adoc"
setopt no_errexit
print -rn -- 'first' | zk_create_exclusive_from_stdin "$collision" &
first_pid=$!
print -rn -- 'second' | zk_create_exclusive_from_stdin "$collision" &
second_pid=$!
wait "$first_pid"
first_rc=$?
wait "$second_pid"
second_rc=$?
setopt errexit

(( first_rc + second_rc == 1 )) || {
  print -ru2 -- "FAIL: concurrent create statuses were $first_rc and $second_rc"
  exit 1
}
[[ "$(<"$collision")" == 'first' || "$(<"$collision")" == 'second' ]] || {
  print -ru2 -- 'FAIL: concurrent create produced unexpected bytes'
  exit 1
}

symlink_target="$fixture/symlink-target.adoc"
symlink_path="$fixture/symlink.adoc"
print -r -- 'preserve me' > "$symlink_target"
ln -s "$symlink_target" "$symlink_path"
if print -r -- 'overwrite' | zk_create_exclusive_from_stdin "$symlink_path" 2>/dev/null; then
  print -ru2 -- 'FAIL: exclusive create followed an existing symlink'
  exit 1
fi
[[ "$(<"$symlink_target")" == 'preserve me' && -L "$symlink_path" ]] || {
  print -ru2 -- 'FAIL: symlink collision changed existing state'
  exit 1
}

rg -qF '|| reduce_write_failed' "$repo/scripts/zt-reduce.zsh" || {
  print -ru2 -- 'FAIL: Reduce does not propagate linkage failures'
  exit 1
}
rg -qF 'cat -- "$file" || {' "$repo/scripts/zt-read.zsh" || {
  print -ru2 -- 'FAIL: zt-read does not propagate cat failures'
  exit 1
}
rg -qF 'zk_append_text_atomic "$source_file"' "$repo/scripts/zt-continue.zsh" || {
  print -ru2 -- 'FAIL: Continue does not use the checked reverse-link writer'
  exit 1
}

fake_bin="$fixture/bin"
mkdir -p "$fake_bin"
print -rl -- \
  '#!/bin/zsh' \
  'case "$*" in' \
  '  *Режим*) print -r -- "Clean Successor" ;;' \
  '  *) IFS= read -r line; print -r -- "$line" ;;' \
  'esac' > "$fake_bin/fzf"
print -rl -- \
  '#!/bin/zsh' \
  'last="${@[-1]}"' \
  'if [[ -n "${ZK_TEST_FAIL_MV_DEST:-}" && "${last:t}" == "$ZK_TEST_FAIL_MV_DEST" ]]; then' \
  '  exit 73' \
  'fi' \
  'exec /bin/mv "$@"' > "$fake_bin/mv"
print -rl -- '#!/bin/zsh' 'print -r -- "20000000-0000-1000-8000-000000000000"' > "$fake_bin/uuid"
cp "$fake_bin/uuid" "$fake_bin/uuidgen"
print -rl -- '#!/bin/zsh' 'exit 0' > "$fake_bin/vim"
chmod +x "$fake_bin"/*

write_reduce_fixture() {
  local root="$1"
  local old='10000000-0000-1000-8000-000000000000.adoc'
  local note_name='10000001-0000-1000-8000-000000000000.adoc'
  local title='Atomic - ключевая тема'

  mkdir -p "$root/notes" "$root/all-todays"
  print -rl -- \
    "= $title" ':date: 2026-09-06' ':keywords: topic, atomic' ':type: topic' \
    ':author: test' ":description: $title" ":doclink: link:${old}[$title]" \
    ":docfilename: $old" ':key-topic: Atomic' '' '== Связанные note' '' > "$root/notes/$old"
  print -rl -- \
    '= Durable Note' ':date: 2026-09-06' ':keywords: note, atomic' ':type: note' \
    ':author: test' ':description: Durable Note' \
    ":doclink: link:${note_name}[Durable Note]" ":docfilename: $note_name" \
    ':key-topic: Atomic' '' '== Связи' '' > "$root/notes/$note_name"
}

reduce_failure="$fixture/reduce-failure"
write_reduce_fixture "$reduce_failure"
failed_note='10000001-0000-1000-8000-000000000000.adoc'
failed_old='10000000-0000-1000-8000-000000000000.adoc'
failed_note_hash="$(hash_file "$reduce_failure/notes/$failed_note")"
if print -r -- y | env \
  PATH="$fake_bin:$PATH" \
  ZK_HOME="$reduce_failure" \
  ZK_TEST_FAIL_MV_DEST="$failed_note" \
  "$repo/scripts/zt-reduce.zsh" >"$fixture/reduce-failure.out" 2>"$fixture/reduce-failure.err"; then
  print -ru2 -- 'FAIL: Reduce ignored a Note linkage failure'
  exit 1
fi
! rg -qF 'Reduce complete' "$fixture/reduce-failure.out" || {
  print -ru2 -- 'FAIL: failed Reduce printed completion'
  exit 1
}
! rg -q '^:deprecated:$' "$reduce_failure/notes/$failed_old" || {
  print -ru2 -- 'FAIL: failed Reduce archived the old Topic'
  exit 1
}
[[ "$(hash_file "$reduce_failure/notes/$failed_note")" == "$failed_note_hash" ]] || {
  print -ru2 -- 'FAIL: failed Reduce changed the Note destination'
  exit 1
}
rg -qF 'Already changed files:' "$fixture/reduce-failure.err" || {
  print -ru2 -- 'FAIL: failed Reduce omitted recovery diagnostics'
  exit 1
}

reduce_success="$fixture/reduce-success"
write_reduce_fixture "$reduce_success"
print -r -- y | env PATH="$fake_bin:$PATH" ZK_HOME="$reduce_success" \
  "$repo/scripts/zt-reduce.zsh" >"$fixture/reduce-success.out" 2>"$fixture/reduce-success.err"
rg -qF 'Reduce complete' "$fixture/reduce-success.out" || {
  print -ru2 -- 'FAIL: normal Reduce did not complete'
  exit 1
}
rg -q '^:deprecated:$' "$reduce_success/notes/$failed_old" || {
  print -ru2 -- 'FAIL: normal Reduce did not archive the old Topic'
  exit 1
}
rg -qF 'link:20000000-0000-1000-8000-000000000000.adoc[' "$reduce_success/notes/$failed_note" || {
  print -ru2 -- 'FAIL: normal Reduce did not link the Note to its successor'
  exit 1
}

continue_root="$fixture/continue"
mkdir -p "$continue_root/notes" "$continue_root/all-todays"
memo='30000000-0000-1000-8000-000000000000.adoc'
print -rl -- \
  '= Memo source' ':date: 2026-09-06' ':keywords: memo' ':type: memo' ':author: test' \
  ':description: Memo source' ":doclink: link:${memo}[Memo source]" ":docfilename: $memo" '' > "$continue_root/notes/$memo"
memo_hash="$(hash_file "$continue_root/notes/$memo")"
if print -r -- branch | env \
  PATH="$fake_bin:$PATH" \
  ZK_HOME="$continue_root" \
  ZK_TEST_FAIL_MV_DEST="$memo" \
  "$repo/scripts/zt-continue.zsh" >"$fixture/continue.out" 2>"$fixture/continue.err"; then
  print -ru2 -- 'FAIL: Continue ignored the reverse-link write failure'
  exit 1
fi
[[ "$(hash_file "$continue_root/notes/$memo")" == "$memo_hash" ]] || {
  print -ru2 -- 'FAIL: failed Continue changed its source Memo'
  exit 1
}
! rg -qF 'link:20000000-0000-1000-8000-000000000000.adoc[' "$fixture/continue.out" || {
  print -ru2 -- 'FAIL: failed Continue printed a success link'
  exit 1
}

read_root="$fixture/read"
mkdir -p "$read_root/notes"
print -rl -- '= Needle' ':type: note' '' 'needle' > "$read_root/notes/read-failure.adoc"
print -rl -- \
  '#!/bin/zsh' \
  'if [[ "$*" == *notes/read-failure.adoc* ]]; then exit 74; fi' \
  'exec /bin/cat "$@"' > "$fake_bin/cat"
chmod +x "$fake_bin/cat"
if print -r -- needle | env PATH="$fake_bin:$PATH" ZK_HOME="$read_root" \
  "$repo/scripts/zt-read.zsh" >"$fixture/read.out" 2>"$fixture/read.err"; then
  print -ru2 -- 'FAIL: zt-read ignored cat failure'
  exit 1
fi
rg -qF 'ERROR cannot read file: notes/read-failure.adoc' "$fixture/read.err" || {
  print -ru2 -- 'FAIL: zt-read omitted the unreadable filename'
  exit 1
}

print -r -- 'PASS: atomic document writes and collision safety'
