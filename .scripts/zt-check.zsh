#!/bin/zsh

#------------------------------------------------------------------------------
# zt-check.zsh
# Тип: System Check
# Назначение: проверка целостности Zettelkasten без исправлений
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/lib/asciidoc.zsh"

zk="${ZK_HOME:-$HOME/zettelkasten}"
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
  awk '
    /^----[[:space:]]*$/ { in_adoc_block = !in_adoc_block; next }
    /^```/ { in_markdown_block = !in_markdown_block; next }

    in_adoc_block || in_markdown_block { next }
    /^:doclink:/ { next }

    {
      line = $0
      while (match(line, /link:[^[]+\.adoc\[/)) {
        link = substr(line, RSTART + 5, RLENGTH - 6)
        print link
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$1"
}

target_exists_from_root() {
  local target="$1"

  target="${target#./}"

  if [[ "$target" == ../* ]]; then
    target="${target#../}"
  fi

  [[ -f "$zk/$target" ]]
}

extract_diary_chain_link() {
  local file="$1"
  local label="$2"

  awk -v label="$label" '
    /^----[[:space:]]*$/ { in_adoc_block = !in_adoc_block; next }
    /^```/ { in_markdown_block = !in_markdown_block; next }

    in_adoc_block || in_markdown_block { next }

    index($0, label) {
      if (match($0, /link:[^[]+\.adoc\[/)) {
        print substr($0, RSTART + 5, RLENGTH - 6)
        exit
      }
    }
  ' "$file"
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
[[ -d "$zk/.scripts" ]] && ok ".scripts" || err ".scripts not found"
[[ -f "$zk/.last-diary" ]] && ok ".last-diary" || err ".last-diary not found"

print -r -- ""
print -r -- "== AsciiDoc metadata"

for file in "$zk"/*.adoc; do
  base="${file:t}"

  is_metadata_exempt_file "$base" && continue

  grep -q '^= .\+' "$file" || err "$base missing title"

  for attr in date keywords type author description doclink docfilename; do
    has_attr "$file" "$attr" || err "$base missing :$attr:"
  done

  if has_attr "$file" keywords && has_attr "$file" type; then
    keywords="$(attr_value "$file" keywords)"
    note_type="$(attr_value "$file" type)"

    known_type "$note_type" || err "$base invalid :type: unknown value '$note_type'"

    if [[ -n "$note_type" ]] && ! keyword_has "$keywords" "$note_type"; then
      warn "$base recommendation: add :type: value '$note_type' to :keywords:"
    fi
  fi

  if has_attr "$file" docfilename; then
    docfilename="$(attr_value "$file" docfilename)"
    [[ "$docfilename" == "$base" ]] || err "$base invalid :docfilename:"
  fi

  if has_attr "$file" doclink; then
    doclink="$(attr_value "$file" doclink)"
    [[ "$doclink" == "link:${base}"\[* ]] || err "$base invalid :doclink:"
  fi
done

print -r -- ""
print -r -- "== Note links"

for file in "$zk"/*.adoc; do
  base="${file:t}"

  extract_links "$file" | while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    is_placeholder_link "$target" && continue

    target="${target#link:}"

    target_exists_from_root "$target" || broken_link "$base" "$target"
  done
done

print -r -- ""
print -r -- "== all-todays links"

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

  extract_links "$file" | while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    is_placeholder_link "$target" && continue

    target="${target#link:}"

    target_exists_from_root "$target" || broken_diary_link "$rel" "${target:t}"
  done
done

print -r -- ""
print -r -- "== .last-diary"

if [[ -f "$zk/.last-diary" ]]; then
  last="$(< "$zk/.last-diary")"

  if [[ -z "$last" ]]; then
    err ".last-diary is empty"
  elif [[ ! -f "$zk/$last" ]]; then
    err ".last-diary points to missing file"
  else
    ok ".last-diary -> $last"
  fi
fi

print -r -- ""
print -r -- "== Diary chain"

for file in "$zk"/*.adoc; do
  base="${file:t}"

  prev="$(extract_diary_chain_link "$file" "Предыдущая запись")"
  next="$(extract_diary_chain_link "$file" "Следующая запись")"

  if [[ -n "$prev" ]]; then
    is_placeholder_link "$prev" || target_exists_from_root "$prev" || broken_diary_chain "$base" "$prev"
  fi

  if [[ -n "$next" ]]; then
    is_placeholder_link "$next" || target_exists_from_root "$next" || broken_diary_chain "$base" "$next"
  fi
done

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
