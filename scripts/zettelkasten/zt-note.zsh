#!/bin/zsh

#------------------------------------------------------------------------------
# zt-note.zsh
# Тип: Note Workflow
# Назначение: интерактивное создание Note по правилам Zettelkasten
#------------------------------------------------------------------------------

emulate -L zsh

script_dir="${0:A:h}"
scripts_dir="${script_dir:h}"

source "$scripts_dir/lib/paths.zsh"
source "$scripts_dir/lib/asciidoc.zsh"
source "$scripts_dir/lib/transaction.zsh"
source "$scripts_dir/objects/note-create.zsh"
source "$script_dir/lib/today.zsh"
source "$script_dir/lib/bindings.zsh"

if [[ -z "${ZK_TXN_STAGE_MODE:-}" ]]; then
  zt_require_fzf || exit 1
  zk_require_command vim || exit 1
  zk_txn_run_staged_workflow note "$0" "$@"
  exit $?
fi

read -r "?Введите название для новой заметки: " key
[[ -n "$key" ]] || exit 1

zt_require_fzf || exit 1
zk_require_command vim || exit 1

memo_file=""
memo_key_line=""
note_keywords="note"

binding="$(zt_select_memo_binding)"
selection_status=$?
case "$selection_status" in
  0) ;;
  1) exit 1 ;;
  130) exit 0 ;;
  *) exit "$selection_status" ;;
esac

if [[ "$binding" == "Да" ]]; then
  selected="$(zt_select_memo_file)"
  selection_status=$?
  case "$selection_status" in
    0) ;;
    1) exit 1 ;;
    130) exit 0 ;;
    *) exit "$selection_status" ;;
  esac
  [[ -n "$selected" ]] || exit 1

  if [[ -n "$selected" ]]; then
    memo_file="$(zt_selected_filename "$selected")"
    memo_fingerprint="$(zt_selected_fingerprint "$selected")"
    zk_selection_validate_note "$memo_file" memo "$memo_fingerprint" || exit 1
    memo_path="$(zk_note_path "$memo_file")"
    memo_key_line="$(zk_attr_line "$memo_path" "key-topic")"
    memo_keywords="$(zk_attr_value "$memo_path" "keywords")"

    if [[ -n "$memo_keywords" ]]; then
      note_keywords="$(zt_keywords_for_note_from_memo "$memo_keywords")"
    fi
  fi
fi

typeset -a extra_attrs
extra_attrs=()
[[ -n "$memo_key_line" ]] && extra_attrs+=("$memo_key_line")

if [[ -n "$memo_file" ]]; then
  zk_selection_validate_note "$memo_file" memo "$memo_fingerprint" || exit 1
fi

fname="$(zk_note_create "$key" "$note_keywords" "$key" "${extra_attrs[@]}")" || exit 1
link="$(zk_link "$fname" "$key")"

zt_today_append "$fname" "$key" || exit 1

if [[ -n "$memo_file" ]]; then
  zt_bind_note_to_memo "$fname" "$memo_file" || exit 1
fi

zk_txn_open_editor "$(zk_note_path "$fname")" || exit $?
zk_txn_defer_output "$link"
