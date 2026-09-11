#!/bin/zsh

#------------------------------------------------------------------------------
# topic-create.zsh
# Тип: Object Constructor
# Назначение: создание и запись корректного объекта Topic
#------------------------------------------------------------------------------

source "${${(%):-%N}:A:h}/../lib/paths.zsh"
source "${${(%):-%N}:A:h}/../lib/uuid.zsh"
source "${${(%):-%N}:A:h}/../lib/asciidoc.zsh"

zk_topic_validate_required_fields() {
  local title="$1"
  local key_topic="$2"

  zk_validate_single_line "topic title" "$title" required || return 1
  zk_validate_single_line ":key-topic:" "$key_topic" required
}

zk_topic_render() {
  local fname="$1"
  local title="$2"
  local key_topic="$3"
  local keywords="${4:-topic}"
  local description="${5:-$title}"

  zk_topic_validate_required_fields "$title" "$key_topic" || return 1
  zk_object_render_header "$fname" "$title" "$keywords" "topic" "$description" ":key-topic: $key_topic" || return 1
  print -r -- ""
}

zk_topic_write() {
  emulate -L zsh

  local output_file="$1"
  local fname="$2"
  local title="$3"
  local key_topic="$4"
  local keywords="${5:-topic}"
  local description="${6:-$title}"
  local prepared

  [[ -n "$output_file" ]] || {
    print -ru2 -- "ERROR topic output file is empty"
    return 1
  }

  [[ -n "$fname" ]] || {
    print -ru2 -- "ERROR topic filename is empty"
    return 1
  }

  zk_topic_validate_required_fields "$title" "$key_topic" || return 1
  zk_validate_object_fields "$fname" "$title" "$keywords" "topic" "$description" ":key-topic: $key_topic" || return 1

  prepared="$(mktemp "${output_file:h}/.${output_file:t}.topic.XXXXXX")" || return 1
  if ! zk_topic_render "$fname" "$title" "$key_topic" "$keywords" "$description" > "$prepared"; then
    rm -f -- "$prepared"
    return 1
  fi

  if [[ -e "$output_file" || -L "$output_file" ]]; then
    if ! zk_replace_with_prepared_file "$output_file" "$prepared"; then
      print -ru2 -- "ERROR prepared Topic retained for recovery: $prepared"
      return 1
    fi
  else
    if ! zk_create_exclusive_from_file "$prepared" "$output_file"; then
      rm -f -- "$prepared"
      return 1
    fi
    rm -f -- "$prepared"
  fi
}

zk_topic_create() {
  emulate -L zsh

  local title="$1"
  local key_topic="$2"
  local keywords="${3:-topic}"
  local description="${4:-$title}"
  local fname
  local target_path
  local prepared

  zk_topic_validate_required_fields "$title" "$key_topic" || return 1
  zk_validate_object_fields "pending.adoc" "$title" "$keywords" "topic" "$description" ":key-topic: $key_topic" || return 1

  zk_ensure_notes_dir || return 1
  fname="$(zk_new_adoc_filename)" || return 1
  target_path="$(zk_note_path "$fname")"
  prepared="$(mktemp "${target_path:h}/.${target_path:t}.topic.XXXXXX")" || return 1

  if ! zk_topic_render "$fname" "$title" "$key_topic" "$keywords" "$description" > "$prepared"; then
    rm -f -- "$prepared"
    return 1
  fi

  if ! zk_create_exclusive_from_file "$prepared" "$target_path"; then
    rm -f -- "$prepared"
    return 1
  fi
  rm -f -- "$prepared"

  print -r -- "$fname"
}

if [[ "$ZSH_EVAL_CONTEXT" == "toplevel" ]]; then
  zk_topic_create "$@"
fi
