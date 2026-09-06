#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-remove.zsh
# Тип: Compatibility Entrypoint
# Назначение: совместимый запуск канонического workflow из workspace/
#------------------------------------------------------------------------------

script_dir="${0:A:h}"
exec "$script_dir/workspace/zt-workspace-remove.zsh" "$@"
