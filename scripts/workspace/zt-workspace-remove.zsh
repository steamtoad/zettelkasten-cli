#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-remove.zsh
# Тип: Workspace
# Назначение: удаление ссылок на документы из рабочей области
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/../lib/paths.zsh"
source "$script_dir/../lib/asciidoc.zsh"
source "$script_dir/lib/workspace.zsh"

sep=$'\x1f'

select_workspace_documents() {
  local file="$1"
  local target
  local normalized_target
  local root_file
  local type
  local description
  local state

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    [[ "$target" == ../notes/*.adoc ]] || continue

    normalized_target="${target#../}"
    [[ "$normalized_target" == notes/*.adoc ]] || continue
    [[ "${normalized_target#notes/}" != */* ]] || continue

    root_file="$zk/$normalized_target"

    if [[ -f "$root_file" ]]; then
      type="$(zk_attr_value "$root_file" "type")"
      description="$(zk_link_description "$root_file")"

      if zk_is_deprecated "$root_file"; then
        state="deprecated"
      else
        state="$type"
      fi
    else
      description="$normalized_target"
      state="broken"
    fi

    print -r -- "${state} - ${normalized_target} - ${description}${sep}${target}${sep}${description}"
  done < <(zk_extract_links "$file") |
    fzf \
      --multi \
      --delimiter="$sep" \
      --with-nth=1 \
      --prompt='remove documents> '
}

remove_workspace_links() {
  local file="$1"
  shift

  ZK_LINK_STAGE_PREFIX='.zk-workspace-remove' \
    ZK_LINK_CLEANUP_ON_FAILURE=1 \
    zk_remove_links_atomic "$file" "$@"
}

zk="$(zk_home)"
workspaces_dir="$(zt_workspaces_dir)"

zk_cd || exit 1

zt_require_workspaces || exit 1

selected_workspace="$(zt_select_workspace 'workspace> ')"
[[ -n "$selected_workspace" ]] || exit 0

selected_workspace="${selected_workspace%%$'\n'*}"
workspace_file="${selected_workspace##*$sep}"

selected_documents="$(select_workspace_documents "$workspace_file")"
[[ -n "$selected_documents" ]] || exit 0

typeset -a selected_targets
typeset -a selected_descriptions

selected_targets=()
selected_descriptions=()

while IFS= read -r selected_document; do
  [[ -n "$selected_document" ]] || continue
  target="${${selected_document#*$sep}%%$sep*}"
  description="${selected_document##*$sep}"

  selected_targets+=("$target")
  selected_descriptions+=("$description")
done <<< "$selected_documents"

(( ${#selected_targets} > 0 )) || exit 0

remove_workspace_links "$workspace_file" "${selected_targets[@]}" || exit 1

for (( i = 1; i <= ${#selected_targets}; i++ )); do
  print -r -- "Removed from workspace: link:${selected_targets[$i]}[${selected_descriptions[$i]}]"
done
