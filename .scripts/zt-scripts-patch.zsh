#!/bin/zsh

#------------------------------------------------------------------------------
# zt-scripts-patch.zsh
# Тип: Maintenance
# Назначение: исправление завершающего LF во всех shell-скриптах CLI
#------------------------------------------------------------------------------

emulate -L zsh
setopt extended_glob null_glob pipe_fail

script_dir="${0:A:h}"
mode="fix"
errors=0

if [[ "${1:-}" == "--check" ]]; then
  mode="check"
  shift
fi

(( $# == 0 )) || {
  print -ru2 -- "Usage: ${0:t} [--check]"
  exit 2
}

for f in "$script_dir"/**/*.zsh(N); do
  [[ -f "$f" ]] || continue

  relative="${f#$script_dir/}"

  if [[ ! -s "$f" ]]; then
    print -ru2 -- "empty: $relative"
    (( errors++ ))
    continue
  fi

  last_byte="$(tail -c 1 "$f" | od -An -tu1 | tr -d '[:space:]')" || {
    print -ru2 -- "ERROR cannot inspect: $relative"
    (( errors++ ))
    continue
  }

  if [[ "$last_byte" == "10" ]]; then
    print -r -- "ok: $relative"
  elif [[ "$mode" == "check" ]]; then
    print -ru2 -- "missing LF: $relative"
    (( errors++ ))
  elif print -rn -- $'\n' >> "$f"; then
    print -r -- "patched: $relative"
  else
    print -ru2 -- "ERROR cannot patch: $relative"
    (( errors++ ))
  fi
done

(( errors == 0 ))
