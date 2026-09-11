#!/bin/zsh

#------------------------------------------------------------------------------
# zt-clarify-topic-membership-contract.zsh
# Тип: Runtime Regression Test
# Назначение: проверить Topic membership, Reduce и Refine lifecycle contracts
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset null_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-topic-membership.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

fake_bin="$fixture/bin"
mkdir -p "$fake_bin"

print -rl -- \
  '#!/bin/zsh' \
  'sep=$'"'"'\x1f'"'"'' \
  'pick="${ZK_TEST_PICK:-}"' \
  'case "$*" in' \
  '  *"Режим следующей редакции Topic"*) print -r -- "Clean Successor"; exit 0 ;;' \
  '  *"Архивировать исходную Topic"*) print -r -- "${ZK_TEST_ARCHIVE_SOURCE:-Нет}"; exit 0 ;;' \
  '  *"Привязать memo к key topic"*) print -r -- "Да"; exit 0 ;;' \
  'esac' \
  'while IFS= read -r line; do' \
  '  identity="${${line#*$sep}%%$sep*}"' \
  '  if [[ "$*" == *"refine documents>"* ]]; then [[ "$identity" == "${ZK_TEST_REFINE_PICK:-}" ]] || continue; else [[ -z "$pick" || "$identity" == "$pick" ]] || continue; fi' \
  '  print -r -- "$line"; exit 0' \
  'done' \
  'exit 1' > "$fake_bin/fzf"

