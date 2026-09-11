#!/bin/zsh

#------------------------------------------------------------------------------
# zt-refine.zsh
# Тип: Refine
# Назначение: выделение выбранных документов Topic в новую тематическую линию
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"

source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/uuid.zsh"
source "$script_dir/lib/asciidoc.zsh"
source "$script_dir/lib/selection.zsh"
source "$script_dir/lib/transaction.zsh"
source "$script_dir/objects/topic-create.zsh"
source "$script_dir/zettelkasten/lib/today.zsh"

sep=$'\x1f'

header_attr_line() {
  zk_attr_line "$1" "$2"
}

header_attr_value() {
  zk_attr_value "$1" "$2"
}

is_header_deprecated() {
  [[ -n "$(header_attr_line "$1" "deprecated")" ]]
}

validate_header() {
  zk_header_is_mutable "$1"
}

validate_topic_metadata() {
  local file="$1"
  local key_topic="$2"
  local expected_title="${key_topic} - ключевая тема"

  [[ "$(zk_file_title "$file")" == "$expected_title" ]] &&
    [[ "$(header_attr_value "$file" "description")" == "$expected_title" ]] &&
    [[ "$(header_attr_value "$file" "doclink")" == "$(zk_link "$file" "$expected_title")" ]] &&
    [[ "$(header_attr_value "$file" "docfilename")" == "$file" ]]
}

select_topic_file() {
  local file
  local description
  local fingerprint

  for file in *.adoc; do
    is_header_deprecated "$file" && continue
    [[ "$(header_attr_value "$file" "type")" == "topic" ]] || continue

    description="$(zk_link_description "$file")"
    fingerprint="$(zk_selection_fingerprint "$file")"
    print -r -- "${file} - ${description}${sep}${file}${sep}${fingerprint}"
  done |
    zk_selector_fzf 'refine source topic> '
  local selector_status=$?
  zk_selector_result_status "$selector_status"
}

select_documents() {
  local file
  local description
  local type
  local fingerprint

  for file in "${candidate_files[@]}"; do
    type="$(header_attr_value "$file" "type")"
    description="$(zk_link_description "$file")"
    fingerprint="$(zk_selection_fingerprint "$file")"
    print -r -- "${file} - ${description} (${type})${sep}${file}${sep}${fingerprint}"
  done |
    zk_selector_fzf 'refine documents> ' --multi
  local selector_status=$?
  zk_selector_result_status "$selector_status"
}

select_archive_source() {
  {
    print -r -- "Нет"
    print -r -- "Да"
  } | zk_selector_fzf 'Архивировать исходную Topic? '
  local selector_status=$?
  zk_selector_result_status "$selector_status"
}

replace_header_key_topic() {
  local file="$1"
  local new_key="$2"
  local tmp

  zk_header_is_mutable "$file" || return 1
  zk_validate_single_line ":key-topic:" "$new_key" required || return 1
  tmp="$(mktemp "${file:h}/.${file:t}.key-topic.XXXXXX")" || return 1

  if ! awk -v new_key="$new_key" '
    BEGIN { in_header = 1 }

    in_header && /^:key-topic:/ {
      print ":key-topic: " new_key
      replaced = 1
      next
    }

    in_header && /^[[:space:]]*$/ {
      in_header = 0
    }

    { print }

    END {
      if (!replaced) exit 2
    }
  ' "$file" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  zk_replace_with_prepared_file "$file" "$tmp"
}

remove_related_link() {
  local file="$1"
  local target="$2"

  zk_remove_links_atomic "$file" --allow-absent "$target"
}

mark_deprecated() {
  local file="$1"
  local tmp

  is_header_deprecated "$file" && return 0

  zk_header_is_mutable "$file" || return 1
  tmp="$(mktemp "${file:h}/.${file:t}.deprecated.XXXXXX")" || return 1

  if ! awk '
    NR == 1 {
      print
      next
    }

    /^[[:space:]]*$/ && !inserted {
      print ":deprecated:"
      inserted = 1
      print
      next
    }

    { print }

    END {
      if (!inserted) exit 2
    }
  ' "$file" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  zk_replace_with_prepared_file "$file" "$tmp"
}

create_topic() {
  local output_file="$1"
  local file="$2"
  local key="$3"
  local title="${key} - ключевая тема"

  zk_topic_write "$output_file" "$file" "$title" "$key" "topic" "$title"
}

