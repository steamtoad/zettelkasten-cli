#!/bin/zsh

#------------------------------------------------------------------------------
# asciidoc.zsh
# Тип: Library
# Назначение: нейтральные операции над AsciiDoc-документами и ссылками
#------------------------------------------------------------------------------

zk_link() {
  local fname="$1"
  local title="$2"

  print -r -- "link:${fname}[$title]"
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

  print -r -- "= $title"
  print -r -- ":date: $(date +"%Y-%m-%d")"
  print -r -- ":keywords: $keywords"
  print -r -- ":type: $type"
  print -r -- ":author: $(whoami)"
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

  grep -qF -- "link:${target}[" "$file"
}

zk_file_mode() {
  local file="$1"

  if [[ "$(uname -s)" == "Darwin" ]]; then
    stat -f '%Lp' "$file"
  else
    stat -c '%a' -- "$file"
  fi
}

zk_replace_with_prepared_file() {
  emulate -L zsh

  local file="$1"
  local prepared="$2"
  local mode

  [[ -f "$file" && ! -L "$file" ]] || {
    print -ru2 -- "ERROR replacement target is not a regular file: $file"
    return 1
  }

  [[ -f "$prepared" && ! -L "$prepared" ]] || {
    print -ru2 -- "ERROR prepared replacement is not a regular file: $prepared"
    return 1
  }

  mode="$(zk_file_mode "$file")" || return 1
  chmod "$mode" "$prepared" || return 1
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
