#!/bin/zsh

#------------------------------------------------------------------------------
# asciidoc.zsh
# Тип: Library
# Назначение: нейтральные операции над AsciiDoc-документами и ссылками
#------------------------------------------------------------------------------

zk_link() {
  local fname="$1"
  local title="$2"
  local escaped_title

  zk_validate_single_line "link target" "$fname" required || return 1
  zk_validate_single_line "link description" "$title" required || return 1

  escaped_title="${title//\\/\\\\}"
  escaped_title="${escaped_title//\]/\\]}"

  print -r -- "link:${fname}[$escaped_title]"
}

zk_root_note_link() {
  local fname="$1"
  local title="$2"

  zk_link "notes/${fname}" "$title"
}

zk_attr_line() {
  emulate -L zsh

  local file="$1"
  local attr="$2"

  [[ -f "$file" ]] || return 1
  [[ -n "$attr" ]] || return 1

  awk -v attr="$attr" '
    NR == 1 {
      if ($0 !~ /^= /) exit
      next
    }

    /^[[:space:]]*$/ { exit }

    /^:[[:alnum:]_-]+:/ {
      if (index($0, ":" attr ":") == 1) {
        print
        exit
      }

      next
    }

    {
      exit
    }
  ' "$file"
}

zk_validate_single_line() {
  emulate -L zsh

  local label="$1"
  local value="$2"
  local presence="${3:-optional}"
  local trimmed="$value"

  if [[ "$value" == *$'\n'* || "$value" == *$'\r'* || "$value" == *$'\x1f'* ]]; then
    print -ru2 -- "ERROR $label must be a single line"
    return 1
  fi

  trimmed="${trimmed#"${trimmed%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  if [[ "$presence" == "required" && -z "$trimmed" ]]; then
    print -ru2 -- "ERROR $label is empty"
    return 1
  fi
}

zk_header_is_mutable() {
  local file="$1"

  awk '
    NR == 1 {
      if ($0 !~ /^= [^[:space:]]/) exit 2
      next
    }
    /^[[:space:]]*$/ { boundary = 1; exit }
    /^:[[:alnum:]_-]+:($| .*)/ { next }
    { exit 3 }
    END { if (!boundary) exit 4 }
  ' "$file"
}

zk_extract_links() {
  local file="$1"

  awk '
    function trim(line) {
      sub(/^[[:space:]]+/, "", line)
      sub(/[[:space:]]+$/, "", line)
      return line
    }
    function delimiter(line, value) {
      value = trim(line)
      if (value ~ /^`{3,}/) return substr(value, 1, 3)
      if (value ~ /^-{4,}$/) return value
      if (value ~ /^\.{4,}$/) return value
      if (value ~ /^_{4,}$/) return value
      if (value ~ /^\*{4,}$/) return value
      if (value ~ /^={4,}$/) return value
      if (value ~ /^\+{4,}$/) return value
      if (value ~ /^\/{4,}$/) return value
      return ""
    }
    {
      current = delimiter($0)
      if (in_block) {
        if ((block == "```" && current == "```") || (block != "```" && trim($0) == block)) {
          in_block = 0
          block = ""
        }
        next
      }
      if (current != "") {
        in_block = 1
        block = current
        next
      }
      if ($0 ~ /^:doclink:/) next
      line = $0
      while (match(line, /link:[^[]+\.adoc\[/)) {
        print substr(line, RSTART + 5, RLENGTH - 6)
        line = substr(line, RSTART + RLENGTH)
      }
    }
    END { if (in_block) exit 2 }
  ' "$file"
}

zk_extract_labeled_link() {
  local file="$1"
  local label="$2"

  awk -v label="$label" '
    function trim(line) { sub(/^[[:space:]]+/, "", line); sub(/[[:space:]]+$/, "", line); return line }
    function delimiter(line, value) {
      value = trim(line)
      if (value ~ /^`{3,}/) return substr(value, 1, 3)
      if (value ~ /^-{4,}$/ || value ~ /^\.{4,}$/ || value ~ /^_{4,}$/ ||
          value ~ /^\*{4,}$/ || value ~ /^={4,}$/ || value ~ /^\+{4,}$/ || value ~ /^\/{4,}$/) return value
      return ""
    }
    {
      current = delimiter($0)
      if (in_block) {
        if ((block == "```" && current == "```") || (block != "```" && trim($0) == block)) { in_block = 0; block = "" }
        next
      }
      if (current != "") { in_block = 1; block = current; next }
      if (index($0, label) && match($0, /link:[^[]+\.adoc\[/)) {
        print substr($0, RSTART + 5, RLENGTH - 6)
        found = 1
        exit
      }
    }
    END { if (in_block) exit 2 }
  ' "$file"
}

zk_validate_extra_attrs() {
  emulate -L zsh

  local attr
  local rest
  local name
  local value
  local normalized_name
  local -A seen

  for attr in "$@"; do
    [[ -n "$attr" ]] || continue

    if [[ "$attr" == *$'\n'* || "$attr" == *$'\r'* ]]; then
      print -ru2 -- "ERROR extra attribute must be a single line: $attr"
      return 1
    fi

    [[ "$attr" == :* ]] || {
      print -ru2 -- "ERROR invalid AsciiDoc attribute: $attr"
      return 1
    }

    rest="${attr#:}"
    [[ "$rest" == *:* ]] || {
      print -ru2 -- "ERROR invalid AsciiDoc attribute: $attr"
      return 1
    }

    name="${rest%%:*}"
    value="${rest#*:}"

    [[ -n "$name" && "$name" != *[!A-Za-z0-9_-]* ]] || {
      print -ru2 -- "ERROR invalid AsciiDoc attribute name: $attr"
      return 1
    }

    if [[ -n "$value" && "$value" != ' '* ]]; then
      print -ru2 -- "ERROR invalid AsciiDoc attribute spacing: $attr"
      return 1
    fi

    normalized_name="${name:l}"

    case "$normalized_name" in
      date|type|keywords|author|description|doclink|docfilename)
        print -ru2 -- "ERROR reserved object attribute cannot be overridden: :$name:"
        return 1
        ;;
    esac

    if [[ -n "${seen[$normalized_name]-}" ]]; then
      print -ru2 -- "ERROR duplicate extra attribute: :$name:"
      return 1
    fi

    seen[$normalized_name]=1
  done
}

zk_validate_object_fields() {
  local fname="$1"
  local title="$2"
  local keywords="$3"
  local type="$4"
  local description="$5"
  shift 5

  zk_validate_single_line "filename" "$fname" required || return 1
  if [[ "$fname" != "pending.adoc" && ! "$fname" =~ '^[[:xdigit:]]{8}-[[:xdigit:]]{4}-1[[:xdigit:]]{3}-[89aAbB][[:xdigit:]]{3}-[[:xdigit:]]{12}\.adoc$' ]]; then
    print -ru2 -- "ERROR filename is not UUID v1 AsciiDoc: $fname"
    return 1
  fi
  zk_validate_single_line "title" "$title" required || return 1
  zk_validate_single_line "keywords" "$keywords" optional || return 1
  zk_validate_single_line "type" "$type" required || return 1
  zk_validate_single_line "description" "$description" required || return 1
  case "$type" in
    note|memo|todo|diary|topic) ;;
    *)
      print -ru2 -- "ERROR invalid persistent document type: $type"
      return 1
      ;;
  esac
  zk_validate_extra_attrs "$@"
}

zk_object_render_header() {
  emulate -L zsh

  local fname="$1"
  local title="$2"
  local keywords="$3"
  local type="$4"
  local description="$5"
  shift 5
  local attr
  local -a extra_attrs=("$@")

  zk_validate_object_fields "$fname" "$title" "$keywords" "$type" "$description" "${extra_attrs[@]}" || return 1

  zk_metadata "$fname" "$title" "$keywords" "$type" "$description" || return 1
  for attr in "${extra_attrs[@]}"; do
    [[ -n "$attr" ]] && print -r -- "$attr"
  done
  print -r -- ""
}

zk_attr_value() {
  local line

  line="$(zk_attr_line "$1" "$2")"
  [[ -n "$line" ]] || return 1

  line="${line#:$2:}"
  line="${line#"${line%%[![:space:]]*}"}"
  print -r -- "$line"
}

zk_has_attr() {
  [[ -n "$(zk_attr_line "$1" "$2")" ]]
}

zk_is_deprecated() {
  zk_has_attr "$1" "deprecated"
}

zk_validate_document_schema() {
  emulate -L zsh

  local file="$1"
  local base="${file:t}"
  local stem="${base:r}"
  local output
  local result_status=0
  local title
  local type
  local description
  local doclink
  local expected_link
  local key_topic
  local delimiter=$'\x1f'

  [[ -s "$file" ]] || {
    print -r -- "EMPTY_DOCUMENT${delimiter}zero-byte document"
    return 1
  }

  output="$(awk '
    function emit(code, message) { print code "\037" message; invalid = 1 }
    function leap(year) { return (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) }
    function valid_date(value, parts, year, month, day, maxday) {
      if (value !~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/) return 0
      split(value, parts, "-"); year = parts[1] + 0; month = parts[2] + 0; day = parts[3] + 0
      if (month < 1 || month > 12 || day < 1) return 0
      maxday = 31
      if (month == 4 || month == 6 || month == 9 || month == 11) maxday = 30
      if (month == 2) maxday = leap(year) ? 29 : 28
      return day <= maxday
    }
    NR == 1 {
      if ($0 !~ /^= [^[:space:]]/) emit("MISSING_TITLE", "missing or invalid document title")
      next
    }
    in_body { next }
    /^[[:space:]]*$/ { in_body = 1; next }
    /^:[[:alnum:]_-]+:/ {
      raw = substr($0, 2); colon = index(raw, ":")
      name = tolower(substr(raw, 1, colon - 1)); value = substr(raw, colon + 1)
      if (name in seen) emit("DUPLICATE_ATTRIBUTE", "duplicate :" name ":")
      seen[name] = 1
      if (value != "" && value !~ /^ /) emit("INVALID_ATTRIBUTE", "invalid spacing for :" name ":")
      sub(/^ /, "", value); attr[name] = value
      next
    }
    { in_body = 1 }
    END {
      count = split("date type keywords author description doclink docfilename", required, " ")
      for (i = 1; i <= count; i++) if (!(required[i] in seen)) emit("MISSING_ATTRIBUTE", "missing :" required[i] ":")
      if (("date" in seen) && !valid_date(attr["date"])) emit("INVALID_DATE", "invalid :date: " attr["date"])
      if (("type" in seen) && attr["type"] !~ /^(note|memo|todo|diary|topic)$/) emit("INVALID_TYPE", "invalid persistent :type: " attr["type"])
      if (("author" in seen) && attr["author"] ~ /^[[:space:]]*$/) emit("EMPTY_ATTRIBUTE", "empty :author:")
      if (("description" in seen) && attr["description"] ~ /^[[:space:]]*$/) emit("EMPTY_ATTRIBUTE", "empty :description:")
      exit invalid
    }
  ' "$file")" || result_status=1
  [[ -z "$output" ]] || print -r -- "$output"

  if [[ ! "$stem" =~ '^[[:xdigit:]]{8}-[[:xdigit:]]{4}-1[[:xdigit:]]{3}-[89aAbB][[:xdigit:]]{3}-[[:xdigit:]]{12}$' ]]; then
    print -r -- "INVALID_UUID${delimiter}filename is not UUID v1: $base"
    result_status=1
  fi

  if [[ "$(zk_attr_value "$file" "docfilename" 2>/dev/null)" != "$base" ]]; then
    print -r -- "INVALID_DOCFILENAME${delimiter}:docfilename: does not match $base"
    result_status=1
  fi

  title="$(zk_file_title "$file")"
  type="$(zk_attr_value "$file" "type" 2>/dev/null)"
  description="$(zk_attr_value "$file" "description" 2>/dev/null)"
  doclink="$(zk_attr_value "$file" "doclink" 2>/dev/null)"
  expected_link="$(zk_link "$base" "$description" 2>/dev/null)" || expected_link=""
  if [[ -z "$expected_link" || "$doclink" != "$expected_link" ]]; then
    print -r -- "INVALID_DOCLINK${delimiter}:doclink: is not the canonical self-link"
    result_status=1
  fi

  if [[ "$type" == "topic" ]] && ! zk_is_deprecated "$file"; then
    key_topic="$(zk_attr_value "$file" "key-topic" 2>/dev/null)"
    if [[ -z "${key_topic//[[:space:]]/}" || "$title" != "${key_topic} - ключевая тема" || "$description" != "$title" ]]; then
      print -r -- "TOPIC_METADATA${delimiter}active Topic metadata is not canonical"
      result_status=1
    fi
  fi

  return $result_status
}

# Совместимость со старыми документами. :type: остаётся каноническим источником.
zk_type_from_keywords() {
  local keywords="$1"

  if [[ "$keywords" == *note* && "$keywords" == *key-topic* ]]; then
    print -r -- "topic"
  elif [[ "$keywords" == *diary* ]]; then
    print -r -- "diary"
  elif [[ "$keywords" == *note* ]]; then
    print -r -- "note"
  elif [[ "$keywords" == *memo* ]]; then
    print -r -- "memo"
  elif [[ "$keywords" == *todo* ]]; then
    print -r -- "todo"
  else
    print -r -- "note"
  fi
}

zk_metadata() {
  local fname="$1"
  local title="$2"
  local keywords="$3"
  local type="${4:-$(zk_type_from_keywords "$keywords")}"
  local description="${5:-$title}"

  local current_date
  local author

  zk_validate_single_line "filename" "$fname" required || return 1
  zk_validate_single_line "title" "$title" required || return 1
  zk_validate_single_line "keywords" "$keywords" optional || return 1
  zk_validate_single_line "type" "$type" required || return 1
  zk_validate_single_line "description" "$description" required || return 1
  current_date="$(date +"%Y-%m-%d")" || return 1
  author="$(whoami)" || return 1
  zk_validate_single_line "date" "$current_date" required || return 1
  zk_validate_single_line "author" "$author" required || return 1

  print -r -- "= $title"
  print -r -- ":date: $current_date"
  print -r -- ":keywords: $keywords"
  print -r -- ":type: $type"
  print -r -- ":author: $author"
  print -r -- ":description: $description"
  print -r -- ":doclink: $(zk_link "$fname" "$description")"
  print -r -- ":docfilename: $fname"
}

zk_file_title() {
  local file="$1"

  awk '
    /^= / {
      sub(/^= /, "")
      print
      exit
    }
  ' "$file"
}

zk_link_description() {
  local file="$1"
  local description

  description="$(zk_attr_value "$file" "description")"

  if [[ -z "$description" ]]; then
    description="$(zk_file_title "$file")"
  fi

  if [[ -z "$description" ]]; then
    description="${file:t}"
  fi

  print -r -- "$description"
}

zk_has_link_to() {
  local file="$1"
  local target="$2"
  local found
  local candidate

  found="$(zk_extract_links "$file")" || return 1
  while IFS= read -r candidate; do
    [[ "$candidate" == "$target" ]] && return 0
  done <<< "$found"
  return 1
}

zk_remove_links_atomic() {
  emulate -L zsh

  local file="$1"
  shift
  local require_match=1
  if [[ "${1:-}" == "--allow-absent" ]]; then
    require_match=0
    shift
  fi
  local sep=$'\x1f'
  local serialized=""
  local target
  local tmp

  zk_header_is_mutable "$file" || {
    print -ru2 -- "ERROR cannot determine AsciiDoc header boundary: $file"
    return 1
  }

  for target in "$@"; do
    serialized+="${target}${sep}"
  done

  local stage_prefix="${ZK_LINK_STAGE_PREFIX:-.${file:t}.links}"
  tmp="$(mktemp "${file:h}/${stage_prefix}.XXXXXX")" || return 1
  if ! awk -v serialized_targets="$serialized" -v sep="$sep" -v require_match="$require_match" '
    BEGIN {
      target_count = split(serialized_targets, targets, sep)
      if (targets[target_count] == "") { delete targets[target_count]; target_count-- }
    }
    function trim(line) {
      sub(/^[[:space:]]+/, "", line); sub(/[[:space:]]+$/, "", line); return line
    }
    function delimiter(line, value) {
      value = trim(line)
      if (value ~ /^`{3,}/) return substr(value, 1, 3)
      if (value ~ /^-{4,}$/ || value ~ /^\.{4,}$/ || value ~ /^_{4,}$/ ||
          value ~ /^\*{4,}$/ || value ~ /^={4,}$/ || value ~ /^\+{4,}$/ || value ~ /^\/{4,}$/) return value
      return ""
    }
    {
      current = delimiter($0)
      if (in_block) {
        print
        if ((block == "```" && current == "```") || (block != "```" && trim($0) == block)) { in_block = 0; block = "" }
        next
      }
      if (current != "") { in_block = 1; block = current; print; next }

      line = $0; output = ""; changed = 0
      while (match(line, /link:[^[]+\.adoc\[/)) {
        start = RSTART
        prefix = substr(line, RSTART, RLENGTH)
        closing = 0
        escaped = 0
        for (j = RSTART + RLENGTH; j <= length(line); j++) {
          character = substr(line, j, 1)
          if (escaped) { escaped = 0; continue }
          if (character == "\\") { escaped = 1; continue }
          if (character == "]") { closing = j; break }
        }
        if (!closing) { parse_error = 1; break }
        macro = substr(line, start, closing - start + 1)
        selected_target = prefix
        sub(/^link:/, "", selected_target); sub(/\[$/, "", selected_target)
        selected = 0
        for (i = 1; i <= target_count; i++) if (selected_target == targets[i]) { selected = 1; removed[i] = 1 }
        output = output substr(line, 1, start - 1)
        if (!selected) output = output macro; else changed = 1
        line = substr(line, closing + 1)
      }
      output = output line
      if (changed && output ~ /^[*][[:space:]]*$/) next
      print output
    }
    END {
      if (in_block) exit 3
      if (parse_error) exit 4
      if (require_match) for (i = 1; i <= target_count; i++) if (!removed[i]) exit 2
    }
  ' "$file" > "$tmp"; then
    rm -f -- "$tmp"
    print -ru2 -- "ERROR link removal requires a valid supported AsciiDoc structure: $file"
    return 1
  fi

  if ! zk_replace_with_prepared_file "$file" "$tmp"; then
    if [[ "${ZK_LINK_CLEANUP_ON_FAILURE:-0}" == 1 ]]; then
      rm -f -- "$tmp"
      return 1
    fi
    print -ru2 -- "ERROR prepared link removal retained for recovery: $tmp"
    return 1
  fi
}

zk_file_mode() {
  local file="$1"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%Lp' "$file"
  else
    stat -c '%a' -- "$file"
  fi
}

zk_file_owner_group() {
  local file="$1"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%u:%g' "$file"
  else
    stat -c '%u:%g' -- "$file"
  fi
}

zk_file_identity() {
  local file="$1"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%d:%i' "$file"
  else
    stat -c '%d:%i' -- "$file"
  fi
}

zk_file_acl_state() {
  emulate -L zsh

  local file="$1"
  local listing
  local permissions

  if [[ "$(uname -s)" == "Darwin" ]]; then
    listing="$(ls -lde "$file" 2>/dev/null)" || {
      print -ru2 -- "ERROR cannot determine ACL state: $file"
      return 1
    }
  else
    listing="$(ls -ld -- "$file" 2>/dev/null)" || {
      print -ru2 -- "ERROR cannot determine ACL state: $file"
      return 1
    }
  fi

  permissions="${listing%%[[:space:]]*}"
  if [[ "$(uname -s)" == "Darwin" && "$listing" == *$'\n'* ]]; then
    print -r -- "present"
  elif [[ "$permissions" == *+* ]]; then
    print -r -- "present"
  else
    print -r -- "none"
  fi
}

zk_replace_with_prepared_file() {
  emulate -L zsh

  local file="$1"
  local prepared="$2"
  local mode
  local owner_group
  local prepared_owner_group
  local acl_state
  local prepared_acl_state

  [[ -f "$file" && ! -L "$file" ]] || {
    print -ru2 -- "ERROR replacement target is not a regular file: $file"
    return 1
  }

  [[ -f "$prepared" && ! -L "$prepared" ]] || {
    print -ru2 -- "ERROR prepared replacement is not a regular file: $prepared"
    return 1
  }

  mode="$(zk_file_mode "$file")" || {
    print -ru2 -- "ERROR cannot determine file mode: $file"
    return 1
  }
  owner_group="$(zk_file_owner_group "$file")" || {
    print -ru2 -- "ERROR cannot determine owner/group: $file"
    return 1
  }
  prepared_owner_group="$(zk_file_owner_group "$prepared")" || {
    print -ru2 -- "ERROR cannot determine owner/group: $prepared"
    return 1
  }
  acl_state="$(zk_file_acl_state "$file")" || return 1
  prepared_acl_state="$(zk_file_acl_state "$prepared")" || return 1

  if [[ "$acl_state" != "none" ]]; then
    print -ru2 -- "ERROR atomic replacement of ACL-bearing files is unsupported: $file"
    return 1
  fi

  if [[ "$prepared_acl_state" != "none" ]]; then
    print -ru2 -- "ERROR prepared replacement has an unexpected ACL: $prepared"
    return 1
  fi

  if [[ "$owner_group" != "$prepared_owner_group" ]]; then
    print -ru2 -- "ERROR atomic replacement cannot preserve owner/group: $file"
    return 1
  fi

  chmod "$mode" "$prepared" || return 1

  [[ "$(zk_file_mode "$prepared")" == "$mode" ]] || {
    print -ru2 -- "ERROR prepared replacement mode verification failed: $prepared"
    return 1
  }
  [[ "$(zk_file_owner_group "$prepared")" == "$owner_group" ]] || {
    print -ru2 -- "ERROR prepared replacement owner/group verification failed: $prepared"
    return 1
  }
  [[ "$(zk_file_acl_state "$prepared")" == "none" ]] || {
    print -ru2 -- "ERROR prepared replacement ACL verification failed: $prepared"
    return 1
  }

  mv -f -- "$prepared" "$file"
}

zk_replace_from_file_atomic() {
  emulate -L zsh

  local file="$1"
  local source="$2"
  local tmp

  tmp="$(mktemp "${file:h}/.${file:t}.tmp.XXXXXX")" || return 1
  if ! cat -- "$source" > "$tmp"; then
    rm -f -- "$tmp"
    return 1
  fi

  if ! zk_replace_with_prepared_file "$file" "$tmp"; then
    print -ru2 -- "ERROR prepared replacement retained for recovery: $tmp"
    return 1
  fi
}

zk_create_exclusive_from_stdin() {
  emulate -L zsh

  local target="$1"
  local parent="${target:h}"
  local basename="${target:t}"

  zmodload zsh/system || {
    print -ru2 -- "ERROR zsh/system is required for exclusive file creation"
    return 1
  }

  (
    local create_fd

    builtin cd -- "$parent" || return 1
    if ! sysopen -w -o creat,excl -u create_fd "$basename" 2>/dev/null; then
      if [[ -e "$basename" || -L "$basename" ]]; then
        print -ru2 -- "ERROR target already exists: $target"
        return 1
      fi

      # macOS system Zsh can reject a Unicode sysopen basename. Noclobber uses
      # the same exclusive-open contract and remains race-safe for this case.
      setopt local_options noclobber
      if ! : > "$basename" 2>/dev/null; then
        if [[ -e "$basename" || -L "$basename" ]]; then
          print -ru2 -- "ERROR target already exists: $target"
        else
          print -ru2 -- "ERROR cannot create target: $target"
        fi
        return 1
      fi

      if ! cat >! "$basename"; then
        rm -f -- "$basename"
        print -ru2 -- "ERROR cannot write target: $target"
        return 1
      fi
      return 0
    fi

    if ! cat >&$create_fd; then
      exec {create_fd}>&-
      rm -f -- "$basename"
      print -ru2 -- "ERROR cannot write target: $target"
      return 1
    fi

    exec {create_fd}>&-
  )
}

zk_create_exclusive_from_file() {
  emulate -L zsh

  local source="$1"
  local target="$2"

  [[ -f "$source" && ! -L "$source" ]] || {
    print -ru2 -- "ERROR exclusive-create source is not a regular file: $source"
    return 1
  }

  zk_create_exclusive_from_stdin "$target" < "$source"
}

zk_append_text_atomic() {
  emulate -L zsh

  local file="$1"
  shift
  local tmp

  [[ -f "$file" && ! -L "$file" ]] || {
    print -ru2 -- "ERROR append target is not a regular file: $file"
    return 1
  }

  tmp="$(mktemp "${file:h}/.${file:t}.tmp.XXXXXX")" || return 1
  if ! cat -- "$file" > "$tmp"; then
    rm -f -- "$tmp"
    return 1
  fi

  if ! print -rl -- "$@" >> "$tmp"; then
    rm -f -- "$tmp"
    return 1
  fi

  if ! zk_replace_with_prepared_file "$file" "$tmp"; then
    print -ru2 -- "ERROR prepared replacement retained for recovery: $tmp"
    return 1
  fi
}

zk_append_related_link() {
  local file="$1"
  local heading="$2"
  local label="$3"
  local link="$4"
  local entry
  local target
  local tmp

  target="${link#link:}"
  target="${target%%\[*}"

  if ! zk_extract_links "$file" > /dev/null; then
    print -ru2 -- "ERROR unsupported or unclosed opaque block: $file"
    return 1
  fi

  zk_has_link_to "$file" "$target" && return 0

  if [[ -n "$label" ]]; then
    entry="* $label: $link"
  else
    entry="* $link"
  fi

  if grep -qFx -- "$heading" "$file"; then
    tmp="$(mktemp "${file:h}/.${file:t}.related.XXXXXX")" || return 1

    if ! awk -v heading="$heading" -v entry="$entry" '
      !inserted && $0 == heading {
        in_section = 1
        print
        next
      }

      in_section {
        if (/^== /) {
          print entry
          print_pending_blanks()
          inserted = 1
          in_section = 0
          print
          next
        }

        if ($0 == "") {
          pending_blanks++
          next
        }

        print_pending_blanks()
        print
        next
      }

      {
        print
      }

      END {
        if (in_section && !inserted) {
          print entry
          print_pending_blanks()
        }
      }

      function print_pending_blanks() {
        while (pending_blanks > 0) {
          print ""
          pending_blanks--
        }
      }
    ' "$file" > "$tmp"; then
      rm -f "$tmp"
      return 1
    fi

    if ! zk_replace_with_prepared_file "$file" "$tmp"; then
      print -ru2 -- "ERROR prepared replacement retained for recovery: $tmp"
      return 1
    fi

    return 0
  fi

  zk_append_text_atomic "$file" "" "$heading" "" "$entry"
}
