#!/bin/zsh

#------------------------------------------------------------------------------
# zt-check.zsh
# Тип: System Check
# Назначение: проверка целостности Zettelkasten без исправлений
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/asciidoc.zsh"

zk="$(zk_home)"
notes_dir="$(zk_notes_dir)"
errors=0
warnings=0

ok() { print -r -- "OK    $1" }
err() { print -r -- "ERROR $1"; (( errors++ )) }
warn() { print -r -- "WARN  $1"; (( warnings++ )) }

broken_link() {
  print -r -- "BROKEN LINK:"
  print -r -- "from: $1"
  print -r -- "to:   $2"
  (( errors++ ))
}

broken_diary_link() {
  print -r -- "BROKEN DIARY LINK:"
  print -r -- "$1"
  print -r -- "-> $2"
  (( errors++ ))
}

broken_diary_chain() {
  print -r -- "BROKEN DIARY CHAIN:"
  print -r -- "$1 -> $2"
  (( errors++ ))
}

attr_value() {
  zk_attr_value "$1" "$2"
}

has_attr() {
  zk_has_attr "$1" "$2"
}

keyword_has() {
  local keywords="$1"
  local keyword="$2"
  local normalized="${keywords:l}"

  normalized="${normalized// /}"
  [[ ",$normalized," == *",$keyword,"* ]]
}

known_type() {
  case "$1" in
    diary|note|memo|todo|topic|list|index) return 0 ;;
    *) return 1 ;;
  esac
}

is_metadata_exempt_file() {
  case "$1" in
    AGENTS.adoc) return 0 ;;
    *) return 1 ;;
  esac
}

is_placeholder_link() {
  case "$1" in
    UUID.adoc|previous.adoc|next.adoc) return 0 ;;
    *) return 1 ;;
  esac
}

extract_links() {
  zk_extract_links "$1"
}

