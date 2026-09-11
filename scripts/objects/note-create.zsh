#!/bin/zsh

#------------------------------------------------------------------------------
# note-create.zsh
# Тип: Object Constructor
# Назначение: создание корректного объекта Note в notes/
#------------------------------------------------------------------------------

source "${${(%):-%N}:A:h}/../lib/paths.zsh"
source "${${(%):-%N}:A:h}/../lib/uuid.zsh"
source "${${(%):-%N}:A:h}/../lib/asciidoc.zsh"

zk_note_create() {
  emulate -L zsh

  local title="$1"
  local keywords="${2:-note}"
  local description="${3:-$title}"
  local fname
  local target_path
  local attr
  local -a extra_attrs

  extra_attrs=("${@:4}")

  zk_validate_object_fields "pending.adoc" "$title" "$keywords" "note" "$description" "${extra_attrs[@]}" || return 1

  zk_ensure_notes_dir || return 1
  fname="$(zk_new_adoc_filename)" || return 1
  target_path="$(zk_note_path "$fname")"

  {
    zk_object_render_header "$fname" "$title" "$keywords" "note" "$description" "${extra_attrs[@]}"
    print -r -- ""
  } | zk_create_exclusive_from_stdin "$target_path" || return 1

  print -r -- "$fname"
}

if [[ "$ZSH_EVAL_CONTEXT" == "toplevel" ]]; then
  zk_note_create "$@"
fi
