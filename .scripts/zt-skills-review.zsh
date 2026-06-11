#!/bin/zsh

#------------------------------------------------------------------------------
# zt-skills-review.zsh
# Тип: Maintenance
# Назначение: вывод всех репозиторных навыков Zettelkasten для ревизии
#------------------------------------------------------------------------------

emulate -L zsh
setopt null_glob

zk="${ZK_HOME:-$HOME/zettelkasten}"
skills_dir="$zk/.agent-skills"

[[ -d "$skills_dir" ]] || {
  print -ru2 -- "ERROR .agent-skills not found: $skills_dir"
  exit 1
}

cd "$skills_dir" || exit 1

for f in ./zt-*.adoc; do
  [[ -f "$f" ]] || continue

  print -r -- ""
  print -r -- "=============================================================================="
  print -r -- "FILE: ${f#./}"
  print -r -- "=============================================================================="
  cat "$f"
done

exit 0
