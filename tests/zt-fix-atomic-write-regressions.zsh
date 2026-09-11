#!/bin/zsh

#------------------------------------------------------------------------------
# zt-fix-atomic-write-regressions.zsh
# Тип: Runtime Regression Test
# Назначение: проверить исправления пяти регрессий атомарной записи
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset null_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-atomic-regressions.XXXXXX")"
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
  zk_file_mode "$1"
}

owner_group_file() {
  zk_file_owner_group "$1"
}

assert_failure() {
  local message="$1"
  shift

  if "$@"; then
    print -ru2 -- "FAIL: $message"
    exit 1
  fi
}

# WRITE-SAFE-001: ordinary files retain bytes, mode and owner/group.
plain="$fixture/plain.adoc"
print -rl -- '= Plain' ':type: note' '' > "$plain"
chmod 0640 "$plain"
plain_mode="$(mode_file "$plain")"
plain_owner="$(owner_group_file "$plain")"
zk_append_text_atomic "$plain" 'body'
[[ "$(mode_file "$plain")" == "$plain_mode" ]] || {
  print -ru2 -- 'FAIL: ordinary atomic replacement changed mode'
  exit 1
}
[[ "$(owner_group_file "$plain")" == "$plain_owner" ]] || {
  print -ru2 -- 'FAIL: ordinary atomic replacement changed owner/group'
  exit 1
}
rg -qFx 'body' "$plain" || {
  print -ru2 -- 'FAIL: ordinary atomic replacement omitted content'
  exit 1
}

portable_root="$fixture/Root with space Ж"
mkdir -p "$portable_root"
portable_file="$portable_root/Документ с пробелом.adoc"
print -rl -- '= Portable' ':type: note' '' > "$portable_file"
zk_append_text_atomic "$portable_file" 'unicode path body'
rg -qFx 'unicode path body' "$portable_file" || {
  print -ru2 -- 'FAIL: atomic replacement failed for a root with spaces/Unicode'
  exit 1
}

# Metadata discovery and ownership mismatches must fail before replacement.
metadata_failure="$fixture/metadata-failure.adoc"
print -rl -- '= Metadata' ':type: note' '' > "$metadata_failure"
metadata_hash="$(hash_file "$metadata_failure")"
function zk_file_acl_state() { return 1 }
assert_failure 'ACL discovery failure was reported as success' \
  zk_append_text_atomic "$metadata_failure" 'must not appear'
[[ "$(hash_file "$metadata_failure")" == "$metadata_hash" ]] || {
  print -ru2 -- 'FAIL: ACL discovery failure changed destination bytes'
  exit 1
}
source "$repo/scripts/lib/asciidoc.zsh"

owner_failure="$fixture/owner-failure.adoc"
print -rl -- '= Owner' ':type: note' '' > "$owner_failure"
owner_hash="$(hash_file "$owner_failure")"
function zk_file_owner_group() {
  if [[ "$1" == "$owner_failure" ]]; then
    print -r -- '1000:1000'
  else
    print -r -- '1001:1001'
  fi
}
assert_failure 'unsupported owner/group transfer was reported as success' \
  zk_append_text_atomic "$owner_failure" 'must not appear'
[[ "$(hash_file "$owner_failure")" == "$owner_hash" ]] || {
  print -ru2 -- 'FAIL: owner/group refusal changed destination bytes'
  exit 1
}
source "$repo/scripts/lib/asciidoc.zsh"

acl_result='SKIP: native ACL fixture unavailable'
acl_file="$fixture/acl.adoc"
print -rl -- '= ACL' ':type: note' '' > "$acl_file"
if [[ "$(uname -s)" == 'Darwin' ]]; then
  if chmod +a 'everyone allow read' "$acl_file" 2>/dev/null; then
    acl_hash="$(hash_file "$acl_file")"
    acl_before="$(ls -lde "$acl_file")"
    assert_failure 'ACL-bearing destination was silently replaced' \
      zk_append_text_atomic "$acl_file" 'must not appear'
    [[ "$(hash_file "$acl_file")" == "$acl_hash" && "$(ls -lde "$acl_file")" == "$acl_before" ]] || {
      print -ru2 -- 'FAIL: refused ACL replacement changed the destination'
      exit 1
    }
    acl_result='PASS: macOS ACL detected and replacement refused without mutation'
  fi
