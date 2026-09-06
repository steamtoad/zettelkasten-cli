#!/bin/zsh

#------------------------------------------------------------------------------
# zt-workspace-as-plugin.zsh
# Тип: Regression Test
# Назначение: проверить совместимость и границы workspace на временном хранилище
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset
repo="${0:A:h:h}"
exec python3 "$repo/tests/lib/plugin_contracts.py" workspace "$@"
