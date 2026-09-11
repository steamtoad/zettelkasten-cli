#!/bin/zsh

#------------------------------------------------------------------------------
# zt-strengthen-document-integrity-checks.zsh
# Тип: Regression Test
# Назначение: проверить строгую схему документов, UUID v1 и input preflight
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset null_glob

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-integrity.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

export ZK_HOME="$fixture/vault"
mkdir -p "$ZK_HOME/notes" "$ZK_HOME/all-todays" "$ZK_HOME/workspaces" "$ZK_HOME/.scripts"

source "$repo/scripts/lib/asciidoc.zsh"
source "$repo/scripts/lib/uuid.zsh"

write_document() {
  local id="$1"
  local type="$2"
  local title="$3"
  local date_value="${4:-2026-09-11}"
  local extra="${5:-}"
  local file="$ZK_HOME/notes/${id}.adoc"

  {
    print -r -- "= $title"
    print -r -- ":date: $date_value"
    print -r -- ":keywords: $type"
    print -r -- ":type: $type"
    print -r -- ":author: test"
    print -r -- ":description: $title"
    print -r -- ":doclink: $(zk_link "${id}.adoc" "$title")"
    print -r -- ":docfilename: ${id}.adoc"
    [[ -z "$extra" ]] || print -r -- "$extra"
    print -r -- ""
    print -r -- "body"
  } > "$file"
}

diary_id="10000000-0000-1000-8000-000000000001"
write_document "$diary_id" diary "Diary fixture"
print -r -- "${diary_id}.adoc" > "$ZK_HOME/.last-diary"

empty_id="10000000-0000-1000-8000-000000000002"
: > "$ZK_HOME/notes/${empty_id}.adoc"
duplicate_id="10000000-0000-1000-8000-000000000003"
write_document "$duplicate_id" note "Duplicate type" "2026-09-11" ":type: memo"
bad_date_id="10000000-0000-1000-8000-000000000004"
write_document "$bad_date_id" note "Bad date" "2026-02-30"
generated_type_id="10000000-0000-1000-8000-000000000005"
write_document "$generated_type_id" index "Generated type"
topic_id="10000000-0000-1000-8000-000000000006"
write_document "$topic_id" topic "Topic without key"
deprecated_id="10000000-0000-1000-8000-000000000007"
write_document "$deprecated_id" note "Deprecated incomplete" "2026-09-11" ":deprecated:"
sed -i.bak '/^:docfilename:/d' "$ZK_HOME/notes/${deprecated_id}.adoc"
rm -f -- "$ZK_HOME/notes/${deprecated_id}.adoc.bak"
v4_id="10000000-0000-4000-8000-000000000008"
write_document "$v4_id" note "UUID v4"

before_hashes="$(find "$ZK_HOME/notes" -type f -name '*.adoc' -exec shasum -a 256 {} \; | sort)"
if "$repo/scripts/zt-check.zsh" > "$fixture/check.out" 2> "$fixture/check.err"; then
  print -ru2 -- "FAIL: zt-check accepted invalid document fixtures"
  exit 1
fi
after_hashes="$(find "$ZK_HOME/notes" -type f -name '*.adoc' -exec shasum -a 256 {} \; | sort)"
[[ "$before_hashes" == "$after_hashes" ]] || { print -ru2 -- "FAIL: zt-check mutated documents"; exit 1; }

for code in EMPTY_DOCUMENT DUPLICATE_ATTRIBUTE INVALID_DATE INVALID_TYPE INVALID_UUID TOPIC_METADATA MISSING_ATTRIBUTE; do
  rg -q "ERROR ${code} notes/" "$fixture/check.out" || {
    print -ru2 -- "FAIL: missing integrity diagnostic $code"
    exit 1
  }
done

for invalid_uuid in \
  '10000000-0000-4000-8000-000000000001' \
  'not-a-uuid' \
  $'10000000-0000-1000-8000-000000000001\nextra' \
  '10000000-0000-1000-7000-000000000001'; do
  zk_uuid() { print -r -- "$invalid_uuid" }
  if zk_new_adoc_filename > /dev/null 2> "$fixture/uuid.err"; then
    print -ru2 -- "FAIL: invalid UUID provider output was accepted"
    exit 1
  fi
done

zk_uuid() { print -r -- 'ABCDEF00-0000-1000-B000-000000000001' }
[[ "$(zk_new_adoc_filename)" == 'ABCDEF00-0000-1000-B000-000000000001.adoc' ]] || {
  print -ru2 -- "FAIL: valid uppercase UUID v1 was not preserved"
  exit 1
}

before_count=${#ZK_HOME/notes/*.adoc}
if "$repo/scripts/objects/note-create.zsh" $'Title\n:deprecated:' > /dev/null 2> "$fixture/title.err"; then
  print -ru2 -- "FAIL: multiline title was accepted"
  exit 1
fi
(( ${#ZK_HOME/notes/*.adoc} == before_count )) || { print -ru2 -- "FAIL: rejected title created a document"; exit 1; }

if "$repo/scripts/objects/topic-create.zsh" "Invalid Topic" "   " > /dev/null 2> "$fixture/topic.err"; then
  print -ru2 -- "FAIL: blank key-topic was accepted"
  exit 1
fi
(( ${#ZK_HOME/notes/*.adoc} == before_count )) || { print -ru2 -- "FAIL: rejected key-topic created a document"; exit 1; }

special_title='Кириллица "quote" \ [bracket]'
special_file="$("$repo/scripts/objects/note-create.zsh" "$special_title")"
rg -qF ":doclink: $(zk_link "$special_file" "$special_title")" "$ZK_HOME/notes/$special_file" || {
  print -ru2 -- "FAIL: special link text was not escaped canonically"
  exit 1
}

if command -v asciidoctor >/dev/null 2>&1; then
  asciidoctor --failure-level WARN -o "$fixture/render.html" "$ZK_HOME/notes/$special_file"
else
  print -r -- "SKIP: asciidoctor is not installed; constructor byte assertions passed"
fi

print -r -- "PASS: strengthened document integrity checks"
