#!/bin/zsh

#------------------------------------------------------------------------------
# selection.zsh
# Тип: Library
# Назначение: нейтральные preflight и revalidation интерактивного выбора
#------------------------------------------------------------------------------

zk_require_command() {
  local dependency="$1"

  command -v "$dependency" >/dev/null 2>&1 || {
    print -ru2 -- "ERROR required command not found: $dependency"
    return 1
  }
}

zk_require_fzf() {
  zk_require_command fzf
}

zk_selector_fzf() {
  local prompt="$1"
  shift

  fzf --delimiter=$'\x1f' --with-nth=1 --prompt="$prompt" "$@"
}

zk_selector_result_status() {
  local selector_status="$1"

  case "$selector_status" in
    0|1|130) return "$selector_status" ;;
    *)
      print -ru2 -- "ERROR fzf failed with exit status: $selector_status"
      return "$selector_status"
      ;;
  esac
}

zk_selection_fingerprint() {
  cksum -- "$1" | awk '{ print $1 ":" $2 }'
}

zk_selection_identity() {
  local selected="${1%%$'\n'*}"
  local sep=$'\x1f'
  local fields="${selected#*"$sep"}"

  print -r -- "${fields%%"$sep"*}"
}

zk_selection_fingerprint_field() {
  local selected="${1%%$'\n'*}"
  local sep=$'\x1f'
  local fields="${selected#*"$sep"}"

  fields="${fields#*"$sep"}"
  print -r -- "${fields%%"$sep"*}"
}

zk_selection_description_field() {
  local selected="${1%%$'\n'*}"
  local sep=$'\x1f'
  local fields="${selected#*"$sep"}"

  fields="${fields#*"$sep"}"
  fields="${fields#*"$sep"}"
  print -r -- "${fields%%"$sep"*}"
}

zk_selection_validate_note() {
  local fname="$1"
  local expected_type="$2"
  local expected_fingerprint="$3"
  local file

  file="$(zk_note_path "$fname")"
  [[ -f "$file" ]] || {
    print -ru2 -- "ERROR TARGET_NOT_FOUND: $fname"
    return 1
  }
  [[ "$expected_type" == any || "$(zk_attr_value "$file" type)" == "$expected_type" ]] || {
    print -ru2 -- "ERROR STATE_CONFLICT: unexpected target type: $fname"
    return 1
  }
  ! zk_is_deprecated "$file" || {
    print -ru2 -- "ERROR STATE_CONFLICT: target is deprecated: $fname"
    return 1
  }
  [[ "$(zk_selection_fingerprint "$file")" == "$expected_fingerprint" ]] || {
    print -ru2 -- "ERROR STATE_CONFLICT: target changed after selection: $fname"
    return 1
  }
}

zk_selection_validate_file() {
  local file="$1"
  local expected_fingerprint="$2"

  [[ -f "$file" ]] || {
    print -ru2 -- "ERROR TARGET_NOT_FOUND: $file"
    return 1
  }
  [[ "$(zk_selection_fingerprint "$file")" == "$expected_fingerprint" ]] || {
    print -ru2 -- "ERROR STATE_CONFLICT: target changed after selection: $file"
    return 1
  }
}