elif command -v setfacl >/dev/null 2>&1 && command -v getfacl >/dev/null 2>&1; then
  if setfacl -m "u:$(id -u):r--" "$acl_file" 2>/dev/null; then
    acl_hash="$(hash_file "$acl_file")"
    acl_before="$(getfacl -p "$acl_file")"
    assert_failure 'ACL-bearing destination was silently replaced' \
      zk_append_text_atomic "$acl_file" 'must not appear'
    [[ "$(hash_file "$acl_file")" == "$acl_hash" && "$(getfacl -p "$acl_file")" == "$acl_before" ]] || {
      print -ru2 -- 'FAIL: refused ACL replacement changed the destination'
      exit 1
    }
    acl_result='PASS: Linux ACL detected and replacement refused without mutation'
  fi
fi
print -r -- "$acl_result"

fake_bin="$fixture/bin"
mkdir -p "$fake_bin"
real_awk="$(command -v awk)"

print -rl -- \
  '#!/bin/zsh' \
  'case "$*" in' \
  '  *"reduce topic>"*|*"refine source topic>"*) IFS= read -r line; print -r -- "$line" ;;' \
  '  *"refine documents>"*) while IFS= read -r line; do [[ "$line" == *10000001-0000-1000-8000-000000000000.adoc* ]] && print -r -- "$line"; done ;;' \
  '  *"Архивировать исходную Topic"*) print -r -- "Нет" ;;' \
  '  *"Режим следующей редакции Topic"*) print -r -- "${ZK_TEST_MODE:-Clean Successor}" ;;' \
  '  *) IFS= read -r line; print -r -- "$line" ;;' \
  'esac' > "$fake_bin/fzf"

print -rl -- \
  '#!/bin/zsh' \
  'name="20000000-0000-1000-8000-000000000000"' \
  'if [[ -n "${ZK_TEST_LATE_COLLISION:-}" ]]; then print -rn -- "LATE FOREIGN" > "${name}.adoc"; fi' \
  'print -r -- "$name"' > "$fake_bin/uuid"
cp "$fake_bin/uuid" "$fake_bin/uuidgen"

print -rl -- \
  '#!/bin/zsh' \
  'if [[ -n "${ZK_TEST_FAIL_FULL_COPY:-}" && "$*" == *new_fname=* ]]; then' \
  '  [[ "${ZK_TEST_FAIL_FULL_COPY}" == partial ]] && print -r -- "= partial"' \
  '  exit 74' \
  'fi' \
  'exec "$ZK_TEST_REAL_AWK" "$@"' > "$fake_bin/awk"

print -rl -- \
  '#!/bin/zsh' \
  'last="${@[-1]}"' \
  'if [[ -n "${ZK_TEST_REPLACE_SUCCESSOR_BEFORE_FAIL:-}" && "$last" == "10000000-0000-1000-8000-000000000000.adoc" ]]; then' \
  '  rm -f -- "$ZK_TEST_NEW_NAME"' \
  '  print -rn -- "REPLACED FOREIGN" > "$ZK_TEST_NEW_NAME"' \
  '  exit 73' \
  'fi' \
  'if [[ -n "${ZK_TEST_FAIL_MV_DEST:-}" && "${last:t}" == "$ZK_TEST_FAIL_MV_DEST" ]]; then exit 73; fi' \
  'exec /bin/mv "$@"' > "$fake_bin/mv"

print -rl -- \
  '#!/bin/zsh' \
  '[[ -n "${ZK_TEST_EDITOR_MARKER:-}" ]] && print -r -- called > "$ZK_TEST_EDITOR_MARKER"' \
  'exit 0' > "$fake_bin/vim"