print_plan() {
  print -r -- "== Refine plan"
  print -r -- "Source Topic: $source_topic"
  print -r -- "Source Key Topic: $source_key"
  print -r -- "New Topic: $new_fname"
  print -r -- "New Key Topic: $new_key"
  print -r -- "Archive Source Topic: $archive_source"
  print -r -- "Selected Documents: ${#selected_files}"

  for file in "${selected_files[@]}"; do
    print -r -- "  rekey: $file"
    print -r -- "  remove link: $source_topic <-> $file"
    print -r -- "  add link: $new_fname <-> $file"
  done

  if [[ "$archive_source" == "Да" ]]; then
    print -r -- "  archive: $source_topic"

    for file in "${unselected_files[@]}"; do
      print -r -- "  archive with source: $file"
    done
  fi

  print -r -- "  provenance: $source_topic <-> $new_fname"
}

confirm_refine() {
  local answer

  read -r "?Применить Refine? [y/N]: " answer
  [[ "$answer" == [yY] ]]
}

rollback_apply() {
  local file
  local current_identity

  for file in "${existing_apply_files[@]}"; do
    cp "$backup_dir/${file:t}" "$file" || true
  done

  if (( new_target_owned )); then
    if [[ -e "$new_fname" || -L "$new_fname" ]]; then
      current_identity="$(zk_file_identity "$new_fname")" || current_identity=""
      if [[ -n "$new_target_identity" && "$current_identity" == "$new_target_identity" ]]; then
        rm -f -- "$new_fname" || true
      else
        print -ru2 -- "ERROR Refine rollback preserved changed destination identity: $new_fname"
      fi
    fi
  fi

  if (( today_target_owned )) && [[ -n "$today_file" ]]; then
    if [[ -e "$today_file" || -L "$today_file" ]]; then
      current_identity="$(zk_file_identity "$today_file")" || current_identity=""
      if [[ -n "$today_target_identity" && "$current_identity" == "$today_target_identity" ]]; then
        rm -f -- "$today_file" || true
      else
        print -ru2 -- "ERROR Refine rollback preserved changed all-todays identity: $today_file"
      fi
    fi
  fi
}

if [[ -z "${ZK_TXN_STAGE_MODE:-}" ]]; then
  zk_require_fzf || exit 1
  zk_require_command vim || exit 1
  zk_txn_run_staged_workflow refine "$0" "$@"
  exit $?
fi

zk_require_fzf || exit 1
zk_require_command vim || exit 1
zk_ensure_notes_dir
zk_cd_notes || exit 1

selected="$(select_topic_file)"
selection_status=$?
case "$selection_status" in 0) ;; 1) exit 1 ;; 130) exit 0 ;; *) exit "$selection_status" ;; esac
[[ -n "$selected" ]] || exit 1

source_topic="$(zk_selection_identity "$selected")"
source_topic_fingerprint="$(zk_selection_fingerprint_field "$selected")"
zk_selection_validate_note "$source_topic" topic "$source_topic_fingerprint" || exit 1
source_key="$(header_attr_value "$source_topic" "key-topic")"

if [[ -z "$source_key" ]]; then
  print -ru2 -- "ERROR selected Topic has no header :key-topic:"
  exit 1
fi

if ! validate_header "$source_topic" || ! validate_topic_metadata "$source_topic" "$source_key"; then
  print -ru2 -- "ERROR source Topic metadata is not canonical"
  exit 1
fi

read -r "?Введите название новой тематической линии: " new_key
new_key="${new_key#"${new_key%%[![:space:]]*}"}"
new_key="${new_key%"${new_key##*[![:space:]]}"}"

if [[ -z "$new_key" || "$new_key" == "$source_key" ]]; then
  print -ru2 -- "ERROR new :key-topic: must be non-empty and different from source"
  exit 1
fi

for file in *.adoc; do
  is_header_deprecated "$file" && continue
  [[ "$(header_attr_value "$file" "type")" == "topic" ]] || continue

  if [[ "$(header_attr_value "$file" "key-topic")" == "$new_key" ]]; then
    print -ru2 -- "ERROR active Topic already exists for :key-topic: $new_key"
    exit 1
  fi
done

typeset -a candidate_files
typeset -a selected_files
typeset -a unselected_files
typeset -A selected_file_set
typeset -A selected_file_fingerprints
typeset -A candidate_file_fingerprints
typeset -A candidate_file_types

candidate_files=()
selected_files=()
unselected_files=()
selected_file_set=()
selected_file_fingerprints=()
candidate_file_fingerprints=()
candidate_file_types=()

for file in *.adoc; do
  [[ "$file" == "$source_topic" ]] && continue
  is_header_deprecated "$file" && continue
  [[ "$(header_attr_value "$file" "key-topic")" == "$source_key" ]] || continue

  case "$(header_attr_value "$file" "type")" in
    memo|note|todo|diary)
      candidate_files+=("$file")
      candidate_file_types[$file]="$(header_attr_value "$file" "type")"
      candidate_file_fingerprints[$file]="$(zk_selection_fingerprint "$file")"
      ;;
  esac
