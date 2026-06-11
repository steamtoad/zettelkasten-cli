#!/bin/zsh

#------------------------------------------------------------------------------
# zt-keytopic.zsh
# Тип: KeyTopic
# Назначение: создание ключевой темы
#------------------------------------------------------------------------------

emulate -L zsh

script_dir="${0:A:h}"

source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/uuid.zsh"
source "$script_dir/lib/asciidoc.zsh"

read -r "?Введите название для новой ключевой темы: " key

[[ -z "$key" ]] && exit 1

zk_cd
zk_ensure_dirs

fname="$(zk_new_adoc_filename)"
title="$key - ключевая тема"
link="$(zk_link "$fname" "$title")"

zk_today_entry "$fname" "$title" >> "$(zk_today_file)"

{
  zk_metadata "$fname" "$title" "topic" "topic"
  print -r -- ":key-topic: $key"
  print -r -- ""
  print -r -- ""
} > "$fname"

vim "$fname"

print -r -- "$link"
