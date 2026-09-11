#!/bin/zsh

#------------------------------------------------------------------------------
# zt-diary.zsh
# Тип: Diary Workflow
# Назначение: создание Diary и ведение diary-chain в Diary plugin
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
scripts_dir="${script_dir:h}"

source "$scripts_dir/lib/paths.zsh"
source "$scripts_dir/lib/asciidoc.zsh"
source "$scripts_dir/lib/uuid.zsh"
source "$scripts_dir/objects/diary-create.zsh"
source "$script_dir/lib/today.zsh"

zt_diary_state_file() {
  print -r -- "$(zk_home)/.last-diary"
}

last_diary_file="$(zt_diary_state_file)"
last=""
[[ -f "$last_diary_file" ]] && last="$(< "$last_diary_file")"

typeset -a existing_diaries
existing_diaries=()
for candidate in "$(zk_notes_dir)"/*.adoc; do
  [[ "$(zk_attr_value "$candidate" type 2>/dev/null)" == diary ]] && existing_diaries+=("$candidate")
done

if [[ -n "$last" ]]; then
  if [[ "$last" == */* || "${last:t:r}" == "$last" ]] || ! zk_is_uuid_v1 "${last:r}"; then
    print -ru2 -- "ERROR DIARY_POINTER_INVALID: invalid .last-diary value: $last"
    exit 1
  fi
fi

last_path=""
if [[ -n "$last" ]]; then
  last_path="$(zk_note_path "$last")"
  if [[ ! -f "$last_path" ]]; then
    print -ru2 -- "ERROR DIARY_POINTER_MISSING: .last-diary points to missing file: $last"
    exit 1
  fi
  if [[ "$(zk_attr_value "$last_path" type)" != diary ]]; then
    print -ru2 -- "ERROR DIARY_POINTER_TYPE: .last-diary does not point to a Diary: $last"
    exit 1
  fi
  if [[ -n "$(zk_extract_labeled_links "$last_path" "Следующая запись")" ]]; then
    print -ru2 -- "ERROR DIARY_POINTER_NOT_TAIL: .last-diary already has next: $last"
    exit 1
  fi
elif (( ${#existing_diaries[@]} > 0 )); then
  print -ru2 -- "ERROR DIARY_POINTER_MISSING: existing Diary chain has no .last-diary"
  exit 1
fi

title="Diary - $(date +"%d-%m-%Y")"
fname="$(zk_diary_create "$title" "diary" "$title")" || exit 1
diary_path="$(zk_note_path "$fname")"
link="$(zk_link "$fname" "$title")"
next_link="$(zk_link "$fname" "Следующая запись")"

dp_today_append "$fname" "$title" || exit 1

if [[ -n "$last" && -f "$last_path" ]]; then
  {
    print -r -- "$(zk_link "$last" "Предыдущая запись")"
    print -r -- ""
  } >> "$diary_path" || exit 1

  print -r -- "| $next_link" >> "$last_path" || exit 1
fi

print -r -- "$fname" > "$last_diary_file" || exit 1

vim "$diary_path" || exit $?
print -r -- "$link"