done

(( ${#candidate_files} > 0 )) || {
  print -ru2 -- "ERROR source Topic has no active documents available for Refine"
  exit 1
}

selected="$(select_documents)"
selection_status=$?
case "$selection_status" in 0) ;; 1) exit 1 ;; 130) exit 0 ;; *) exit "$selection_status" ;; esac
[[ -n "$selected" ]] || exit 1

while IFS= read -r line; do
  [[ -n "$line" ]] || continue
  file="$(zk_selection_identity "$line")"
  selected_files+=("$file")
  selected_file_fingerprints[$file]="$(zk_selection_fingerprint_field "$line")"
done <<< "$selected"

(( ${#selected_files} > 0 )) || exit 0

for file in "${selected_files[@]}"; do
  selected_file_set[$file]=1
done

for file in "${candidate_files[@]}"; do
  [[ -n "${selected_file_set[$file]-}" ]] && continue
  unselected_files+=("$file")
done

archive_source="$(select_archive_source)"
selection_status=$?
case "$selection_status" in 0) ;; 1) exit 1 ;; 130) exit 0 ;; *) exit "$selection_status" ;; esac
[[ -n "$archive_source" ]] || exit 1

if [[ "$archive_source" != "Да" && "$archive_source" != "Нет" ]]; then
  print -ru2 -- "ERROR unknown archive choice: $archive_source"
  exit 1
fi

for file in "$source_topic" "${selected_files[@]}"; do
  if ! validate_header "$file"; then
    print -ru2 -- "ERROR cannot determine AsciiDoc header boundary: $file"
    exit 1
  fi
done

if [[ "$archive_source" == "Да" ]]; then
  for file in "${unselected_files[@]}"; do
    if ! validate_header "$file"; then
      print -ru2 -- "ERROR cannot determine AsciiDoc header boundary: $file"
      exit 1
    fi
  done
fi

new_fname="$(zk_new_adoc_filename)" || exit 1
new_title="${new_key} - ключевая тема"
new_link="$(zk_link "$new_fname" "$new_title")"
source_link="$(zk_link "$source_topic" "$(zk_link_description "$source_topic")")"

print_plan
confirm_refine || exit 0

zk_selection_validate_note "$source_topic" topic "$source_topic_fingerprint" || exit 1
for file in "${selected_files[@]}"; do
  zk_selection_validate_note "$file" "${candidate_file_types[$file]}" "${selected_file_fingerprints[$file]}" || exit 1
done
if [[ "$archive_source" == "Да" ]]; then
  for file in "${unselected_files[@]}"; do
    zk_selection_validate_note "$file" "${candidate_file_types[$file]}" "${candidate_file_fingerprints[$file]}" || exit 1
  done
fi

stage_dir="$(mktemp -d "${TMPDIR:-/tmp}/zk-refine-stage.XXXXXX")" || exit 1
backup_dir="$(mktemp -d "${TMPDIR:-/tmp}/zk-refine-backup.XXXXXX")" || {
  rm -rf "$stage_dir"
  exit 1
}

cp "$source_topic" "$stage_dir/$source_topic" || exit 1

for file in "${selected_files[@]}"; do
  cp "$file" "$stage_dir/$file" || exit 1
done

if [[ "$archive_source" == "Да" ]]; then
  for file in "${unselected_files[@]}"; do
    cp "$file" "$stage_dir/$file" || exit 1
  done
fi

create_topic "$stage_dir/$new_fname" "$new_fname" "$new_key" || exit 1

for file in "${selected_files[@]}"; do
  staged_file="$stage_dir/$file"
  file_type="$(header_attr_value "$file" "type")"
  file_link="$(zk_link "$file" "$(zk_link_description "$file")")"

  replace_header_key_topic "$staged_file" "$new_key" || exit 1
  remove_related_link "$stage_dir/$source_topic" "$file" || exit 1
  remove_related_link "$staged_file" "$source_topic" || exit 1
  zk_append_related_link "$stage_dir/$new_fname" "== Связанные ${file_type}" "" "$file_link" || exit 1
  zk_append_related_link "$staged_file" "== Связи" "Topic" "$new_link" || exit 1
