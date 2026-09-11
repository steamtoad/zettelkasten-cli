#!/bin/zsh

#------------------------------------------------------------------------------
# transaction.zsh
# Тип: Library
# Назначение: persistent staging, apply, rollback и recovery многофайловых workflow
#------------------------------------------------------------------------------

transaction_lib_dir="${${(%):-%N}:A:h}"
source "$transaction_lib_dir/paths.zsh"
source "$transaction_lib_dir/asciidoc.zsh"

zk_txn_hash() {
  cksum -- "$1" | awk '{ print $1 ":" $2 }'
}

zk_txn_state_dir() {
  print -r -- "$(zk_home)/.state/transactions"
}

zk_txn_lock_dir() {
  print -r -- "$(zk_home)/.state/transaction.lock"
}

zk_txn_pending_paths() {
  emulate -L zsh
  setopt local_options null_glob

  local transaction_dir
  local transaction_status

  for transaction_dir in "$(zk_txn_state_dir)"/*(N/); do
    transaction_status="$(<"$transaction_dir/status" 2>/dev/null)"
    case "$transaction_status" in
      committed|rolled_back|aborted) ;;
      *) print -r -- "$transaction_dir" ;;
    esac
  done
}

zk_txn_report_pending() {
  local pending
  local found=0

  while IFS= read -r pending; do
    [[ -n "$pending" ]] || continue
    print -r -- "RECOVERY_REQUIRED: $pending"
    found=1
  done < <(zk_txn_pending_paths)

  (( found == 0 ))
}

zk_txn_assert_no_pending() {
  local pending

  pending="$(zk_txn_pending_paths)"
  [[ -z "$pending" ]] || {
    print -ru2 -- "ERROR RECOVERY_REQUIRED: unresolved transaction"
    print -rlu2 -- "${(@f)pending}"
    return 1
  }
}

zk_txn_release_lock() {
  local lock_dir="${1:-$(zk_txn_lock_dir)}"

  [[ -d "$lock_dir" ]] || return 0
  rm -f -- "$lock_dir/owner" "$lock_dir/transaction"
  rmdir -- "$lock_dir" 2>/dev/null || true
}

zk_txn_discard() {
  local transaction_dir="${1:-${ZK_TXN_DIR:-}}"
  local state_dir="$(zk_txn_state_dir)"

  [[ -n "$transaction_dir" && "$transaction_dir" == "$state_dir"/* && -d "$transaction_dir" ]] || return 0
  rm -rf -- "$transaction_dir"
  rmdir -- "$state_dir" 2>/dev/null || true
  rmdir -- "${state_dir:h}" 2>/dev/null || true
}

zk_txn_acquire() {
  local operation="$1"
  local state_dir
  local lock_dir
  local transaction_id
  local lock_owner
  local locked_transaction
  local locked_status

  state_dir="$(zk_txn_state_dir)"
  lock_dir="$(zk_txn_lock_dir)"
  mkdir -p -- "$state_dir" || return 1

  if [[ -d "$lock_dir" ]]; then
    lock_owner="$(<"$lock_dir/owner" 2>/dev/null)"
    if [[ "$lock_owner" == <-> ]] && kill -0 "$lock_owner" 2>/dev/null; then
      print -ru2 -- "ERROR LOCKED: $lock_dir"
      return 1
    fi
    zk_txn_assert_no_pending || return 1
    locked_transaction="$(<"$lock_dir/transaction" 2>/dev/null)"
    locked_status="$(<"$state_dir/$locked_transaction/status" 2>/dev/null)"
    case "$locked_status" in
      committed|rolled_back|aborted) zk_txn_release_lock "$lock_dir" ;;
      *)
        print -ru2 -- "ERROR LOCKED: stale lock requires inspection: $lock_dir"
        return 1
        ;;
    esac
  fi

  zk_txn_assert_no_pending || return 1
  if ! mkdir -- "$lock_dir" 2>/dev/null; then
    print -ru2 -- "ERROR LOCKED: $lock_dir"
    return 1
  fi

  print -r -- "$$" > "$lock_dir/owner" || {
    zk_txn_release_lock "$lock_dir"
    return 1
  }

  transaction_id="$$-$RANDOM-$RANDOM"
  ZK_TXN_DIR="$state_dir/$transaction_id"
  ZK_TXN_LOCK="$lock_dir"
  mkdir -p -- "$ZK_TXN_DIR/entries" "$ZK_TXN_DIR/staged-vault" \
    "$ZK_TXN_DIR/snapshot-vault" "$ZK_TXN_DIR/snapshot-meta" || {
    zk_txn_release_lock "$lock_dir"
    return 1
  }
  print -r -- "$transaction_id" > "$lock_dir/transaction"
  print -r -- "$operation" > "$ZK_TXN_DIR/operation"
  print -r -- "building" > "$ZK_TXN_DIR/status"
  print -r -- "pid=$$" > "$ZK_TXN_DIR/owner"
  export ZK_TXN_DIR ZK_TXN_LOCK
}

zk_txn_copy_vault_to_stage() {
  local stage_root="$ZK_TXN_DIR/staged-vault"
  local snapshot_root="$ZK_TXN_DIR/snapshot-vault"
  local meta_root="$ZK_TXN_DIR/snapshot-meta"
  local root="$(zk_home)"
  local item
  local snapshot_file
  local relative
  local meta_prefix

  for item in notes all-todays; do
    if [[ -d "$root/$item" ]]; then
      print -r -- present > "$meta_root/directory-$item"
      cp -pR -- "$root/$item" "$snapshot_root/" || return 1
      cp -pR -- "$snapshot_root/$item" "$stage_root/" || return 1
    fi
  done
  if [[ -f "$root/.last-diary" ]]; then
    cp -p -- "$root/.last-diary" "$snapshot_root/.last-diary" || return 1
    cp -p -- "$snapshot_root/.last-diary" "$stage_root/.last-diary" || return 1
  fi

  for item in notes all-todays; do
    for snapshot_file in "$snapshot_root/$item"/**/*(N.); do
      relative="${snapshot_file#"$snapshot_root"/}"
      meta_prefix="$meta_root/$relative"
      mkdir -p -- "${meta_prefix:h}" || return 1
      print -r -- "$(zk_txn_hash "$root/$relative")" > "$meta_prefix.hash"
      print -r -- "$(zk_file_identity "$root/$relative")" > "$meta_prefix.identity"
      print -r -- "$(zk_file_mode "$root/$relative")" > "$meta_prefix.mode"
    done
  done
  if [[ -f "$snapshot_root/.last-diary" ]]; then
    print -r -- "$(zk_txn_hash "$root/.last-diary")" > "$meta_root/.last-diary.hash"
    print -r -- "$(zk_file_identity "$root/.last-diary")" > "$meta_root/.last-diary.identity"
    print -r -- "$(zk_file_mode "$root/.last-diary")" > "$meta_root/.last-diary.mode"
  fi
}

