#!/bin/zsh

#------------------------------------------------------------------------------
# zt-continue.zsh
# Тип: Memo Chain
# Назначение: создание memo-продолжения с двусторонней навигацией
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"

source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/asciidoc.zsh"
source "$script_dir/objects/memo-create.zsh"
source "$script_dir/zettelkasten/lib/today.zsh"
source "$script_dir/zettelkasten/lib/bindings.zsh"

extract_memo_chain_link() {
  local file="$1"
  local label="$2"

  zk_extract_labeled_link "$file" "$label"
}

extract_memo_chain_links() {
  zk_extract_labeled_links "$1" "$2"
}

zt_require_fzf || exit 1
zk_require_command vim || exit 1
zk_ensure_notes_dir || exit 1
zk_cd_notes || exit 1

selected="$(zt_select_file_by_type "memo" "continue memo> ")"
selection_status=$?
case "$selection_status" in
  0) ;;
  1) exit 1 ;;
  130) exit 0 ;;
  *) exit "$selection_status" ;;
esac
[[ -n "$selected" ]] || exit 1

source_file="$(zt_selected_filename "$selected")"
source_fingerprint="$(zt_selected_fingerprint "$selected")"
zk_selection_validate_note "$source_file" memo "$source_fingerprint" || exit 1

existing_next_links=("${(@f)$(extract_memo_chain_links "$source_file" "Следующее memo")}")
existing_next_links=("${(@)existing_next_links:#}")
if (( ${#existing_next_links[@]} > 1 )); then
  print -ru2 -- "ERROR MEMO_MULTIPLE_NEXT: $source_file"
  exit 1
fi
existing_next="${existing_next_links[1]-}"
if [[ -n "$existing_next" ]]; then
  existing_next_path="$(zk_note_path "$existing_next")"
  if [[ ! -f "$existing_next_path" || "$(zk_attr_value "$existing_next_path" type)" != memo ]]; then
    print -ru2 -- "ERROR MEMO_NEXT_INVALID: $source_file -> $existing_next"
    exit 1
  fi
fi

read -r "?Введите название продолжения memo: " key
[[ -n "$key" ]] || exit 1

source_keywords="$(zk_attr_value "$source_file" "keywords")"
source_key_topic_line="$(zk_attr_line "$source_file" "key-topic")"

title="Memo - $key от $(date +"%d-%m-%Y")"
new_description="$title"

previous_link="$(zk_link "$source_file" "Предыдущее memo")"

typeset -a extra_attrs
extra_attrs=()
[[ -n "$source_key_topic_line" ]] && extra_attrs+=("$source_key_topic_line")

zk_selection_validate_note "$source_file" memo "$source_fingerprint" || exit 1
zt_ensure_today || exit 1

new_fname="$(zk_memo_create "$title" "$source_keywords" "$new_description" "${extra_attrs[@]}")" || exit 1
new_link="$(zk_link "$new_fname" "$new_description")"

if [[ -n "$existing_next" ]]; then
  forward_link="$(zk_link "$new_fname" "Ветка: ${new_description}")"
else
  forward_link="$(zk_link "$new_fname" "Следующее memo")"
fi

zt_today_append "$new_fname" "$title" || exit 1

zk_append_text_atomic "$new_fname" "$previous_link" || exit 1
zk_append_text_atomic "$source_file" "| $forward_link" || exit 1

vim "$new_fname" || exit $?

print -r -- "$new_link"
