#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-add.zsh
# Тип: Workspace
# Назначение: добавление выбранных документов в рабочую область
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/../lib/paths.zsh"
source "$script_dir/../lib/asciidoc.zsh"
source "$script_dir/../lib/selection.zsh"
source "$script_dir/lib/workspace.zsh"

sep=$'\x1f'

zk_require_fzf || exit 1

select_documents() {
  local file
  local type
  local description
  local fingerprint

  for file in "$(zk_notes_dir)"/*.adoc; do
    [[ -f "$file" ]] || continue
    zk_is_deprecated "$file" && continue

    type="$(zk_attr_value "$file" "type")"

    case "$type" in
      note|memo|todo|topic|diary) ;;
      *) continue ;;
    esac

    description="$(zk_link_description "$file")"
    fingerprint="$(zk_selection_fingerprint "$file")"
    print -r -- "${file:t} - ${description}${sep}${file:t}${sep}${fingerprint}"
  done |
    zk_selector_fzf 'add documents> ' --multi
  local selector_status=$?
  zk_selector_result_status "$selector_status"
}

zk_cd || exit 1

zt_require_workspaces || exit 1

selected_workspace="$(zt_select_workspace 'workspace> ')"
selection_status=$?
case "$selection_status" in 0) ;; 1) exit 1 ;; 130) exit 0 ;; *) exit "$selection_status" ;; esac
[[ -n "$selected_workspace" ]] || exit 1

workspace_file="$(zk_selection_identity "$selected_workspace")"
workspace_fingerprint="$(zk_selection_fingerprint_field "$selected_workspace")"
zk_selection_validate_file "$workspace_file" "$workspace_fingerprint" || exit 1

selected_documents="$(select_documents)"
selection_status=$?
case "$selection_status" in 0) ;; 1) exit 1 ;; 130) exit 0 ;; *) exit "$selection_status" ;; esac
[[ -n "$selected_documents" ]] || exit 1

zk_selection_validate_file "$workspace_file" "$workspace_fingerprint" || exit 1

while IFS= read -r selected_document; do
  [[ -n "$selected_document" ]] || continue

  doc_file="$(zk_selection_identity "$selected_document")"
  fingerprint="$(zk_selection_fingerprint_field "$selected_document")"
  zk_selection_validate_note "$doc_file" any "$fingerprint" || exit 1
  description="$(zk_link_description "$(zk_note_path "$doc_file")")"
  relative_target="../notes/${doc_file}"
  link="$(zt_workspace_link "$doc_file" "$description")"

  if zk_has_link_to "$workspace_file" "$relative_target"; then
    print -r -- "Already in workspace: $link"
    continue
  fi

  zk_append_related_link "$workspace_file" "== Документы" "" "$link" || exit 1
  print -r -- "Added to workspace: $link"
done <<< "$selected_documents"
