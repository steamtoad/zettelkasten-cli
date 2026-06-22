#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-remove.zsh
# Тип: Workspace
# Назначение: удаление ссылок на документы из рабочей области
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/asciidoc.zsh"
source "$script_dir/lib/workspace.zsh"

sep=$'\x1f'

select_workspace_document() {
  local file="$1"
  local target
  local normalized_target
  local root_file
  local type
  local description
  local state

  while IFS= read -r target; do
    [[ -n "$target" ]] || continue
    [[ "$target" == ../*.adoc ]] || continue

    normalized_target="${target#../}"
    [[ "$normalized_target" != */* ]] || continue

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
  done < <(
    awk '
      function trimmed(line) {
        sub(/^[[:space:]]+/, "", line)
        sub(/[[:space:]]+$/, "", line)
        return line
      }

      in_block {
        line = trimmed($0)

        if (block_delim == "```") {
          if (line ~ /^```/) in_block = 0
        } else if (line == block_delim) {
          in_block = 0
        }

        next
      }

      /^```/ {
        in_block = 1
        block_delim = "```"
        next
      }

      /^(----|\.{4,}|_{4,}|\*{4,}|={4,}|\+{4,}|\/{4,})[[:space:]]*$/ {
        in_block = 1
        block_delim = trimmed($0)
        next
      }

      {
        line = $0
        while (match(line, /link:[^[]+\.adoc\[/)) {
          link = substr(line, RSTART + 5, RLENGTH - 6)
          print link
          line = substr(line, RSTART + RLENGTH)
        }
      }
    ' "$file"
  ) |
    fzf \
      --delimiter="$sep" \
      --with-nth=1 \
      --prompt='remove document> '
}

remove_workspace_link() {
  local file="$1"
  local target="$2"
  local tmp
  local mode

  tmp="$(mktemp "${TMPDIR:-/tmp}/zk-workspace-remove.XXXXXX")" || return 1

  if ! awk -v target="link:${target}[" '
    function trimmed(line) {
      sub(/^[[:space:]]+/, "", line)
      sub(/[[:space:]]+$/, "", line)
      return line
    }

    in_block {
      print
      line = trimmed($0)

      if (block_delim == "```") {
        if (line ~ /^```/) in_block = 0
      } else if (line == block_delim) {
        in_block = 0
      }

      next
    }

    /^```/ {
      in_block = 1
      block_delim = "```"
      print
      next
    }

    /^(----|\.{4,}|_{4,}|\*{4,}|={4,}|\+{4,}|\/{4,})[[:space:]]*$/ {
      in_block = 1
      block_delim = trimmed($0)
      print
      next
    }

    /^[*][[:space:]]/ && index($0, target) {
      removed = 1
      next
    }

    { print }

    END {
      if (!removed) exit 2
    }
  ' "$file" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    mode="$(stat -f '%Lp' "$file")" || return 1
  else
    mode="$(stat -c '%a' "$file")" || return 1
  fi

  chmod "$mode" "$tmp" || return 1
  mv "$tmp" "$file"
}

zk="$(zk_home)"
workspaces_dir="$(zk_workspaces_dir)"

zk_cd

zk_require_workspaces || exit 1

selected_workspace="$(zk_select_workspace 'workspace> ')"
[[ -n "$selected_workspace" ]] || exit 0

selected_workspace="${selected_workspace%%$'\n'*}"
workspace_file="${selected_workspace##*$sep}"

while true; do
  selected_document="$(select_workspace_document "$workspace_file")"
  [[ -n "$selected_document" ]] || exit 0

  selected_document="${selected_document%%$'\n'*}"
  target="${${selected_document#*$sep}%%$sep*}"
  description="${selected_document##*$sep}"

  remove_workspace_link "$workspace_file" "$target" || exit 1

  print -r -- "Removed from workspace: link:${target}[${description}]"
done
