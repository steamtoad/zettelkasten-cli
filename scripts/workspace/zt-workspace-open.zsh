#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-open.zsh
# Тип: Workspace
# Назначение: выбор рабочей области и просмотр через cat
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/../lib/paths.zsh"
source "$script_dir/lib/workspace.zsh"

zk_require_fzf || exit 1

sep=$'\x1f'

zt_require_workspaces || exit 1

selected="$(zt_select_workspace 'workspace> ')"
selection_status=$?
case "$selection_status" in
  0) ;;
  1) exit 1 ;;
  130) exit 0 ;;
  *) exit "$selection_status" ;;
esac

[[ -n "$selected" ]] || exit 1

file="$(zk_selection_identity "$selected")"
fingerprint="$(zk_selection_fingerprint_field "$selected")"
zk_selection_validate_file "$file" "$fingerprint" || exit 1

[[ -f "$file" ]] || {
  print -ru2 -- "ERROR workspace not found: $file"
  exit 1
}

cat -- "$file"
