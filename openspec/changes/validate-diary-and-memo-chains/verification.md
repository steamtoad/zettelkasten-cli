# Verification

Дата: 2026-09-11. Все integration fixtures используют temporary `ZK_HOME`;
реальный Vault, commit, tag и push не затрагивались.

## PASS

- `tests/zt-validate-diary-and-memo-chains.zsh` — empty Vault, pointer на Note
  без mutation, reciprocal/equal-date Diary chain, reciprocity/cycle rejection,
  opaque Memo example, public `zt-continue` и permitted branches.
- Тот же suite с `TMPDIR` containing spaces and Unicode.
- `tests/zt-runtime-core.zsh` и `tests/zt-diary-as-plugin.zsh`.
- `tests/zt-fix-atomic-document-writes.zsh`; он завершился успешно, включая
  expected fault-path diagnostics.
- `dev/scripts/zt-plugin-boundaries-check.zsh` — 49 local dependencies.
- `openspec validate --all --strict` и
  `dev/scripts/zt-openspec-check.zsh` — 347 legacy IDs exactly once.
- `tests/zt-all.zsh` — full development suite passed; live routing intentionally
  reports its existing opt-in `SKIP` without `ZK_RUN_LIVE_ROUTING=1`.
- `zsh -n` для изменённых Zsh files и `git diff --check`.

## SKIP / environment limitations

- `shellcheck` установлен, но reports `SC1071` для каждого `#!/bin/zsh` file:
  эта локальная версия не supports Zsh, поэтому не является semantic check.
- macOS sandbox запрещает `nice(5)` in atomic-write fault fixture. Test handles
  that path and still exits successfully; warning не скрывает test result.
