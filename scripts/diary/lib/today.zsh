#!/bin/zsh

#------------------------------------------------------------------------------
# today.zsh
# Тип: Diary Library
# Назначение: регистрация Diary в all-todays с общим форматом журнала
#------------------------------------------------------------------------------

dp_today_dir() {
  print -r -- "$(zk_home)/all-todays"
}

dp_today_file() {
  print -r -- "$(dp_today_dir)/$(date +"%Y-%m-%d").adoc"
}

dp_ensure_today() {
  local today_file

  mkdir -p "$(dp_today_dir)" || return 1
  today_file="$(dp_today_file)"

  if [[ ! -f "$today_file" ]]; then
    {
      print -r -- "= Заметки за $(date +"%d-%m-%Y")"
      print -r -- ""
    } > "$today_file" || return 1
  fi
}

dp_today_link() {
  local fname="$1"
  local title="$2"

  zk_link "../notes/${fname}" "$title"
}

dp_today_entry() {
  local fname="$1"
  local title="$2"

  print -r -- "* $(date +"%H.%M") - $(dp_today_link "$fname" "$title")"
}

dp_today_append() {
  local fname="$1"
  local title="$2"
  local target_path

  [[ -n "$fname" && "$fname" != */* ]] || {
    print -ru2 -- "ERROR invalid document basename for all-todays: $fname"
    return 1
  }

  target_path="$(zk_note_path "$fname")"
  [[ -f "$target_path" ]] || {
    print -ru2 -- "ERROR all-todays target not found: $target_path"
    return 1
  }

  dp_ensure_today || return 1
  dp_today_entry "$fname" "$title" >> "$(dp_today_file)"
}
