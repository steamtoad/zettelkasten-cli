#!/bin/zsh

#------------------------------------------------------------------------------
# zt-reduce.zsh
# Тип: Reduce
# Назначение: свертка Topic: новая Topic, deprecated старой Topic и Memo,
#             привязка Notes к новой Topic
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"

source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/uuid.zsh"
source "$script_dir/lib/asciidoc.zsh"

sep=$'\x1f'

select_topic_file() {
  local file
  local description

  for file in *.adoc; do
    zk_is_deprecated "$file" && continue
    [[ "$(zk_attr_value "$file" "type")" == "topic" ]] || continue

    description="$(zk_link_description "$file")"

    print -r -- "${file} - ${description}${sep}${file}"
  done |
    fzf \
      --delimiter="$sep" \
      --with-nth=1 \
      --prompt='reduce topic> '
}

select_reduce_mode() {
  {
    print -r -- "Full Copy"
    print -r -- "Clean Topic"
  } | fzf --prompt='Режим новой Topic> '
}

mark_deprecated() {
  local file="$1"
  local tmp

  zk_is_deprecated "$file" && return 0

  tmp="$(mktemp "${TMPDIR:-/tmp}/zk-deprecated.XXXXXX")" || return 1

  if ! awk '
    {
      print

      if (!inserted && $0 ~ /^:docfilename:/) {
        print ":deprecated:"
        inserted = 1
      }
    }

    END {
      if (!inserted) {
        print ""
        print ":deprecated:"
      }
    }
  ' "$file" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi

  if ! cat "$tmp" > "$file"; then
    rm -f "$tmp"
    return 1
  fi

  rm -f "$tmp"
}

create_full_copy_topic() {
  local src="$1"
  local dst="$2"
  local new_fname="$3"
  local description
  local new_doclink

  description="$(zk_link_description "$src")"
  new_doclink="$(zk_link "$new_fname" "$description")"

  awk \
    -v new_fname="$new_fname" \
    -v new_doclink="$new_doclink" '
      BEGIN {
        in_header = 1
      }

      NR == 1 {
        print
        next
      }

      in_header && /^:doclink:/ {
        print ":doclink: " new_doclink
        next
      }

      in_header && /^:docfilename:/ {
        print ":docfilename: " new_fname
        next
      }

      in_header && /^:deprecated:/ {
        next
      }

      in_header && /^$/ {
        in_header = 0
      }

      {
        print
      }
    ' "$src" > "$dst"
}

create_clean_topic() {
  local dst="$1"
  local new_fname="$2"
  local title="$3"
  local key_topic_line="$4"

  {
    zk_metadata "$new_fname" "$title" "topic" "topic"
    print -r -- "$key_topic_line"
    print -r -- ""
    print -r -- ""
  } > "$dst"
}

same_key_topic() {
  local file="$1"
  local expected="$2"

  [[ "$(zk_attr_value "$file" "key-topic")" == "$expected" ]]
}

zk_cd
zk_ensure_dirs

selected="$(select_topic_file)"
[[ -n "$selected" ]] || exit 0

selected="${selected%%$'\n'*}"
old_topic="${selected##*$sep}"

key_topic_line="$(zk_attr_line "$old_topic" "key-topic")"
key_topic="$(zk_attr_value "$old_topic" "key-topic")"

if [[ -z "$key_topic_line" || -z "$key_topic" ]]; then
  print -ru2 -- "ERROR selected Topic has no :key-topic:"
  exit 1
fi

mode="$(select_reduce_mode)"
[[ -n "$mode" ]] || exit 0

new_fname="$(zk_new_adoc_filename)" || exit 1

case "$mode" in
  "Full Copy")
    create_full_copy_topic "$old_topic" "$new_fname" "$new_fname" || exit 1
    ;;

  "Clean Topic")
    read -r "?Введите название для новой Topic: " title
    [[ -n "$title" ]] || exit 1

    create_clean_topic "$new_fname" "$new_fname" "$title" "$key_topic_line" || exit 1
    ;;

  *)
    print -ru2 -- "ERROR unknown Reduce mode: $mode"
    exit 1
    ;;
esac

new_description="$(zk_link_description "$new_fname")"
old_description="$(zk_link_description "$old_topic")"

new_link="$(zk_link "$new_fname" "$new_description")"
old_link="$(zk_link "$old_topic" "$old_description")"

zk_today_entry "$new_fname" "$new_description" >> "$(zk_today_file)"

typeset -a active_memo_files
typeset -a active_note_files

active_memo_files=()
active_note_files=()

for file in *.adoc; do
  [[ -f "$file" ]] || continue
  zk_is_deprecated "$file" && continue

  case "$(zk_attr_value "$file" "type")" in
    memo)
      same_key_topic "$file" "$key_topic" && active_memo_files+=("$file")
      ;;
    note)
      same_key_topic "$file" "$key_topic" && active_note_files+=("$file")
      ;;
  esac
done

zk_append_related_link "$old_topic" "== Связанные Topic" "Развитие" "$new_link"
zk_append_related_link "$new_fname" "== Связанные Topic" "Основано на" "$old_link"

# Notes are durable knowledge units.
# Reduce links active Notes to the new Topic, but never deprecates Notes.
for note_file in "${active_note_files[@]}"; do
  note_description="$(zk_link_description "$note_file")"
  note_link="$(zk_link "$note_file" "$note_description")"

  zk_append_related_link "$new_fname" "== Связанные note" "" "$note_link"
  zk_append_related_link "$note_file" "== Связи" "Topic" "$new_link"
done

# Reduce deprecates only the old Topic and active Memo with the same :key-topic:.
mark_deprecated "$old_topic" || exit 1

for memo_file in "${active_memo_files[@]}"; do
  mark_deprecated "$memo_file" || exit 1
done

print -r -- "Reduce complete"
print -r -- "Old Topic: $old_topic"
print -r -- "New Topic: $new_fname"
print -r -- "Deprecated Memo: ${#active_memo_files}"
print -r -- "Linked Note: ${#active_note_files}"

vim "$new_fname"

print -r -- "$new_link"