target_exists_from_source() {
  local source_file="$1"
  local target="$2"
  local candidate

  [[ "$target" != /* ]] || return 1
  candidate="${source_file:h}/$target"
  [[ -f "${candidate:A}" ]]
}

extract_diary_chain_link() {
  local file="$1"
  local label="$2"

  zk_extract_labeled_link "$file" "$label"
}

print -r -- "== zt-check"
print -r -- "Repository: $zk"
print -r -- ""

print -r -- "== Repository structure"

[[ -d "$zk" ]] || {
  err "$zk not found"
  exit 1
}

[[ -d "$zk/all-todays" ]] && ok "all-todays" || err "all-todays not found"
[[ -d "$notes_dir" ]] && ok "notes" || err "notes not found"
[[ -d "$zk/.scripts" ]] && ok ".scripts" || err ".scripts not found"
[[ -f "$zk/.last-diary" ]] && ok ".last-diary" || err ".last-diary not found"

typeset -a note_files
note_files=("$notes_dir"/*.adoc)

print -r -- ""
print -r -- "== AsciiDoc metadata"

metadata_errors_before=$errors
metadata_count=0
for file in "${note_files[@]}"; do
  base="${file:t}"
  is_metadata_exempt_file "$base" && continue
  metadata_count=$(( metadata_count + 1 ))

  metadata_report="$(zk_validate_document_schema "$file")"
  metadata_status=$?
  if (( metadata_status != 0 )); then
    while IFS=$'\x1f' read -r code message; do
      [[ -n "$code" ]] || continue
      err "$code notes/$base: $message"
    done <<< "$metadata_report"
  fi

  type="$(attr_value "$file" "type" 2>/dev/null)"
  keywords="$(attr_value "$file" "keywords" 2>/dev/null)"
  if [[ -n "$type" ]] && ! keyword_has "$keywords" "$type"; then
    warn "$base recommendation: add :type: value '$type' to :keywords:"
  fi
done

(( errors == metadata_errors_before )) && ok "AsciiDoc metadata: $metadata_count"

print -r -- ""
print -r -- "== Note links"

note_links_errors_before=$errors
note_links_count=0
for file in "${note_files[@]}"; do
  base="${file:t}"
  link_output="$(extract_links "$file")"
  if (( $? != 0 )); then
    err "OPAQUE_BLOCK notes/$base: unsupported or unclosed opaque block"
    continue
  fi

  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    is_placeholder_link "$target" && continue

    target="${target#link:}"

    (( note_links_count++ ))
    target_exists_from_source "$file" "$target" || broken_link "notes/$base" "$target"
  done <<< "$link_output"
done

(( errors == note_links_errors_before )) && ok "Note links: $note_links_count"

print -r -- ""
print -r -- "== all-todays links"

all_today_links_errors_before=$errors
all_today_links_count=0
for file in "$zk/all-todays"/*.adoc; do
  rel="all-todays/${file:t}"
  date_id="${file:t:r}"

  if [[ "$date_id" =~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' ]]; then
    expected_title="= Заметки за ${date_id[9,10]}-${date_id[6,7]}-${date_id[1,4]}"
    actual_title="$(sed -n '1p' "$file")"

    [[ "$actual_title" == "$expected_title" ]] || err "$rel invalid title: expected '$expected_title'"
  else
    err "$rel invalid filename: expected YYYY-MM-DD.adoc"
  fi
  link_output="$(extract_links "$file")"
  if (( $? != 0 )); then
    err "OPAQUE_BLOCK $rel: unsupported or unclosed opaque block"
    continue
  fi

  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    is_placeholder_link "$target" && continue

    target="${target#link:}"

    (( all_today_links_count++ ))
    target_exists_from_source "$file" "$target" || broken_diary_link "$rel" "$target"
  done <<< "$link_output"
done

(( errors == all_today_links_errors_before )) && ok "all-todays links: $all_today_links_count"

print -r -- ""
print -r -- "== Workspace links"

workspace_links_errors_before=$errors
workspace_links_count=0
for file in "$zk/workspaces"/*.adoc; do
  rel="workspaces/${file:t}"
  link_output="$(extract_links "$file")"
  if (( $? != 0 )); then
    err "OPAQUE_BLOCK $rel: unsupported or unclosed opaque block"
    continue
  fi

  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    is_placeholder_link "$target" && continue

    target="${target#link:}"
    (( workspace_links_count++ ))
    target_exists_from_source "$file" "$target" || broken_link "$rel" "$target"
  done <<< "$link_output"
done

(( errors == workspace_links_errors_before )) && ok "Workspace links: $workspace_links_count"

print -r -- ""
print -r -- "== .last-diary"

if [[ -f "$zk/.last-diary" ]]; then
  last="$(< "$zk/.last-diary")"

  if [[ -z "$last" ]]; then
    err ".last-diary is empty"
  elif [[ "$last" == */* || ! -f "$notes_dir/$last" ]]; then
    err ".last-diary points to missing file"
  else
    ok ".last-diary -> $last"
  fi
fi

print -r -- ""
print -r -- "== Diary chain"

diary_chain_errors_before=$errors
diary_chain_count=0
for file in "${note_files[@]}"; do
  base="${file:t}"

  [[ "$(attr_value "$file" type)" == "diary" ]] || continue
  (( diary_chain_count++ ))

  prev="$(extract_diary_chain_link "$file" "Предыдущая запись")"
  next="$(extract_diary_chain_link "$file" "Следующая запись")"

  if [[ -n "$prev" ]]; then
    is_placeholder_link "$prev" || target_exists_from_source "$file" "$prev" || broken_diary_chain "$base" "$prev"
  fi

  if [[ -n "$next" ]]; then
    is_placeholder_link "$next" || target_exists_from_source "$file" "$next" || broken_diary_chain "$base" "$next"
  fi
done

(( errors == diary_chain_errors_before )) && ok "Diary chain: $diary_chain_count"

print -r -- ""
print -r -- "== Summary"

if (( errors == 0 )); then
  print -r -- "OK    no problems found"
  if (( warnings > 0 )); then
    print -r -- "WARN  found $warnings recommendation(s)"
  fi
  exit 0
else
  print -r -- "ERROR found $errors problem(s)"
  if (( warnings > 0 )); then
    print -r -- "WARN  found $warnings recommendation(s)"
  fi
  exit 1
fi
