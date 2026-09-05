## Context

Canonical requirements находятся в `openspec/specs/`, active changes описывают proposed deltas, а archive должен сохранять историю. Между этими состояниями пока отсутствует полный проверяемый lifecycle contract.

## Goals / Non-Goals

**Goals:**

- определить archive readiness и synchronization gates;
- сохранить полный Change;
- исключить использование archive как current baseline.

**Non-Goals:**

- архивировать существующий Change;
- менять runtime Zettelkasten;
- переписывать существующие historical archives.

## Decisions

### 1. Archive workflow является staged

Проверить implementation/tasks и verification evidence, синхронизировать deltas в canonical specs, провалидировать обновлённый baseline и только затем завершить перенос полного Change в archive.

### 2. Current authority остаётся единственной

`openspec/specs/` описывает текущее состояние. Active и archived artifacts объясняют change history, но не включаются в current baseline resolution.

### 3. Archive сохраняет все applicable artifacts

Proposal, design, tasks и delta specs являются одной historical записью и проверяются перед завершением operation.

## Risks / Trade-offs

- **[CLI выполняет sync и move одной командой]** → считать это staged transaction и признавать archive успешным только после post-sync validation и artifact verification.
- **[Historical delta расходится с новым baseline]** → сохранять расхождение как историю, не использовать archive для current requirements.

## Migration Plan

Новые gates применяются к будущим archival operations. Existing archive не переписывается.
