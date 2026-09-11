#!/bin/zsh

#------------------------------------------------------------------------------
# zt-unify-asciidoc-metadata-and-links.zsh
# Тип: Regression Test
# Назначение: проверить единый header/link parser и безопасное удаление связей
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-asciidoc-parser.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM

source "$repo/scripts/lib/asciidoc.zsh"

document="$fixture/document.adoc"
print -rl -- \
  '= Parser fixture' \
  ':type: note' \
  ':description: Parser fixture' \
  '   ' \
  ':deprecated:' \
  '----' \
  'link:target.adoc[Example]' \
  '----' \
  '== Связи' \
  '' > "$document"

[[ "$(zk_attr_value "$document" type)" == note ]] || { print -ru2 -- "FAIL: header type not parsed"; exit 1; }
zk_is_deprecated "$document" && { print -ru2 -- "FAIL: body pseudo-attribute changed metadata"; exit 1; }

zk_append_related_link "$document" '== Связи' 'Topic' 'link:target.adoc[Real]'
(( $(zk_extract_links "$document" | rg -c '^target\.adoc$') == 1 )) || {
  print -ru2 -- "FAIL: example link blocked or duplicated the working link"
  exit 1
}
rg -qF 'link:target.adoc[Example]' "$document" || { print -ru2 -- "FAIL: opaque example changed"; exit 1; }
first_hash="$(shasum -a 256 "$document" | awk '{ print $1 }')"
zk_append_related_link "$document" '== Связи' 'Topic' 'link:target.adoc[Real]'
[[ "$(shasum -a 256 "$document" | awk '{ print $1 }')" == "$first_hash" ]] || {
  print -ru2 -- "FAIL: repeated link append was not idempotent"
  exit 1
}

mixed="$fixture/mixed.adoc"
print -rl -- \
  '= Mixed links' \
  ':type: note' \
  '' \
  '* context link:a.adoc[A] and link:b.adoc[B] keep' \
  '* link:a.adoc[A]' \
  '....' \
  '* link:a.adoc[Example]' \
  '....' > "$mixed"
chmod 640 "$mixed"
zk_remove_links_atomic "$mixed" 'a.adoc'
rg -qF '* context  and link:b.adoc[B] keep' "$mixed" || { print -ru2 -- "FAIL: mixed author text was not preserved"; exit 1; }
rg -qF '* link:a.adoc[Example]' "$mixed" || { print -ru2 -- "FAIL: opaque link was modified"; exit 1; }
! rg -qFx '* link:a.adoc[A]' "$mixed" || { print -ru2 -- "FAIL: managed link line was retained"; exit 1; }
[[ "$(zk_file_mode "$mixed")" == 640 ]] || { print -ru2 -- "FAIL: link removal changed file mode"; exit 1; }

escaped="$fixture/escaped.adoc"
print -rl -- '= Escaped link' ':type: note' '' "* $(zk_link 'a.adoc' 'A ] bracket') and link:b.adoc[B]" > "$escaped"
zk_remove_links_atomic "$escaped" 'a.adoc'
rg -qF '*  and link:b.adoc[B]' "$escaped" || { print -ru2 -- "FAIL: escaped link description corrupted removal"; exit 1; }

broken="$fixture/broken.adoc"
print -rl -- '= Broken block' ':type: note' '' '----' 'link:a.adoc[Example]' > "$broken"
broken_hash="$(shasum -a 256 "$broken" | awk '{ print $1 }')"
if zk_remove_links_atomic "$broken" 'a.adoc' > /dev/null 2> "$fixture/broken.err"; then
  print -ru2 -- "FAIL: mutation accepted an unclosed opaque block"
  exit 1
fi
[[ "$(shasum -a 256 "$broken" | awk '{ print $1 }')" == "$broken_hash" ]] || {
  print -ru2 -- "FAIL: rejected mutation changed the document"
  exit 1
}

ambiguous="$fixture/ambiguous.adoc"
print -rl -- '= Ambiguous header' ':type: note' 'body without boundary link:a.adoc[A]' > "$ambiguous"
ambiguous_hash="$(shasum -a 256 "$ambiguous" | awk '{ print $1 }')"
if zk_remove_links_atomic "$ambiguous" 'a.adoc' > /dev/null 2> "$fixture/ambiguous.err"; then
  print -ru2 -- "FAIL: mutation accepted an ambiguous header boundary"
  exit 1
fi
[[ "$(shasum -a 256 "$ambiguous" | awk '{ print $1 }')" == "$ambiguous_hash" ]] || {
  print -ru2 -- "FAIL: rejected header mutation changed the document"
  exit 1
}

export ZK_HOME="$fixture/vault"
mkdir -p "$ZK_HOME/notes"
typeset -a constructors=(note memo todo diary)
for type in "${constructors[@]}"; do
  created="$("$repo/scripts/objects/${type}-create.zsh" "Parity $type")"
  [[ "$(zk_attr_value "$ZK_HOME/notes/$created" type)" == "$type" ]] || { print -ru2 -- "FAIL: $type constructor parity"; exit 1; }
done
topic="$("$repo/scripts/objects/topic-create.zsh" 'parity - ключевая тема' parity)"
[[ "$(zk_attr_value "$ZK_HOME/notes/$topic" type)" == topic ]] || { print -ru2 -- "FAIL: topic constructor parity"; exit 1; }

if rg -n '(^|[[:space:]])source .*\/(objects|zettelkasten|diary|inbox|workspace)\/' "$repo/scripts/lib"; then
  print -ru2 -- "FAIL: neutral lib has a reverse dependency"
  exit 1
fi

print -r -- "PASS: unified AsciiDoc metadata and links"
