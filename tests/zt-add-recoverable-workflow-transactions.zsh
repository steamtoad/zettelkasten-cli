#!/bin/zsh

#------------------------------------------------------------------------------
# zt-add-recoverable-workflow-transactions.zsh
# Тип: Runtime Regression Test
# Назначение: проверить manifest, rollback, locking и persistent recovery
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset null_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-transactions.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

fake_bin="$fixture/bin"
mkdir -p "$fake_bin"

print -rl -- \
  '#!/bin/zsh' \
  'counter="$ZK_TEST_COUNTER"' \
  'value=1' \
  '[[ ! -f "$counter" ]] || value=$(( $(<"$counter") + 1 ))' \
  'print -r -- "$value" > "$counter"' \
  'printf "f%07x-0000-1000-8000-000000000001\n" "$value"' > "$fake_bin/uuid"
cp "$fake_bin/uuid" "$fake_bin/uuidgen"
print -rl -- '#!/bin/zsh' 'exit ${ZK_TEST_EDITOR_EXIT:-0}' > "$fake_bin/vim"
print -rl -- \
  '#!/bin/zsh' \
  'rows=("${(@f)$(cat)}")' \
  'if [[ "$*" == *"Привязать"* ]]; then' \
  '  print -r -- "Да"' \
  'else' \
  '  print -r -- "${rows[1]-}"' \
  'fi' > "$fake_bin/fzf"
chmod +x "$fake_bin/uuid" "$fake_bin/uuidgen" "$fake_bin/vim" "$fake_bin/fzf"

tail_name='10000000-0000-1000-8000-000000000001.adoc'

file_hash() {
  cksum -- "$1" | awk '{ print $1 ":" $2 }'
}

file_mode() {
  if stat -f '%Lp' "$1" >/dev/null 2>&1; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' "$1"
  fi
}

