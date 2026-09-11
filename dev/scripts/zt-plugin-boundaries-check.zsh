#!/bin/zsh

#------------------------------------------------------------------------------
# zt-plugin-boundaries-check.zsh
# Тип: Development Check
# Назначение: проверить направления зависимостей engine, objects и plugins
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset
repo_root="${0:A:h:h:h}"
ZK_SCRIPTS_ROOT="${ZK_SCRIPTS_ROOT:-${repo_root}/scripts}" \
  exec python3 "${0:A:h}/plugin_boundaries.py"
