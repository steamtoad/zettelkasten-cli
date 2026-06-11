#!/bin/zsh

#------------------------------------------------------------------------------
# zt-diary.zsh
# Тип: Diary
# Назначение: создание дневниковой записи
#------------------------------------------------------------------------------

emulate -L zsh

script_dir="${0:A:h}"

source "$script_dir/lib/paths.zsh"
source "$script_dir/lib/uuid.zsh"
source "$script_dir/lib/asciidoc.zsh"

zk_cd
zk_ensure_dirs

last=""
[[ -f ".last-diary" ]] && last="$(< ".last-diary")"

fname="$(zk_new_adoc_filename)"
title="Diary - $(date +"%d-%m-%Y")"
link="$(zk_link "$fname" "$title")"
today_link="link:../${fname}[$title]"
next_link="link:${fname}[Следующая запись]"

print -r -- "* $(date +"%H.%M") - $today_link" >> "$(zk_today_file)"

{
  zk_metadata "$fname" "$title" "diary" "diary"

  if [[ -n "$last" && -f "$last" ]]; then
    print -r -- ""
    print -r -- "link:${last}[Предыдущая запись]"
  fi

  print -r -- ""
} > "$fname"

if [[ -n "$last" && -f "$last" ]]; then
  print -r -- "| $next_link" >> "$last"
fi

print -r -- "$fname" > ".last-diary"

vim "$fname"

print -r -- "$link"
