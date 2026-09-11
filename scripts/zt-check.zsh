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
source "$script_dir/lib/uuid.zsh"
source "$script_dir/lib/transaction.zsh"

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

extract_diary_chain_links() {
  zk_extract_labeled_links "$1" "$2"
}

is_historical_topic_link() {
  local file="$1"
  local target="$2"
  local label
  local links

  for label in 'Основано на' 'Развитие' 'Выделено из' 'Выделенная тема'; do
    links="$(zk_extract_labeled_links "$file" "$label")" || return 1
    [[ "${(f)links}" == *"$target"* ]] && return 0
  done

  return 1
}

diary_error() {
  err "$1 $2"
}

memo_cycle_visit() {
  local node="$1"
  local child

  [[ "${memo_visit[$node]-}" == done ]] && return 0
  [[ "${memo_visit[$node]-}" == visiting ]] && return 2

  memo_visit[$node]=visiting
  for child in ${(f)"${memo_children[$node]-}"}; do
    memo_cycle_visit "$child" || return $?
  done
  memo_visit[$node]=done
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
[[ -f "$zk/.last-diary" ]] && ok ".last-diary" || warn ".last-diary not found"

pending_transactions="$(zk_txn_pending_paths)"
if [[ -n "$pending_transactions" ]]; then
  while IFS= read -r pending_transaction; do
    [[ -n "$pending_transaction" ]] || continue
    err "RECOVERY_REQUIRED $pending_transaction"
  done <<< "$pending_transactions"
else
  ok "transactions"
fi

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
print -r -- "== Topic membership"

typeset -A active_topics_by_key
active_topics_by_key=()

for file in "${note_files[@]}"; do
  [[ "$(attr_value "$file" type)" == topic ]] || continue
  has_attr "$file" deprecated && continue
  key_topic="$(attr_value "$file" key-topic)"
  [[ -n "$key_topic" ]] || continue
  active_topics_by_key[$key_topic]+="${file:t}"$'\n'
done

for key_topic in "${(@k)active_topics_by_key}"; do
  topic_members=("${(@f)${active_topics_by_key[$key_topic]}}")
  (( ${#topic_members[@]} > 1 )) || continue
  warn "AMBIGUOUS_TOPIC_LINE :key-topic: $key_topic -> ${(j:, :)topic_members}"
done

for file in "${note_files[@]}"; do
  link_output="$(extract_links "$file")" || continue
  while IFS= read -r target; do
    [[ -n "$target" && "$target" != */* ]] || continue
    target_file="$notes_dir/${target#link:}"
    [[ -f "$target_file" ]] || continue
    [[ "$(attr_value "$target_file" type)" == topic ]] || continue
    has_attr "$target_file" deprecated || continue
    is_historical_topic_link "$file" "${target_file:t}" && continue
    warn "DEPRECATED_TOPIC_LINK notes/${file:t} -> ${target_file:t} has no provenance label"
  done <<< "$link_output"
done

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
print -r -- ""
print -r -- "== Diary chain"

diary_chain_errors_before=$errors
diary_chain_count=0
typeset -a diary_files
typeset -A diary_prev diary_next diary_seen
diary_files=()
for file in "${note_files[@]}"; do
  base="${file:t}"

  [[ "$(attr_value "$file" type)" == "diary" ]] || continue
  (( diary_chain_count++ ))
  diary_files+=("$base")

  prev_links=("${(@f)$(extract_diary_chain_links "$file" "Предыдущая запись")}")
  next_links=("${(@f)$(extract_diary_chain_links "$file" "Следующая запись")}")
  prev_links=("${(@)prev_links:#}")
  next_links=("${(@)next_links:#}")

  if (( ${#prev_links[@]} > 1 )); then
    diary_error "DIARY_MULTIPLE_PREVIOUS" "notes/$base has ${#prev_links[@]} previous links"
  elif (( ${#prev_links[@]} == 1 )); then
    prev="${prev_links[1]}"
    if [[ "$prev" == */* || ! -f "$notes_dir/$prev" ]]; then
      diary_error "DIARY_LINK_MISSING" "notes/$base previous -> $prev"
    elif [[ "$(attr_value "$notes_dir/$prev" type)" != diary ]]; then
      diary_error "DIARY_LINK_TYPE" "notes/$base previous -> $prev"
    else
      diary_prev[$base]="$prev"
    fi
  fi

  if (( ${#next_links[@]} > 1 )); then
    diary_error "DIARY_MULTIPLE_NEXT" "notes/$base has ${#next_links[@]} next links"
  elif (( ${#next_links[@]} == 1 )); then
    next="${next_links[1]}"
    if [[ "$next" == */* || ! -f "$notes_dir/$next" ]]; then
      diary_error "DIARY_LINK_MISSING" "notes/$base next -> $next"
    elif [[ "$(attr_value "$notes_dir/$next" type)" != diary ]]; then
      diary_error "DIARY_LINK_TYPE" "notes/$base next -> $next"
    else
      diary_next[$base]="$next"
    fi
  fi
done

for base in "${diary_files[@]}"; do
  prev="${diary_prev[$base]-}"
  next="${diary_next[$base]-}"
  if [[ -n "$prev" && "${diary_next[$prev]-}" != "$base" ]]; then
    diary_error "DIARY_LINK_RECIPROCITY" "notes/$base previous -> $prev is not reciprocal"
  fi
  if [[ -n "$next" && "${diary_prev[$next]-}" != "$base" ]]; then
    diary_error "DIARY_LINK_RECIPROCITY" "notes/$base next -> $next is not reciprocal"
  fi
  if [[ -n "$prev" ]]; then
    prev_date="$(attr_value "$notes_dir/$prev" date)"
    date_value="$(attr_value "$notes_dir/$base" date)"
    [[ "$prev_date" > "$date_value" ]] && diary_error "DIARY_DATE_ORDER" "notes/$prev -> $base"
  fi
done

typeset -a diary_heads diary_tails
diary_heads=()
diary_tails=()
for base in "${diary_files[@]}"; do
  [[ -z "${diary_prev[$base]-}" ]] && diary_heads+=("$base")
  [[ -z "${diary_next[$base]-}" ]] && diary_tails+=("$base")
done

print -r -- ""
print -r -- "== .last-diary"
last=""
[[ -f "$zk/.last-diary" ]] && last="$(< "$zk/.last-diary")"
if (( diary_chain_count == 0 )); then
  if [[ -n "$last" ]]; then
    diary_error "DIARY_POINTER_ORPHAN" ".last-diary points to $last but no Diary exists"
  else
    ok ".last-diary absent for initialized empty Vault"
  fi
else
  if [[ -z "$last" ]]; then
    diary_error "DIARY_POINTER_MISSING" "existing Diary chain has no .last-diary"
  elif [[ "$last" == */* || ! -f "$notes_dir/$last" ]] || ! zk_is_uuid_v1 "${last:r}"; then
    diary_error "DIARY_POINTER_INVALID" ".last-diary -> $last"
  elif [[ "$(attr_value "$notes_dir/$last" type)" != diary ]]; then
    diary_error "DIARY_POINTER_TYPE" ".last-diary -> $last"
  elif (( ${#diary_tails[@]} == 1 )) && [[ "$last" != "${diary_tails[1]}" ]]; then
    diary_error "DIARY_POINTER_NOT_TAIL" ".last-diary -> $last"
  else
    ok ".last-diary -> $last"
  fi
fi

if (( diary_chain_count > 0 )); then
  if (( ${#diary_heads[@]} != 1 || ${#diary_tails[@]} != 1 )); then
    diary_error "DIARY_CHAIN_GRAPH" "expected one head and one tail, got ${#diary_heads[@]} and ${#diary_tails[@]}"
  elif [[ -n "${diary_heads[1]-}" ]]; then
    current="${diary_heads[1]}"
    while [[ -n "$current" ]]; do
      if [[ -n "${diary_seen[$current]-}" ]]; then
        diary_error "DIARY_CHAIN_CYCLE" "notes/$current"
        break
      fi
      diary_seen[$current]=1
      current="${diary_next[$current]-}"
    done
    if (( ${#diary_seen[@]} != diary_chain_count )); then
      diary_error "DIARY_CHAIN_DISCONNECTED" "visited ${#diary_seen[@]} of $diary_chain_count Diary documents"
    fi
  fi
fi

(( errors == diary_chain_errors_before )) && ok "Diary chain: $diary_chain_count"

print -r -- ""
print -r -- "== Memo chain"

memo_chain_errors_before=$errors
memo_chain_count=0
typeset -a memo_files
typeset -A memo_prev memo_children memo_visit
memo_files=()
for file in "${note_files[@]}"; do
  base="${file:t}"
  [[ "$(attr_value "$file" type)" == memo ]] || continue
  (( memo_chain_count++ ))
  memo_files+=("$base")

  prev_links=("${(@f)$(zk_extract_labeled_links "$file" "Предыдущее memo")}")
  next_links=("${(@f)$(zk_extract_labeled_links "$file" "Следующее memo")}")
  branch_links=("${(@f)$(zk_extract_labeled_links "$file" "Ветка:")}")
  prev_links=("${(@)prev_links:#}")
  next_links=("${(@)next_links:#}")
  branch_links=("${(@)branch_links:#}")

  if (( ${#prev_links[@]} > 1 )); then
    err "MEMO_MULTIPLE_PREVIOUS notes/$base"
  elif (( ${#prev_links[@]} == 1 )); then
    prev="${prev_links[1]}"
    if [[ "$prev" == */* || ! -f "$notes_dir/$prev" || "$(attr_value "$notes_dir/$prev" type)" != memo ]]; then
      err "MEMO_LINK_TYPE notes/$base previous -> $prev"
    else
      memo_prev[$base]="$prev"
    fi
  fi

  if (( ${#next_links[@]} > 1 )); then
    err "MEMO_MULTIPLE_NEXT notes/$base"
  fi
  outgoing=("${next_links[@]}" "${branch_links[@]}")
  for target in "${outgoing[@]}"; do
    [[ -n "$target" ]] || continue
    if [[ "$target" == */* || ! -f "$notes_dir/$target" || "$(attr_value "$notes_dir/$target" type)" != memo ]]; then
      err "MEMO_LINK_TYPE notes/$base next -> $target"
      continue
    fi
    memo_children[$base]+="${target}"$'\n'
  done
done

for base in "${memo_files[@]}"; do
  for target in ${(f)"${memo_children[$base]-}"}; do
    [[ "${memo_prev[$target]-}" == "$base" ]] || err "MEMO_LINK_RECIPROCITY notes/$base -> $target"
  done
done

for base in "${memo_files[@]}"; do
  memo_cycle_visit "$base"
  case $? in
    0) ;;
    2) err "MEMO_CHAIN_CYCLE notes/$base"; break ;;
    *) err "MEMO_CHAIN_INVALID notes/$base"; break ;;
  esac
done

(( errors == memo_chain_errors_before )) && ok "Memo chain: $memo_chain_count"

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
