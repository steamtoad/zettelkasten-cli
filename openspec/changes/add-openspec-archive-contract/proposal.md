## Why

Zettelkasten-CLI фиксирует authority canonical OpenSpec baseline, но не имеет полного normative contract для readiness, synchronization и preservation при архивировании Change. Это допускает преждевременный archive и ошибочное использование historical deltas как текущих требований.

## What Changes

- Разрешить archival только после завершения implementation, verification и specification validation.
- Требовать синхронизации applicable deltas в canonical `openspec/specs/` до завершения archival.
- Сохранять полный Change в `openspec/changes/archive/`.
- Классифицировать archived deltas только как historical records.
- Подтвердить `openspec/specs/` source of truth текущих требований.

## Capabilities

### New Capabilities

Нет.

### Modified Capabilities

- `spec-governance`: добавить archival lifecycle и current-source-of-truth rules.

## Impact

- Затронуты OpenSpec development workflow, archive checks, legacy traceability после implementation и regression coverage.
- Runtime CLI и пользовательские Vault data не изменяются.
- Existing archive сохраняется как historical record.