zk_txn_validate_path() {
  local target="$1"
  local root="$(zk_home)"

  [[ "$target" == "$root"/* ]] || {
    print -ru2 -- "ERROR transaction target is outside ZK_HOME: $target"
    return 1
  }
  [[ "$target" != *$'\n'* && "$target" != *$'\r'* && "$target" != *$'\x1f'* ]] || {
    print -ru2 -- "ERROR transaction target contains unsupported control text"
    return 1
  }
}

zk_txn_add_entry() {
  local kind="$1"
  local target="$2"
  local staged="${3:-}"
  local snapshot="${4:-}"
  local meta_prefix="${5:-}"
  local count_file="$ZK_TXN_DIR/entry-count"
  local count=0
  local entry

  zk_txn_validate_path "$target" || return 1
  [[ ! -f "$count_file" ]] || count="$(<"$count_file")"
  (( count++ ))
  print -r -- "$count" > "$count_file"
  entry="$ZK_TXN_DIR/entries/${(l:4::0:)count}"
  mkdir -- "$entry" || return 1
  print -r -- "$kind" > "$entry/kind"
  print -r -- "$target" > "$entry/target"

  case "$kind" in
    existing)
      [[ -f "$snapshot" && ! -L "$snapshot" && -f "$staged" && ! -L "$staged" ]] || return 1
      [[ -f "$meta_prefix.hash" && -f "$meta_prefix.identity" && -f "$meta_prefix.mode" ]] || return 1
      cp -- "$meta_prefix.hash" "$entry/source-hash" || return 1
      cp -- "$meta_prefix.identity" "$entry/source-identity" || return 1
      cp -- "$meta_prefix.mode" "$entry/source-mode" || return 1
      cp -p -- "$snapshot" "$entry/backup" || return 1
      cp -p -- "$staged" "$entry/staged" || return 1
      ;;
    create)
      [[ ! -e "$target" && ! -L "$target" && -f "$staged" && ! -L "$staged" ]] || return 1
      cp -p -- "$staged" "$entry/staged" || return 1
      ;;
    directory)
      [[ ! -e "$target" && ! -L "$target" ]] || return 1
      ;;
    *)
      print -ru2 -- "ERROR unknown transaction entry kind: $kind"
      return 1
      ;;
  esac

  print -r -- "$kind"$'\x1f'"$target" >> "$ZK_TXN_DIR/manifest"
}

zk_txn_freeze_stage() {
  emulate -L zsh
  setopt local_options null_glob

  local root="$(zk_home)"
  local stage_root="$ZK_TXN_DIR/staged-vault"
  local snapshot_root="$ZK_TXN_DIR/snapshot-vault"
  local meta_root="$ZK_TXN_DIR/snapshot-meta"
  local directory
  local staged
  local target
  local relative
  local original

  : > "$ZK_TXN_DIR/manifest" || return 1

  for directory in notes all-todays; do
    if [[ -d "$stage_root/$directory" && ! -f "$meta_root/directory-$directory" ]]; then
      [[ ! -e "$root/$directory" && ! -L "$root/$directory" ]] || {
        print -ru2 -- "ERROR STATE_CONFLICT: expected absent directory exists: $root/$directory"
        return 1
      }
      zk_txn_add_entry directory "$root/$directory" || return 1
    fi
  done

  for directory in notes all-todays; do
    for staged in "$stage_root/$directory"/**/*(N.); do
      relative="${staged#"$stage_root"/}"
      target="$root/$relative"
      if [[ -f "$snapshot_root/$relative" ]]; then
        [[ "$(zk_txn_hash "$staged")" == "$(zk_txn_hash "$snapshot_root/$relative")" ]] && continue
        zk_txn_add_entry existing "$target" "$staged" "$snapshot_root/$relative" "$meta_root/$relative" || return 1
      elif [[ ! -e "$target" && ! -L "$target" ]]; then
        zk_txn_add_entry create "$target" "$staged" || return 1
      else
        print -ru2 -- "ERROR STATE_CONFLICT: expected absent target exists: $target"
        return 1
      fi
    done

    for original in "$snapshot_root/$directory"/**/*(N.); do
      relative="${original#"$snapshot_root"/}"
      [[ -f "$stage_root/$relative" ]] || {
        print -ru2 -- "ERROR transaction does not support file deletion: $root/$relative"
        return 1
      }
    done
  done

  staged="$stage_root/.last-diary"
  target="$root/.last-diary"
  if [[ -f "$staged" ]]; then
    if [[ -f "$snapshot_root/.last-diary" ]]; then
      if [[ "$(zk_txn_hash "$staged")" != "$(zk_txn_hash "$snapshot_root/.last-diary")" ]]; then
        zk_txn_add_entry existing "$target" "$staged" "$snapshot_root/.last-diary" "$meta_root/.last-diary" || return 1
      fi
    elif [[ ! -e "$target" && ! -L "$target" ]]; then
      zk_txn_add_entry create "$target" "$staged" || return 1
    else
      print -ru2 -- "ERROR STATE_CONFLICT: unsupported transaction target: $target"
      return 1
    fi
  elif [[ -f "$target" ]]; then
    print -ru2 -- "ERROR transaction does not support state deletion: $target"
    return 1
  fi

  chmod 0444 "$ZK_TXN_DIR/manifest" || return 1
  print -r -- "staged" > "$ZK_TXN_DIR/status"
}

zk_txn_revalidate_entry() {
  local entry="$1"
  local kind="$(<"$entry/kind")"
  local target="$(<"$entry/target")"

  case "$kind" in
    existing)
      [[ -f "$target" && ! -L "$target" ]] || {
        print -ru2 -- "ERROR STATE_CONFLICT: target disappeared: $target"
        return 1
      }
      [[ "$(zk_txn_hash "$target")" == "$(<"$entry/source-hash")" && \
         "$(zk_file_identity "$target")" == "$(<"$entry/source-identity")" ]] || {
        print -ru2 -- "ERROR STATE_CONFLICT: target changed after plan: $target"
        return 1
      }
      ;;
    create|directory)
      [[ ! -e "$target" && ! -L "$target" ]] || {
        print -ru2 -- "ERROR STATE_CONFLICT: expected absent target exists: $target"
        return 1
      }
      ;;
  esac
}

