#!/bin/zsh

#------------------------------------------------------------------------------
# zt-plugin-edge-cases.zsh
# Тип: Regression Test
# Назначение: проверить пограничные случаи выполненных plugin refactors
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset
exec python3 -B "${0:A:h}/lib/plugin_edge_cases.py"