print -rl -- '#!/bin/zsh' 'print -r -- "30000000-0000-1000-8000-000000000001"' > "$fake_bin/uuidgen"
cp "$fake_bin/uuidgen" "$fake_bin/uuid"
print -rl -- '#!/bin/zsh' 'exit 0' > "$fake_bin/vim"
chmod +x "$fake_bin"/*

hash_tree() {
  find "$1" -type f -exec shasum -a 256 {} \; | LC_ALL=C sort
}

write_document() {
  local root="$1"
  local fname="$2"
  local type="$3"
  local title="$4"
  local key="${5:-}"
  local deprecated="no"
  local -a attrs

  if (( $# > 5 )) && [[ "$6" == yes || "$6" == no ]]; then
    deprecated="$6"
    shift 6
  else
    shift 5
  fi

  attrs=(
    "= $title" \
    ':date: 2026-09-11' \
    ":type: $type" \
    ":keywords: $type, membership" \
    ':author: test' \
    ":description: $title" \
    ":doclink: link:${fname}[${title}]" \
    ":docfilename: $fname"
  )
  [[ -z "$key" ]] || attrs+=(":key-topic: $key")
  [[ "$deprecated" == yes ]] && attrs+=(':deprecated:')
  attrs+=('' "$@")
  print -rl -- "${attrs[@]}" > "$root/notes/$fname"
}

prepare_root() {
  local root="$1"
  mkdir -p "$root/notes" "$root/all-todays" "$root/workspaces" "$root/.scripts"
}

run_reduce() {
  local root="$1"
  local label="$2"
  local answer="$3"

  if ! print -r -- "$answer" | env PATH="$fake_bin:$PATH" ZK_HOME="$root" \
    ZK_TEST_PICK="$topic_one" "$repo/scripts/zt-reduce.zsh" \
    > "$fixture/${label}.out" 2> "$fixture/${label}.err"; then
    cat "$fixture/${label}.err" >&2
    return 1
  fi
}

topic_one='10000000-0000-1000-8000-000000000001.adoc'
topic_two='10000000-0000-1000-8000-000000000002.adoc'
memo_one='10000000-0000-1000-8000-000000000003.adoc'
note_one='10000000-0000-1000-8000-000000000004.adoc'
other_note='10000000-0000-1000-8000-000000000005.adoc'
successor='30000000-0000-1000-8000-000000000001.adoc'

reduce_root="$fixture/Reduce линия Ж"
prepare_root "$reduce_root"
write_document "$reduce_root" "$topic_one" topic 'Линия - ключевая тема' 'Линия' no '== Связанные memo'
write_document "$reduce_root" "$topic_two" topic 'Линия - ключевая тема' 'Линия' no '== Связанные note'
write_document "$reduce_root" "$memo_one" memo 'Memo без прямой ссылки' 'Линия'
write_document "$reduce_root" "$note_one" note 'Note без прямой ссылки' 'Линия'
write_document "$reduce_root" "$other_note" note 'Другая линия' 'Другая'

env ZK_HOME="$reduce_root" "$repo/scripts/zt-check.zsh" > "$fixture/checker-ambiguous.out"
rg -qF 'AMBIGUOUS_TOPIC_LINE :key-topic: Линия' "$fixture/checker-ambiguous.out" || {
  print -ru2 -- 'FAIL: checker omitted ambiguous Topic line warning'
  exit 1
}
rg -qF "$topic_one" "$fixture/checker-ambiguous.out" || { print -ru2 -- 'FAIL: checker omitted first Topic UUID'; exit 1; }
rg -qF "$topic_two" "$fixture/checker-ambiguous.out" || { print -ru2 -- 'FAIL: checker omitted sibling Topic UUID'; exit 1; }

run_reduce "$reduce_root" reduce-success y
rg -qF "  sibling: $topic_two" "$fixture/reduce-success.out" || {
  print -ru2 -- 'FAIL: Reduce preview omitted active sibling Topic'
  exit 1
}
rg -qF "  deprecated: $memo_one" "$fixture/reduce-success.out" || {
  print -ru2 -- 'FAIL: Reduce preview omitted same-key Memo without direct Topic link'
  exit 1
}
rg -qFx ':deprecated:' "$reduce_root/notes/$memo_one" || {
  print -ru2 -- 'FAIL: Reduce did not archive same-key Memo'
  exit 1
}
! rg -qFx ':deprecated:' "$reduce_root/notes/$note_one" || {
  print -ru2 -- 'FAIL: Reduce archived durable Note'
  exit 1
}
! rg -qFx ':deprecated:' "$reduce_root/notes/$topic_two" || {
  print -ru2 -- 'FAIL: Reduce normalized active sibling Topic'
  exit 1
}
rg -qF "link:${successor}[Линия - ключевая тема]" "$reduce_root/notes/$note_one" || {
  print -ru2 -- 'FAIL: Reduce did not link same-key Note to successor'
  exit 1
}

checker_out="$fixture/checker.out"
env ZK_HOME="$reduce_root" "$repo/scripts/zt-check.zsh" > "$checker_out"
! rg -qF 'DEPRECATED_TOPIC_LINK' "$checker_out" || {
  print -ru2 -- 'FAIL: checker rejected Reduce provenance link to deprecated Topic'
  exit 1
}

cancel_root="$fixture/Reduce cancel"
prepare_root "$cancel_root"
write_document "$cancel_root" "$topic_one" topic 'Линия - ключевая тема' 'Линия'
write_document "$cancel_root" "$topic_two" topic 'Линия - ключевая тема' 'Линия'
write_document "$cancel_root" "$memo_one" memo 'Memo без прямой ссылки' 'Линия'
cancel_before="$(hash_tree "$cancel_root")"
run_reduce "$cancel_root" reduce-cancel n
[[ "$(hash_tree "$cancel_root")" == "$cancel_before" ]] || {
  print -ru2 -- 'FAIL: cancelled Reduce changed documents or activity'
  exit 1
}

binding_root="$fixture/Deprecated binding"
prepare_root "$binding_root"
write_document "$binding_root" "$topic_one" topic 'Archive - ключевая тема' 'Archive' yes
write_document "$binding_root" "$memo_one" memo 'Existing memo' 'Archive'
binding_before="$(hash_tree "$binding_root")"
if env ZK_HOME="$binding_root" zsh -c 'source "$1/scripts/lib/paths.zsh"; source "$1/scripts/lib/asciidoc.zsh"; source "$1/scripts/zettelkasten/lib/bindings.zsh"; zt_bind_memo_to_topic "$2" "$3"' zsh "$repo" "$memo_one" "$topic_one" > "$fixture/binding.out" 2> "$fixture/binding.err"; then
  print -ru2 -- 'FAIL: deprecated Topic accepted as a new binding target'
  exit 1
fi
rg -qF "DEPRECATED_TOPIC_TARGET: $topic_one" "$fixture/binding.err" || {
  print -ru2 -- 'FAIL: deprecated binding refusal omitted target'
  exit 1
}
[[ "$(hash_tree "$binding_root")" == "$binding_before" ]] || {
  print -ru2 -- 'FAIL: refused deprecated binding changed Vault bytes'
  exit 1
}

warning_root="$fixture/Deprecated link warning"
prepare_root "$warning_root"
write_document "$warning_root" "$topic_one" topic 'Archive - ключевая тема' 'Archive' yes
write_document "$warning_root" "$memo_one" memo 'Legacy ambiguous link' 'Archive' no \
  '== Связи' "* Topic: link:${topic_one}[Archive - ключевая тема]"
env ZK_HOME="$warning_root" "$repo/scripts/zt-check.zsh" > "$fixture/warning-check.out"
rg -qF "DEPRECATED_TOPIC_LINK notes/${memo_one} -> ${topic_one}" "$fixture/warning-check.out" || {
  print -ru2 -- 'FAIL: checker omitted warning for an ambiguous deprecated Topic link'
  exit 1
}

refine_root="$fixture/Refine archive source"
prepare_root "$refine_root"
write_document "$refine_root" "$topic_one" topic 'Исходная - ключевая тема' 'Исходная'
write_document "$refine_root" "$memo_one" memo 'Переносимое Memo' 'Исходная'
write_document "$refine_root" "$note_one" note 'Архивируемая Note' 'Исходная'
print -rl -- '= Заметки за 11-09-2026' '' > "$refine_root/all-todays/2026-09-11.adoc"
if ! print -rl -- 'Новая линия' 'y' | env PATH="$fake_bin:$PATH" ZK_HOME="$refine_root" \
  ZK_TEST_PICK="$topic_one" ZK_TEST_REFINE_PICK="$memo_one" ZK_TEST_ARCHIVE_SOURCE=Да \
  "$repo/scripts/zt-refine.zsh" > "$fixture/refine.out" 2> "$fixture/refine.err"; then
  cat "$fixture/refine.out" >&2
  cat "$fixture/refine.err" >&2
  exit 1
fi
rg -qF "  archive with source: $note_one" "$fixture/refine.out" || {
  print -ru2 -- 'FAIL: Refine preview omitted unselected Note archive candidate'
  exit 1
}
rg -qFx ':deprecated:' "$refine_root/notes/$note_one" || {
  print -ru2 -- 'FAIL: Refine archive-source did not archive unselected Note'
  exit 1
}

title_root="$fixture/Binding key over title"
prepare_root "$title_root"
write_document "$title_root" "$topic_one" topic 'Visible title differs' 'machine-key'
print -r -- 'Memo title' | env PATH="$fake_bin:$PATH" ZK_HOME="$title_root" ZK_TEST_PICK="$topic_one" \
  "$repo/scripts/zettelkasten/zt-memo.zsh" > "$fixture/memo.out" 2> "$fixture/memo.err"
rg -qFx ':key-topic: machine-key' "$title_root/notes/$successor" || {
  print -ru2 -- 'FAIL: Memo binding derived key-topic from Topic title'
  exit 1
}

print -r -- 'PASS: Topic membership, Reduce selection, deprecated bindings and Refine lifecycle'
