#!/bin/zsh

#------------------------------------------------------------------------------
# zt-plugin-boundaries-check.zsh
# Тип: Development Check
# Назначение: проверить направления зависимостей engine, objects и plugins
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset
exec python3 "${0:A:h}/plugin_boundaries.py"
