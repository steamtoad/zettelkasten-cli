#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-create.zsh
# Тип: Compatibility Entrypoint
# Назначение: совместимый запуск канонического workflow из workspace/
#------------------------------------------------------------------------------

script_dir="${0:A:h}"
exec "$script_dir/workspace/zt-workspace-create.zsh" "$@"