zk_txn_restore() {
  emulate -L zsh
  setopt local_options null_glob

  local transaction_dir="${1:-$ZK_TXN_DIR}"
  local -a applied
  local index
  local entry
  local kind
  local target
  local current_hash
  local current_identity
  local failed=0
  local rollback_count=0

  [[ ! -f "$transaction_dir/applied" ]] || applied=("${(@f)$(<"$transaction_dir/applied")}")
  for (( index = ${#applied}; index >= 1; index-- )); do
    entry="$transaction_dir/entries/${applied[$index]}"
    [[ -d "$entry" ]] || continue
    (( rollback_count++ ))
    kind="$(<"$entry/kind")"
    target="$(<"$entry/target")"

    if [[ "${ZK_TXN_FAIL_ROLLBACK_AT:-}" == "$rollback_count" ]]; then
      print -ru2 -- "ERROR injected rollback failure: $target"
      failed=1
      continue
    fi

    case "$kind" in
      existing)
        if [[ -f "$target" && "$(zk_txn_hash "$target")" == "$(<"$entry/source-hash")" && \
              "$(zk_file_mode "$target")" == "$(<"$entry/source-mode")" ]]; then
          continue
        fi
        if [[ ! -f "$target" || -L "$target" ]]; then
          print -ru2 -- "ERROR recovery target missing or unsupported: $target"
          failed=1
          continue
        fi
        current_hash="$(zk_txn_hash "$target")"
        current_identity="$(zk_file_identity "$target")"
        if [[ "$current_hash" != "$(<"$entry/applied-hash")" || \
              "$current_identity" != "$(<"$entry/applied-identity")" ]]; then
          print -ru2 -- "ERROR recovery preserved externally changed target: $target"
          failed=1
          continue
        fi
        if ! zk_replace_from_file_atomic "$target" "$entry/backup" || \
           [[ "$(zk_txn_hash "$target")" != "$(<"$entry/source-hash")" ]] || \
           [[ "$(zk_file_mode "$target")" != "$(<"$entry/source-mode")" ]]; then
          print -ru2 -- "ERROR recovery failed to restore: $target"
          failed=1
        fi
        ;;
      create)
        [[ -e "$target" || -L "$target" ]] || continue
        if [[ ! -f "$target" || -L "$target" || \
              "$(zk_txn_hash "$target")" != "$(<"$entry/applied-hash")" || \
              "$(zk_file_identity "$target")" != "$(<"$entry/applied-identity")" ]]; then
          print -ru2 -- "ERROR recovery preserved externally changed created target: $target"
          failed=1
          continue
        fi
        rm -f -- "$target" || failed=1
        ;;
      directory)
        [[ -d "$target" ]] || continue
        if [[ "$(zk_file_identity "$target")" != "$(<"$entry/applied-identity")" ]] || ! rmdir -- "$target" 2>/dev/null; then
          print -ru2 -- "ERROR recovery preserved non-empty or changed directory: $target"
          failed=1
        fi
        ;;
    esac
  done

  if (( failed )); then
    print -r -- "recovery_required" > "$transaction_dir/status"
    print -ru2 -- "ERROR RECOVERY_REQUIRED: $transaction_dir"
    print -ru2 -- "Affected files:"
    for index in {1..${#applied}}; do
      entry="$transaction_dir/entries/${applied[$index]}"
      [[ -f "$entry/target" ]] && print -ru2 -- "$(<"$entry/target")"
    done
    print -ru2 -- "Backups: $transaction_dir/entries"
    return 1
  fi

  print -r -- "rolled_back" > "$transaction_dir/status"
}

zk_txn_apply() {
  emulate -L zsh
  setopt local_options null_glob

  local entry
  local kind
  local target
  local count=0
  local entry_id

  print -r -- "applying" > "$ZK_TXN_DIR/status"
  : > "$ZK_TXN_DIR/applied"

  for entry in "$ZK_TXN_DIR/entries"/*(N/); do
    (( count++ ))
    entry_id="${entry:t}"
    kind="$(<"$entry/kind")"
    target="$(<"$entry/target")"

    if [[ "${ZK_TXN_FAIL_APPLY_AT:-}" == "$count" ]]; then
      print -ru2 -- "ERROR injected apply failure: $target"
      zk_txn_restore "$ZK_TXN_DIR" || return 75
      return 1
    fi

    if [[ "${ZK_TXN_TEST_EXTERNAL_EDIT_AT:-}" == "$count" && "$kind" == existing ]]; then
      print -r -- "${ZK_TXN_TEST_EXTERNAL_TEXT:-external edit}" >> "$target"
    fi

    if ! zk_txn_revalidate_entry "$entry"; then
      zk_txn_restore "$ZK_TXN_DIR" || return 75
      return 1
    fi

    case "$kind" in
      existing) zk_replace_from_file_atomic "$target" "$entry/staged" ;;
      create) zk_create_exclusive_from_file "$entry/staged" "$target" ;;
      directory) mkdir -- "$target" ;;
      *) return 1 ;;
    esac
    if (( $? != 0 )); then
      print -ru2 -- "ERROR transaction apply failed: $target"
      zk_txn_restore "$ZK_TXN_DIR" || return 75
      return 1
    fi

    case "$kind" in
      existing|create)
        print -r -- "$(zk_txn_hash "$target")" > "$entry/applied-hash"
        print -r -- "$(zk_file_identity "$target")" > "$entry/applied-identity"
        ;;
      directory)
        print -r -- "$(zk_file_identity "$target")" > "$entry/applied-identity"
        ;;
    esac
    print -r -- "$entry_id" >> "$ZK_TXN_DIR/applied"

    if [[ "${ZK_TXN_KILL_AFTER_APPLY:-}" == "$count" ]]; then
      kill -KILL $$
    fi
  done

  for entry in "$ZK_TXN_DIR/entries"/*(N/); do
    kind="$(<"$entry/kind")"
    target="$(<"$entry/target")"
    case "$kind" in
      existing|create)
        [[ -f "$target" && "$(zk_txn_hash "$target")" == "$(zk_txn_hash "$entry/staged")" ]] || {
          print -ru2 -- "ERROR transaction postflight failed: $target"
          zk_txn_restore "$ZK_TXN_DIR" || return 75
          return 1
        }
        ;;
      directory) [[ -d "$target" ]] || return 1 ;;
    esac
  done

  print -r -- "committed" > "$ZK_TXN_DIR/status"
}

zk_txn_recover() {
  local transaction_dir="$1"
  local transaction_status
  local lock_dir="$(zk_txn_lock_dir)"
  local lock_owner

  [[ -d "$transaction_dir" && "$transaction_dir" == "$(zk_txn_state_dir)"/* ]] || {
    print -ru2 -- "ERROR invalid transaction path: $transaction_dir"
    return 1
  }
  transaction_status="$(<"$transaction_dir/status" 2>/dev/null)"
  case "$transaction_status" in
    committed|rolled_back) return 0 ;;
  esac

  if [[ -d "$lock_dir" ]]; then
    [[ -f "$lock_dir/transaction" && "$(<"$lock_dir/transaction")" == "${transaction_dir:t}" ]] || {
      print -ru2 -- "ERROR LOCKED: $lock_dir"
      return 1
    }
    lock_owner="$(<"$lock_dir/owner" 2>/dev/null)"
    if [[ "$lock_owner" == <-> ]] && kill -0 "$lock_owner" 2>/dev/null; then
      print -ru2 -- "ERROR LOCKED: transaction owner is still running: $lock_owner"
      return 1
    fi
    zk_txn_release_lock "$lock_dir"
  fi
  mkdir -p -- "${lock_dir:h}" || return 1
  mkdir -- "$lock_dir" 2>/dev/null || {
    print -ru2 -- "ERROR LOCKED: $lock_dir"
    return 1
  }
  print -r -- "$$" > "$lock_dir/owner"
  print -r -- "${transaction_dir:t}" > "$lock_dir/transaction"

  zk_txn_restore "$transaction_dir"
  local recovery_status=$?
  zk_txn_release_lock "$lock_dir"
  return "$recovery_status"
}

zk_txn_defer_output() {
  if [[ -n "${ZK_TXN_STAGE_MODE:-}" ]]; then
    print -rl -- "$@" >> "$ZK_TXN_PARENT_DIR/final-output"
  else
    print -rl -- "$@"
  fi
}

zk_txn_open_editor() {
  local file="$1"

  if [[ -n "${ZK_TXN_STAGE_MODE:-}" ]]; then
    print -r -- "${file#"$(zk_home)"/}" > "$ZK_TXN_PARENT_DIR/editor-target"
    return 0
  fi
  vim "$file"
}

zk_txn_run_staged_workflow() {
  local operation="$1"
  local script="$2"
  shift 2
  local original_root="$(zk_home)"
  local stage_root
  local child_status
  local editor_target

  zk_txn_acquire "$operation" || return 1
  stage_root="$ZK_TXN_DIR/staged-vault"
  zk_txn_copy_vault_to_stage || {
    zk_txn_release_lock "$ZK_TXN_LOCK"
    zk_txn_discard "$ZK_TXN_DIR"
    return 1
  }

  env ZK_HOME="$stage_root" ZK_TXN_STAGE_MODE=1 ZK_TXN_PARENT_DIR="$ZK_TXN_DIR" \
    ZK_TXN_ORIGINAL_ROOT="$original_root" \
    "$script" "$@"
  child_status=$?
  if (( child_status != 0 )); then
    zk_txn_release_lock "$ZK_TXN_LOCK"
    zk_txn_discard "$ZK_TXN_DIR"
    return "$child_status"
  fi

  if ! zk_txn_freeze_stage; then
    zk_txn_release_lock "$ZK_TXN_LOCK"
    zk_txn_discard "$ZK_TXN_DIR"
    return 1
  fi

  if [[ -n "${ZK_TXN_TEST_READY_FILE:-}" ]]; then
    : > "$ZK_TXN_TEST_READY_FILE"
    local wait_count=0
    while [[ ! -e "${ZK_TXN_TEST_CONTINUE_FILE:-}" ]] && (( wait_count < 200 )); do
      sleep 0.05
      (( wait_count++ ))
    done
    [[ -e "${ZK_TXN_TEST_CONTINUE_FILE:-}" ]] || {
      print -ru2 -- "ERROR transaction test barrier timed out"
      zk_txn_release_lock "$ZK_TXN_LOCK"
      zk_txn_discard "$ZK_TXN_DIR"
      return 1
    }
  fi

  if [[ ! -s "$ZK_TXN_DIR/manifest" ]]; then
    zk_txn_release_lock "$ZK_TXN_LOCK"
    zk_txn_discard "$ZK_TXN_DIR"
    return 0
  fi

  zk_txn_apply
  local apply_status=$?
  zk_txn_release_lock "$ZK_TXN_LOCK"
  if (( apply_status != 0 )) && [[ "$(<"$ZK_TXN_DIR/status")" == rolled_back ]]; then
    zk_txn_discard "$ZK_TXN_DIR"
  fi
  (( apply_status == 0 )) || return "$apply_status"

  if [[ -f "$ZK_TXN_DIR/editor-target" ]]; then
    editor_target="$(<"$ZK_TXN_DIR/editor-target")"
    vim "$original_root/$editor_target"
    local editor_status=$?
    if (( editor_status != 0 )); then
      print -ru2 -- "ERROR editor failed after committed transaction: $original_root/$editor_target"
      return "$editor_status"
    fi
  fi
  [[ ! -f "$ZK_TXN_DIR/final-output" ]] || cat -- "$ZK_TXN_DIR/final-output"
}

if [[ "$ZSH_EVAL_CONTEXT" == "toplevel" ]]; then
  case "${1:-}" in
    recover)
      [[ $# -eq 2 ]] || { print -ru2 -- "Usage: transaction.zsh recover TRANSACTION_DIR"; exit 1; }
      zk_txn_recover "$2"
      ;;
    pending)
      zk_txn_report_pending
      ;;
    *)
      print -ru2 -- "Usage: transaction.zsh {pending|recover TRANSACTION_DIR}"
      exit 1
      ;;
  esac
fi