chmod +x "$fake_bin"/*

write_vault() {
  local root="$1"
  local with_today="${2:-no}"
  local old='10000000-0000-1000-8000-000000000000.adoc'
  local note='10000001-0000-1000-8000-000000000000.adoc'
  local title='Atomic - ключевая тема'

  mkdir -p "$root/notes" "$root/all-todays"
  print -rl -- \
    "= $title" ':date: 2026-09-11' ':keywords: topic, atomic' ':type: topic' \
    ':author: test' ":description: $title" ":doclink: link:${old}[$title]" \
    ":docfilename: $old" ':key-topic: Atomic' '' '== Связанные note' '' > "$root/notes/$old"
  print -rl -- \
    '= Durable Note' ':date: 2026-09-11' ':keywords: note, atomic' ':type: note' \
    ':author: test' ':description: Durable Note' \
    ":doclink: link:${note}[Durable Note]" ":docfilename: $note" \
    ':key-topic: Atomic' '' '== Связи' '' > "$root/notes/$note"

  if [[ "$with_today" == yes ]]; then
    print -rl -- "= Заметки за $(date +'%d-%m-%Y')" '' '* existing' > "$root/all-todays/$(date +'%Y-%m-%d').adoc"
  fi
}

run_refine() {
  local root="$1"
  local label="$2"
  shift 2

  print -rl -- 'New Line' 'y' | env \
    PATH="$fake_bin:$PATH" \
    ZK_HOME="$root" \
    ZK_TEST_REAL_AWK="$real_awk" \
    "$@" \
    "$repo/scripts/zt-refine.zsh" > "$fixture/${label}.out" 2> "$fixture/${label}.err"
}

new_name='20000000-0000-1000-8000-000000000000.adoc'

# WRITE-SAFE-003: Refine must never delete a destination it did not create.
for collision_kind in regular live-symlink dangling-symlink; do
  root="$fixture/refine-$collision_kind"
  write_vault "$root"
  case "$collision_kind" in
    regular)
      print -rn -- 'FOREIGN DOCUMENT' > "$root/notes/$new_name"
      ;;
    live-symlink)
      print -rn -- 'LIVE TARGET' > "$root/live-target"
      ln -s "$root/live-target" "$root/notes/$new_name"
      ;;
    dangling-symlink)
      ln -s "$root/missing-target" "$root/notes/$new_name"
      ;;
  esac
  collision_before="$(ls -ld "$root/notes/$new_name")"
  if run_refine "$root" "refine-$collision_kind"; then
    print -ru2 -- "FAIL: Refine accepted $collision_kind collision"
    exit 1
  fi
  [[ -e "$root/notes/$new_name" || -L "$root/notes/$new_name" ]] || {
    print -ru2 -- "FAIL: Refine rollback deleted $collision_kind destination"
    exit 1
  }
  [[ "$(ls -ld "$root/notes/$new_name")" == "$collision_before" ]] || {
    print -ru2 -- "FAIL: Refine rollback changed $collision_kind destination"
    exit 1
  }
done

late_root="$fixture/refine-late"
write_vault "$late_root"
if run_refine "$late_root" refine-late env ZK_TEST_LATE_COLLISION=1; then
  print -ru2 -- 'FAIL: Refine accepted a late collision'
  exit 1
fi
[[ "$(<"$late_root/notes/$new_name")" == 'LATE FOREIGN' ]] || {
  print -ru2 -- 'FAIL: Refine rollback removed or changed late collision'
  exit 1
}

identity_root="$fixture/refine-identity"
write_vault "$identity_root"
if run_refine "$identity_root" refine-identity env \
  ZK_TEST_REPLACE_SUCCESSOR_BEFORE_FAIL=1 \
  ZK_TEST_NEW_NAME="$identity_root/notes/$new_name"; then
  print -ru2 -- 'FAIL: Refine identity-change injection succeeded'
  exit 1
fi
[[ "$(<"$identity_root/notes/$new_name")" == 'REPLACED FOREIGN' ]] || {
  print -ru2 -- 'FAIL: Refine rollback deleted changed destination identity'
  exit 1
}
rg -qF 'preserved changed destination identity' "$fixture/refine-identity.err" || {
  print -ru2 -- 'FAIL: Refine omitted identity-conflict diagnostic'
  exit 1
}

refine_success="$fixture/refine-success"
write_vault "$refine_success"
run_refine "$refine_success" refine-success
rg -qF 'Refine complete' "$fixture/refine-success.out" || {
  print -ru2 -- 'FAIL: valid Refine did not complete'
  exit 1
}
[[ -f "$refine_success/notes/$new_name" ]] || {
  print -ru2 -- 'FAIL: valid Refine omitted successor'
  exit 1
}

run_reduce() {
  local root="$1"
  local label="$2"
  local mode="$3"
  shift 3

  print -r -- y | env \
    PATH="$fake_bin:$PATH" \
    ZK_HOME="$root" \
    ZK_TEST_MODE="$mode" \
    ZK_TEST_REAL_AWK="$real_awk" \
    "$@" \
    "$repo/scripts/zt-reduce.zsh" > "$fixture/${label}.out" 2> "$fixture/${label}.err"
}

# WRITE-SAFE-002/004: Full Copy producer failure is observed before publication.
for producer_case in empty partial; do
  root="$fixture/full-copy-$producer_case"
  write_vault "$root"
  old_hash="$(hash_file "$root/notes/10000000-0000-1000-8000-000000000000.adoc")"
  editor_marker="$fixture/editor-$producer_case"
  if run_reduce "$root" "full-copy-$producer_case" 'Full Copy' env \
    ZK_TEST_FAIL_FULL_COPY="$producer_case" \
    ZK_TEST_EDITOR_MARKER="$editor_marker"; then
    print -ru2 -- "FAIL: Full Copy ignored $producer_case producer failure"
    exit 1
  fi
  [[ ! -e "$root/notes/$new_name" && ! -e "$editor_marker" ]] || {
    print -ru2 -- "FAIL: failed Full Copy published successor or launched editor ($producer_case)"
    exit 1
  }
  [[ "$(hash_file "$root/notes/10000000-0000-1000-8000-000000000000.adoc")" == "$old_hash" ]] || {
    print -ru2 -- "FAIL: failed Full Copy changed old Topic ($producer_case)"
    exit 1
  }
  ! rg -qF 'Reduce complete' "$fixture/full-copy-$producer_case.out" || {
    print -ru2 -- "FAIL: failed Full Copy printed success ($producer_case)"
    exit 1
  }
  rg -qF "$root/all-todays/$(date +'%Y-%m-%d').adoc" "$fixture/full-copy-$producer_case.err" || {
    print -ru2 -- "FAIL: failed Full Copy omitted newly created all-todays ($producer_case)"
    exit 1
  }
done

# A successor collision after journal creation lists only the journal and
# preserves the foreign destination.
early_collision="$fixture/reduce-early-collision"
write_vault "$early_collision"
print -rn -- 'REDUCE FOREIGN' > "$early_collision/notes/$new_name"
if run_reduce "$early_collision" reduce-early-collision 'Clean Successor'; then
  print -ru2 -- 'FAIL: Reduce accepted successor collision'
  exit 1
fi
[[ "$(<"$early_collision/notes/$new_name")" == 'REDUCE FOREIGN' ]] || {
  print -ru2 -- 'FAIL: Reduce changed foreign successor collision'
  exit 1
}
early_err="$fixture/reduce-early-collision.err"
rg -qF "$early_collision/all-todays/$(date +'%Y-%m-%d').adoc" "$early_err" || {
  print -ru2 -- 'FAIL: early Reduce collision omitted new all-todays'
  exit 1
}
! rg -qFx '10000000-0000-1000-8000-000000000000.adoc' "$early_err" || {
  print -ru2 -- 'FAIL: early Reduce collision claimed old Topic changed'
  exit 1
}
! rg -qFx '10000001-0000-1000-8000-000000000000.adoc' "$early_err" || {
  print -ru2 -- 'FAIL: early Reduce collision claimed Note changed'
  exit 1
}

full_success="$fixture/full-copy-success"
write_vault "$full_success"
print -r -- 'Full Copy body' >> "$full_success/notes/10000000-0000-1000-8000-000000000000.adoc"
run_reduce "$full_success" full-copy-success 'Full Copy'
rg -qF 'Reduce complete' "$fixture/full-copy-success.out" || {
  print -ru2 -- 'FAIL: valid Full Copy did not complete'
  exit 1
}
rg -qF 'Full Copy body' "$full_success/notes/$new_name" || {
  print -ru2 -- 'FAIL: valid Full Copy omitted source body'
  exit 1
}
rg -q '^:type: topic$' "$full_success/notes/$new_name" || {
  print -ru2 -- 'FAIL: valid Full Copy produced invalid Topic metadata'
  exit 1
}

# Recovery diagnostics include existing and newly created all-todays.
for today_case in new existing; do
  root="$fixture/recovery-$today_case"
  if [[ "$today_case" == existing ]]; then
    write_vault "$root" yes
  else
    write_vault "$root"
  fi
  if run_reduce "$root" "recovery-$today_case" 'Clean Successor' env \
    ZK_TEST_FAIL_MV_DEST='10000001-0000-1000-8000-000000000000.adoc'; then
    print -ru2 -- "FAIL: Reduce ignored Note failure ($today_case today)"
    exit 1
  fi
  recovery_err="$fixture/recovery-$today_case.err"
  rg -qF "$root/all-todays/$(date +'%Y-%m-%d').adoc" "$recovery_err" || {
    print -ru2 -- "FAIL: recovery list omitted $today_case all-todays"
    exit 1
  }
  rg -qFx "$new_name" "$recovery_err" || {
    print -ru2 -- 'FAIL: recovery list omitted successor'
    exit 1
  }
  rg -qFx '10000000-0000-1000-8000-000000000000.adoc' "$recovery_err" || {
    print -ru2 -- 'FAIL: recovery list omitted changed old Topic'
    exit 1
  }
  ! rg -qFx '10000001-0000-1000-8000-000000000000.adoc' "$recovery_err" || {
    print -ru2 -- 'FAIL: recovery list claimed failed Note destination changed'
    exit 1
  }
done

# TOPIC-003/WRITE-SAFE-004: direct and sourced constructors reject empty keys.
topic_root="$fixture/topic-empty"
if env PATH="$fake_bin:$PATH" ZK_HOME="$topic_root" \
  "$repo/scripts/objects/topic-create.zsh" 'Title' '' > "$fixture/topic-empty.out" 2> "$fixture/topic-empty.err"; then
  print -ru2 -- 'FAIL: standalone Topic constructor accepted an empty key'
  exit 1
fi
rg -qF ':key-topic: is empty' "$fixture/topic-empty.err" || {
  print -ru2 -- 'FAIL: standalone Topic constructor omitted key diagnostic'
  exit 1
}
[[ ! -d "$topic_root/notes" ]] || {
  print -ru2 -- 'FAIL: empty Topic key mutated ZK_HOME before preflight'
  exit 1
}

if env PATH="$fake_bin:$PATH" ZK_HOME="$topic_root" zsh -c \
  'source "$1"; zk_topic_create "Title" ""' zsh "$repo/scripts/objects/topic-create.zsh" \
  > "$fixture/topic-sourced.out" 2> "$fixture/topic-sourced.err"; then
  print -ru2 -- 'FAIL: sourced Topic constructor accepted an empty key'
  exit 1
fi
[[ ! -d "$topic_root/notes" ]] || {
  print -ru2 -- 'FAIL: sourced empty Topic key mutated ZK_HOME before preflight'
  exit 1
}

producer_root="$fixture/topic-producer"
if env PATH="$fake_bin:$PATH" ZK_HOME="$producer_root" zsh -c \
  'source "$1"; function zk_metadata() { print -r -- "= partial"; return 74; }; zk_topic_create "Title" "Key"' \
  zsh "$repo/scripts/objects/topic-create.zsh" \
  > "$fixture/topic-producer.out" 2> "$fixture/topic-producer.err"; then
  print -ru2 -- 'FAIL: Topic constructor masked metadata producer failure'
  exit 1
fi
[[ -z "$(find "$producer_root/notes" -maxdepth 1 -name '*.adoc' -print 2>/dev/null)" ]] || {
  print -ru2 -- 'FAIL: Topic producer failure published a partial document'
  exit 1
}
[[ ! -s "$fixture/topic-producer.out" ]] || {
  print -ru2 -- 'FAIL: Topic producer failure printed a filename'
  exit 1
}

valid_key='Ключ с пробелами'
valid_name="$(env PATH="$fake_bin:$PATH" ZK_HOME="$topic_root" \
  "$repo/scripts/objects/topic-create.zsh" 'Title' "$valid_key")"
[[ -f "$topic_root/notes/$valid_name" ]] || {
  print -ru2 -- 'FAIL: valid Topic constructor omitted destination'
  exit 1
}
rg -qFx ":key-topic: $valid_key" "$topic_root/notes/$valid_name" || {
  print -ru2 -- 'FAIL: valid Topic constructor changed key text'
  exit 1
}

print -r -- 'PASS: atomic write regression fixes'