note_count() {
  local -a files
  files=("$1"/notes/*.adoc(N))
  print -r -- "${#files}"
}

write_vault() {
  local root="$1"
  local today="$(date '+%Y-%m-%d')"
  local display_date="$(date '+%d-%m-%Y')"

  mkdir -p "$root/notes" "$root/all-todays" "$root/.scripts"
  print -rl -- \
    '= Diary tail' \
    ":date: $today" \
    ':type: diary' \
    ':keywords: diary' \
    ':author: test' \
    ':description: Diary tail' \
    ":doclink: link:${tail_name}[Diary tail]" \
    ":docfilename: $tail_name" \
    '' \
    'tail body' > "$root/notes/$tail_name"
  print -rl -- "= Заметки за $display_date" '' > "$root/all-todays/$today.adoc"
  print -r -- "$tail_name" > "$root/.last-diary"
  chmod 0640 "$root/notes/$tail_name"
}

write_memo_vault() {
  local root="$1"
  local broken="${2:-no}"
  local today="$(date '+%Y-%m-%d')"
  local display_date="$(date '+%d-%m-%Y')"

  mkdir -p "$root/notes" "$root/all-todays" "$root/.scripts"
  print -rl -- \
    '= Source Memo' \
    ":date: $today" \
    ':type: memo' \
    ':keywords: memo, transaction' \
    ':author: test' \
    ':description: Source Memo' \
    ":doclink: link:${tail_name}[Source Memo]" \
    ":docfilename: $tail_name" \
    ':key-topic: Transactions' \
    '' \
    'memo body' > "$root/notes/$tail_name"
  [[ "$broken" != yes ]] || print -r -- '----' >> "$root/notes/$tail_name"
  print -rl -- "= Заметки за $display_date" '' > "$root/all-todays/$today.adoc"
}

run_diary() {
  local root="$1"
  shift
  env PATH="$fake_bin:$PATH" ZK_HOME="$root" ZK_TEST_COUNTER="$fixture/uuid-counter" \
    "$@" "$repo/scripts/zt-diary.zsh"
}

run_note() {
  local root="$1"
  local title="$2"
  shift 2
  print -r -- "$title" | env PATH="$fake_bin:$PATH" ZK_HOME="$root" \
    ZK_TEST_COUNTER="$fixture/uuid-counter" "$@" "$repo/scripts/zt-note.zsh"
}

run_continue() {
  local root="$1"
  local title="$2"
  shift 2
  print -r -- "$title" | env PATH="$fake_bin:$PATH" ZK_HOME="$root" \
    ZK_TEST_COUNTER="$fixture/uuid-counter" "$@" "$repo/scripts/zt-continue.zsh"
}

transaction_with_status() {
  local root="$1"
  local expected="$2"
  local transaction_dir

  for transaction_dir in "$root/.state/transactions"/*(N/); do
    [[ "$(<"$transaction_dir/status")" == "$expected" ]] && {
      print -r -- "$transaction_dir"
      return 0
    }
  done
  return 1
}

# Invalid staging never reaches the original Vault.
invalid_root="$fixture/invalid plan Ж"
write_vault "$invalid_root"
rm -rf -- "$invalid_root/all-todays"
print -r -- blocked > "$invalid_root/all-todays"
invalid_hash="$(file_hash "$invalid_root/notes/$tail_name")"
if run_diary "$invalid_root" > "$fixture/invalid.out" 2> "$fixture/invalid.err"; then
  print -ru2 -- 'FAIL: invalid transaction plan succeeded'
  exit 1
fi
[[ "$(file_hash "$invalid_root/notes/$tail_name")" == "$invalid_hash" && "$(<"$invalid_root/.last-diary")" == "$tail_name" ]] || {
  print -ru2 -- 'FAIL: invalid plan changed knowledge or state'
  exit 1
}
[[ -z "$(transaction_with_status "$invalid_root" applying 2>/dev/null)" ]] || { print -ru2 -- 'FAIL: invalid plan remained apply-ready'; exit 1; }

# Happy path commits one coherent Diary chain/journal/state transaction.
happy_root="$fixture/happy Vault"
write_vault "$happy_root"
run_diary "$happy_root" > "$fixture/happy.out" 2> "$fixture/happy.err"
if ! happy_txn="$(transaction_with_status "$happy_root" committed)"; then
  print -ru2 -- 'FAIL: successful workflow did not persist a committed transaction manifest'
  exit 1
fi
new_name="$(<"$happy_root/.last-diary")"
[[ "$new_name" != "$tail_name" && -f "$happy_root/notes/$new_name" ]] || { print -ru2 -- 'FAIL: committed Diary missing'; exit 1; }
rg -qF "link:${new_name}[Следующая запись]" "$happy_root/notes/$tail_name" || { print -ru2 -- 'FAIL: committed previous link missing'; exit 1; }
rg -qF "link:${tail_name}[Предыдущая запись]" "$happy_root/notes/$new_name" || { print -ru2 -- 'FAIL: committed reciprocal link missing'; exit 1; }
rg -qF "link:../notes/${new_name}" "$happy_root/all-todays/$(date '+%Y-%m-%d').adoc" || { print -ru2 -- 'FAIL: committed journal entry missing'; exit 1; }
[[ -s "$happy_txn/manifest" ]] || { print -ru2 -- 'FAIL: committed manifest missing'; exit 1; }

# Creation with activity and reciprocal binding is committed as one write set.
binding_root="$fixture/note binding"
write_memo_vault "$binding_root"
run_note "$binding_root" 'Transactional Note' > "$fixture/binding.out" 2> "$fixture/binding.err"
binding_link="$(<"$fixture/binding.out")"
binding_name="${${binding_link#link:}%%\[*}"
[[ -f "$binding_root/notes/$binding_name" ]] || { print -ru2 -- 'FAIL: transactional Note missing'; exit 1; }
rg -qF "link:${binding_name}[Transactional Note]" "$binding_root/notes/$tail_name" || { print -ru2 -- 'FAIL: reciprocal Memo binding missing'; exit 1; }
rg -qF "link:${tail_name}[Source Memo]" "$binding_root/notes/$binding_name" || { print -ru2 -- 'FAIL: Note binding missing'; exit 1; }
rg -qF "link:../notes/${binding_name}" "$binding_root/all-todays/$(date '+%Y-%m-%d').adoc" || { print -ru2 -- 'FAIL: bound Note journal entry missing'; exit 1; }

# Invalid second binding is rejected in staging without publishing the first.
invalid_binding_root="$fixture/invalid binding"
write_memo_vault "$invalid_binding_root" yes
invalid_binding_hash="$(file_hash "$invalid_binding_root/notes/$tail_name")"
if run_note "$invalid_binding_root" 'Must not publish' > "$fixture/invalid-binding.out" 2> "$fixture/invalid-binding.err"; then
  print -ru2 -- 'FAIL: invalid reciprocal binding succeeded'
  exit 1
fi
[[ "$(file_hash "$invalid_binding_root/notes/$tail_name")" == "$invalid_binding_hash" && \
   "$(note_count "$invalid_binding_root")" == 1 ]] || {
  print -ru2 -- 'FAIL: invalid binding published a partial write set'
  exit 1
}

# Continue commits its new Memo, both chain links and activity together.
continue_root="$fixture/continue chain"
write_memo_vault "$continue_root"
run_continue "$continue_root" 'Next Memo' > "$fixture/continue.out" 2> "$fixture/continue.err"
continue_link="$(<"$fixture/continue.out")"
continue_name="${${continue_link#link:}%%\[*}"
rg -qF "link:${continue_name}[Следующее memo]" "$continue_root/notes/$tail_name" || { print -ru2 -- 'FAIL: Continue forward link missing'; exit 1; }
rg -qF "link:${tail_name}[Предыдущее memo]" "$continue_root/notes/$continue_name" || { print -ru2 -- 'FAIL: Continue previous link missing'; exit 1; }
rg -qF "link:../notes/${continue_name}" "$continue_root/all-todays/$(date '+%Y-%m-%d').adoc" || { print -ru2 -- 'FAIL: Continue journal entry missing'; exit 1; }

# Apply failure with successful rollback restores hashes, modes and absence.
rollback_root="$fixture/full rollback"
write_vault "$rollback_root"
rollback_hash="$(file_hash "$rollback_root/notes/$tail_name")"
rollback_mode="$(file_mode "$rollback_root/notes/$tail_name")"
if run_diary "$rollback_root" env ZK_TXN_FAIL_APPLY_AT=2 > "$fixture/rollback.out" 2> "$fixture/rollback.err"; then
  print -ru2 -- 'FAIL: injected apply failure succeeded'
  exit 1
fi
[[ "$(file_hash "$rollback_root/notes/$tail_name")" == "$rollback_hash" && \
   "$(file_mode "$rollback_root/notes/$tail_name")" == "$rollback_mode" && \
   "$(<"$rollback_root/.last-diary")" == "$tail_name" ]] || {
  print -ru2 -- 'FAIL: full rollback did not restore original state'
  exit 1
}
[[ "$(note_count "$rollback_root")" == 1 ]] || { print -ru2 -- 'FAIL: full rollback left a partial document'; exit 1; }

# Rollback failure reports RECOVERY_REQUIRED and keeps usable backups.
recovery_root="$fixture/recovery required"
write_vault "$recovery_root"
recovery_hash="$(file_hash "$recovery_root/notes/$tail_name")"
if run_diary "$recovery_root" env ZK_TXN_FAIL_APPLY_AT=2 ZK_TXN_FAIL_ROLLBACK_AT=1 \
  > "$fixture/recovery.out" 2> "$fixture/recovery.err"; then
  print -ru2 -- 'FAIL: rollback failure succeeded'
  exit 1
fi
rg -qF 'RECOVERY_REQUIRED' "$fixture/recovery.err" || { print -ru2 -- 'FAIL: rollback failure omitted RECOVERY_REQUIRED'; exit 1; }
recovery_txn="$(transaction_with_status "$recovery_root" recovery_required)"
[[ -f "$recovery_txn/entries/0001/backup" ]] || { print -ru2 -- 'FAIL: recovery backup missing'; exit 1; }

env ZK_HOME="$recovery_root" zsh "$repo/scripts/lib/transaction.zsh" recover "$recovery_txn"
[[ "$(file_hash "$recovery_root/notes/$tail_name")" == "$recovery_hash" ]] || { print -ru2 -- 'FAIL: explicit recovery did not restore bytes'; exit 1; }
after_recovery="$(file_hash "$recovery_root/notes/$tail_name")"
env ZK_HOME="$recovery_root" zsh "$repo/scripts/lib/transaction.zsh" recover "$recovery_txn"
[[ "$(file_hash "$recovery_root/notes/$tail_name")" == "$after_recovery" ]] || { print -ru2 -- 'FAIL: repeated recovery was not idempotent'; exit 1; }

# A stale source fingerprint preserves the external version and creates no Diary.
stale_root="$fixture/stale plan"
write_vault "$stale_root"
if run_diary "$stale_root" env ZK_TXN_TEST_EXTERNAL_EDIT_AT=1 ZK_TXN_TEST_EXTERNAL_TEXT='Vim external bytes' \
  > "$fixture/stale.out" 2> "$fixture/stale.err"; then
  print -ru2 -- 'FAIL: stale plan succeeded'
  exit 1
fi
rg -qF 'STATE_CONFLICT' "$fixture/stale.err" || { print -ru2 -- 'FAIL: stale plan omitted STATE_CONFLICT'; exit 1; }
rg -qF 'Vim external bytes' "$stale_root/notes/$tail_name" || { print -ru2 -- 'FAIL: stale plan lost external bytes'; exit 1; }
[[ "$(<"$stale_root/.last-diary")" == "$tail_name" ]] || { print -ru2 -- 'FAIL: stale plan changed Diary state'; exit 1; }
[[ "$(note_count "$stale_root")" == 1 ]] || { print -ru2 -- 'FAIL: stale plan created a Diary'; exit 1; }

# SIGKILL leaves persistent evidence visible to writer/checker until recovery.
kill_root="$fixture/killed apply"
write_vault "$kill_root"
kill_hash="$(file_hash "$kill_root/notes/$tail_name")"
if run_diary "$kill_root" env ZK_TXN_KILL_AFTER_APPLY=1 > "$fixture/kill.out" 2> "$fixture/kill.err"; then
  print -ru2 -- 'FAIL: SIGKILL injection succeeded'
  exit 1
fi
kill_txn="$(transaction_with_status "$kill_root" applying)"
if run_diary "$kill_root" > "$fixture/killed-writer.out" 2> "$fixture/killed-writer.err"; then
  print -ru2 -- 'FAIL: writer ignored unresolved transaction'
  exit 1
fi
rg -qF 'RECOVERY_REQUIRED' "$fixture/killed-writer.err" || { print -ru2 -- 'FAIL: next writer omitted RECOVERY_REQUIRED'; exit 1; }
if env ZK_HOME="$kill_root" "$repo/scripts/zt-check.zsh" > "$fixture/killed-check.out" 2> "$fixture/killed-check.err"; then
  print -ru2 -- 'FAIL: checker accepted unresolved transaction'
  exit 1
fi
rg -qF 'RECOVERY_REQUIRED' "$fixture/killed-check.out" || { print -ru2 -- 'FAIL: checker omitted unresolved transaction'; exit 1; }
env ZK_HOME="$kill_root" zsh "$repo/scripts/lib/transaction.zsh" recover "$kill_txn"
[[ "$(file_hash "$kill_root/notes/$tail_name")" == "$kill_hash" ]] || { print -ru2 -- 'FAIL: killed transaction recovery did not restore bytes'; exit 1; }

# Cooperative lock rejects a concurrent Diary writer without a second next link.
lock_root="$fixture/concurrent writers"
write_vault "$lock_root"
ready="$fixture/transaction-ready"
continue_file="$fixture/transaction-continue"
run_diary "$lock_root" env ZK_TXN_TEST_READY_FILE="$ready" ZK_TXN_TEST_CONTINUE_FILE="$continue_file" \
  > "$fixture/writer-one.out" 2> "$fixture/writer-one.err" &
writer_pid=$!
for attempt in {1..200}; do
  [[ -f "$ready" ]] && break
  sleep 0.05
done
[[ -f "$ready" ]] || { print -ru2 -- 'FAIL: first writer did not reach transaction barrier'; exit 1; }
if run_diary "$lock_root" > "$fixture/writer-two.out" 2> "$fixture/writer-two.err"; then
  print -ru2 -- 'FAIL: concurrent writer bypassed lock'
  exit 1
fi
rg -qF 'LOCKED' "$fixture/writer-two.err" || { print -ru2 -- 'FAIL: concurrent writer omitted LOCKED'; exit 1; }
: > "$continue_file"
wait "$writer_pid"
[[ "$(rg -c 'Следующая запись' "$lock_root/notes/$tail_name")" == 1 ]] || { print -ru2 -- 'FAIL: concurrent writers created multiple next links'; exit 1; }

print -r -- 'PASS: recoverable workflow transactions'
