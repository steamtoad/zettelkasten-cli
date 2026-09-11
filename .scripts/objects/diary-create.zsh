#!/bin/zsh

#------------------------------------------------------------------------------
# diary-create.zsh
# Тип: Object Constructor
# Назначение: создание корректного объекта Diary в notes/
#------------------------------------------------------------------------------

source "${${(%):-%N}:A:h}/../lib/paths.zsh"
source "${${(%):-%N}:A:h}/../lib/uuid.zsh"
source "${${(%):-%N}:A:h}/../lib/asciidoc.zsh"

zk_diary_create() {
  emulate -L zsh

  local title="$1"
  local keywords="${2:-diary}"
  local description="${3:-$title}"
  local fname
  local target_path

  [[ -n "$title" ]] || {
    print -ru2 -- "ERROR diary title is empty"
    return 1
  }

  zk_ensure_notes_dir || return 1
  fname="$(zk_new_adoc_filename)" || return 1
  target_path="$(zk_note_path "$fname")"

  {
    zk_metadata "$fname" "$title" "$keywords" "diary" "$description"
    print -r -- ""
  } | zk_create_exclusive_from_stdin "$target_path" || return 1

  print -r -- "$fname"
}

if [[ "$ZSH_EVAL_CONTEXT" == "toplevel" ]]; then
  zk_diary_create "$@"
fi