done

zk_append_related_link "$stage_dir/$source_topic" "== Связанные Topic" "Выделенная тема" "$new_link" || exit 1
zk_append_related_link "$stage_dir/$new_fname" "== Связанные Topic" "Выделено из" "$source_link" || exit 1

if [[ "$archive_source" == "Да" ]]; then
  mark_deprecated "$stage_dir/$source_topic" || exit 1

  for file in "${unselected_files[@]}"; do
    mark_deprecated "$stage_dir/$file" || exit 1
  done
fi

today_file="$(zt_today_file)"
mkdir -p "$stage_dir/all-todays" || exit 1

if [[ -f "$today_file" ]]; then
  cp "$today_file" "$stage_dir/all-todays/${today_file:t}" || exit 1
else
  print -r -- "= Заметки за $(date +"%d-%m-%Y")" > "$stage_dir/all-todays/${today_file:t}"
  print -r -- "" >> "$stage_dir/all-todays/${today_file:t}"
fi

zt_today_entry "$new_fname" "$new_title" >> "$stage_dir/all-todays/${today_file:t}"

for file in "$source_topic" "${selected_files[@]}" "$new_fname"; do
  validate_header "$stage_dir/$file" || {
    print -ru2 -- "ERROR staged document has invalid header: $file"
    exit 1
  }
done

if [[ "$archive_source" == "Да" ]]; then
  for file in "${unselected_files[@]}"; do
    validate_header "$stage_dir/$file" || {
      print -ru2 -- "ERROR staged document has invalid header: $file"
      exit 1
    }
  done
fi

typeset -a existing_apply_files
existing_apply_files=("$source_topic" "${selected_files[@]}")

if [[ "$archive_source" == "Да" ]]; then
  existing_apply_files+=("${unselected_files[@]}")
fi

for file in "${existing_apply_files[@]}"; do
  cp "$file" "$backup_dir/${file:t}" || exit 1
done

if [[ -f "$today_file" ]]; then
  existing_apply_files+=("$today_file")
  cp "$today_file" "$backup_dir/${today_file:t}" || exit 1
fi

apply_failed=0
new_target_owned=0
new_target_identity=""
today_target_owned=0
today_target_identity=""

trap 'rollback_apply; print -ru2 -- "ERROR Refine interrupted; changes rolled back"; exit 1' INT TERM HUP

if zk_create_exclusive_from_file "$stage_dir/$new_fname" "$new_fname"; then
  new_target_owned=1
  new_target_identity="$(zk_file_identity "$new_fname")" || apply_failed=1
else
  apply_failed=1
fi

for file in "$source_topic" "${selected_files[@]}" "${unselected_files[@]}"; do
  (( apply_failed )) && break
  [[ -f "$stage_dir/$file" ]] || continue
  zk_replace_from_file_atomic "$file" "$stage_dir/$file" || apply_failed=1
done

if (( ! apply_failed )); then
  mkdir -p "${today_file:h}" || apply_failed=1
fi
if (( ! apply_failed )); then
  if [[ -f "$today_file" ]]; then
    zk_replace_from_file_atomic "$today_file" "$stage_dir/all-todays/${today_file:t}" || apply_failed=1
  elif zk_create_exclusive_from_file "$stage_dir/all-todays/${today_file:t}" "$today_file"; then
    today_target_owned=1
    today_target_identity="$(zk_file_identity "$today_file")" || apply_failed=1
  else
    apply_failed=1
  fi
fi

if (( apply_failed )); then
  rollback_apply
  print -ru2 -- "ERROR Refine failed; changes rolled back"
  exit 1
fi

trap - INT TERM HUP

rm -rf "$stage_dir" "$backup_dir"

zk_txn_open_editor "$(zk_note_path "$new_fname")" || exit $?

typeset -a refine_output
refine_output=(
  "Refine complete"
  "Source Topic: $source_topic"
  "New Topic: $new_fname"
  "Rekeyed Documents: ${#selected_files}"
  "Archived Source Topic: $archive_source"
)
if [[ "$archive_source" == "Да" ]]; then
  refine_output+=("Archived Unselected Documents: ${#unselected_files}")
fi
refine_output+=("$new_link")
zk_txn_defer_output "${refine_output[@]}"
