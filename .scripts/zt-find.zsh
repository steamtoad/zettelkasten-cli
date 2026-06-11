#!/bin/zsh

#------------------------------------------------------------------------------
# zt-find.zsh
# Тип: Search
# Назначение: подборка заметок по ключевому слову
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

script_dir="${0:A:h}"
source "$script_dir/lib/asciidoc.zsh"

read -r "?Введите ключевое слово для поиска: " key

[[ -z "$key" ]] && exit 1

zk="${ZK_HOME:-$HOME/zettelkasten}"

cd "$zk" || exit 1

print -r -- ""
print -r -- ""
print -r -- "= Подборка заметок по ключевому слову $key от $(date +"%d-%m-%Y")"
print -r -- ":date: $(date +"%Y-%m-%d")"
print -r -- ":keywords: $key, index"
print -r -- ":type: index"
print -r -- ":description: Подборка заметок по ключевому слову $key от $(date +"%d-%m-%Y")"
print -r -- ""
print -r -- "== Ссылки на $key"
print -r -- ""

for file in ./*.adoc; do
  zk_is_deprecated "$file" && continue
  grep -qi -- "$key" "$file" || continue

  fname="${file#./}"
  description="$(zk_attr_value "$file" "description")"

  [[ -n "$description" ]] && print -r -- "* link:${fname}[$description]"
done

print -r -- ""
