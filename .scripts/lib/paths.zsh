#------------------------------------------------------------------------------
# paths.zsh
# Тип: Library
# Назначение: пути Zettelkasten
#------------------------------------------------------------------------------

zk_home() {
  print -r -- "${ZK_HOME:-$HOME/zettelkasten}"
}

zk_cd() {
  cd "$(zk_home)" || exit 1
}

zk_scripts_dir() {
  print -r -- "$(zk_home)/.scripts"
}

zk_lib_dir() {
  print -r -- "$(zk_home)/.scripts/lib"
}

zk_today_file() {
  print -r -- "$(zk_home)/all-todays/$(date +"%Y-%m-%d").adoc"
}

zk_ensure_dirs() {
  local today_file

  mkdir -p "$(zk_home)/all-todays"

  today_file="$(zk_today_file)"

  if [[ ! -f "$today_file" ]]; then
    print -r -- "= Заметки за $(date +"%d-%m-%Y")" > "$today_file"
    print -r -- "" >> "$today_file"
  fi
}
