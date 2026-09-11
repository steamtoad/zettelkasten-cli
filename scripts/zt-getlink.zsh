#!/bin/zsh

#------------------------------------------------------------------------------
# zt-getlink.zsh
# Тип: Link
# Назначение: генерация AsciiDoc-ссылки на заметку по :description:
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/asciidoc.zsh"
source "$script_dir/lib/selection.zsh"

sep=$'\x1f'

zk_cd_notes || exit 1
zk_require_fzf || exit 1

selected="$(
  for file in *.adoc; do
    zk_is_deprecated "$file" && continue

    description="$(zk_attr_value "$file" "description")"

    [[ -n "$description" ]] || continue

    fingerprint="$(zk_selection_fingerprint "$file")"
    print -r -- "${file} - ${description}${sep}${file}${sep}${fingerprint}"
  done |
  zk_selector_fzf 'link> '
)"
selection_status=$?
zk_selector_result_status "$selection_status"
normalized_status=$?
(( normalized_status == selection_status )) || selection_status="$normalized_status"
case "$selection_status" in
  0) ;;
  1) exit 1 ;;
  130) exit 0 ;;
  *) exit "$selection_status" ;;
esac

[[ -n "$selected" ]] || exit 1

file="$(zk_selection_identity "$selected")"
fingerprint="$(zk_selection_fingerprint_field "$selected")"
zk_selection_validate_note "$file" any "$fingerprint" || exit 1
description="$(zk_link_description "$file")"

zk_link "$file" "$description"
