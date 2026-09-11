#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-add.zsh
# Тип: Compatibility Entrypoint
# Назначение: совместимый запуск канонического workflow из workspace/
#------------------------------------------------------------------------------

script_dir="${0:A:h}"
exec "$script_dir/workspace/zt-workspace-add.zsh" "$@"
