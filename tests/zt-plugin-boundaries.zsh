#!/bin/zsh

#------------------------------------------------------------------------------
# zt-plugin-boundaries.zsh
# Тип: Regression Test
# Назначение: доказать обнаружение запрещённых межслойных зависимостей
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset
repo="${0:A:h:h}"
python3 - "$repo" <<'PY'
import importlib.util
from pathlib import Path
import shutil
import sys
import tempfile
sys.dont_write_bytecode = True
repo = Path(sys.argv[1])
spec = importlib.util.spec_from_file_location('boundaries', repo / 'scripts/dev/plugin_boundaries.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
with tempfile.TemporaryDirectory(prefix='zt-boundaries-') as tmp:
    root = Path(tmp).resolve() / 'scripts'
    shutil.copytree(repo / 'scripts', root)
    assert not module.check(root)[1]
    for owner, allowed in module.ALLOWED.items():
        for target in module.ALLOWED:
            if target in allowed:
                continue
            dependency = next((root / target).rglob('*.zsh'))
            for command in ('source', '.', 'exec', ''):
                probe = root / owner / 'boundary-probe.zsh'
                probe.write_text(f'#!/bin/zsh\n{command} "{dependency}"\n')
                errors = module.check(root)[1]
                assert any(f'{owner} -> {target}' in error for error in errors), errors
                probe.unlink()
    probe = root / 'diary/boundary-probe.zsh'
    probe.write_text('source "$unknown/computed.zsh"\n')
    assert any('unresolved dependency' in e for e in module.check(root)[1])
    probe.write_text('# source "../zettelkasten/zt-note.zsh"\nprint -r -- "source is documentation"\n')
    assert not module.check(root)[1]
print('PASS: plugin boundary positive and forbidden-direction fixtures')
PY
