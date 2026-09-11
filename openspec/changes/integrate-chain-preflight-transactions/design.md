## Context

Мотивация и границы описаны в `proposal.md`. Нижний core safety слой уже предоставляет atomic single-file writer, строгий document preflight и единый AsciiDoc parser. Следующие active changes имеют отдельных владельцев требований и tests, но пока не реализованы и не определяют общий handoff:

1. `validate-diary-and-memo-chains` — корректность Diary/Memo graph и state;
2. `standardize-cli-preflight-and-selection` — dependencies, selection identity и path/cancel semantics;
3. `add-recoverable-workflow-transactions` — manifest, staging, locking, apply и recovery.

Интеграция затрагивает несколько plugins и shared primitives. Она должна сохранить направление зависимостей: `lib` не знает plugin policy, а sibling plugins не source друг друга.

## Goals / Non-Goals

**Goals:**

- задать один phase model для всех многофайловых writers;
- сделать результаты chain/selection preflight входом transaction plan, а не transient terminal text;
- обеспечить deterministic stale-state, failure и recovery semantics;
- доказать композицию трёх changes отдельным executable integration suite.

**Non-Goals:**

- переносить plugin policy в neutral library;
- создавать второй chain validator, selector или transaction engine;
- обещать process-crash/power-loss durability сверх фактически проверенного filesystem contract;
- автоматически чинить существующий Vault или применять migration.

## Decisions

### 1. Переход выполняется слоями, а не одним широким rewrite

Порядок integration readiness:

```text
core safety accepted
        ↓
validate-diary-and-memo-chains
        ↓
standardize-cli-preflight-and-selection
        ↓
add-recoverable-workflow-transactions
        ↓
cross-change integration gate
```

Перед началом каждого слоя заново проверяются baseline, code, tasks и evidence предыдущего. Если предыдущий change не принят, следующий слой может выполнять только независимый read-only/fixture scope и помечает mutation integration `BLOCKED`.

Альтернатива — реализовать все три active changes одним patch — отклонена: она смешивает владельцев stable IDs, затрудняет rollback и делает regression attribution неоднозначным.

### 2. Handoff является структурированной immutable записью

Shared neutral representation должна содержать как минимум:

- operation/plan identity;
- selected basenames и document types;
- fingerprints прочитанных documents и state;
- expected-absent targets;
- chain assertions, сформированные plugin policy;
- полный ordered write set;
- required dependencies и их preflight result;
- planned postflight checks.

Plugin формирует domain assertions, transaction engine сохраняет и проверяет их opaque structured values. Neutral layer не разбирает Diary/Memo policy.

Альтернатива — повторно угадывать inputs из stdout/transcript перед apply — отклонена как недетерминированная и неспособная надёжно различать stale selection и stale chain.

### 3. Revalidation выполняется перед первой и каждой релевантной заменой

Один lock не защищает от внешнего editor/process, который его не соблюдает. Поэтому transaction engine проверяет source fingerprint непосредственно перед затрагивающей его заменой. Изменение input переводит plan в `STATE_CONFLICT`; recovery восстанавливает только файл, identity которого всё ещё соответствует ожидаемому transaction state.

Альтернатива — доверять только preflight snapshot — отклонена из-за TOCTOU между выбором, staging и apply.

### 4. Error record хранит primary failure и recovery outcome раздельно

Основная ошибка не заменяется результатом cleanup/rollback. Итог содержит primary category, phase, affected paths, recovery status и backup location, если оно существует. CLI может сериализовать запись в текущую human-readable форму, но tests проверяют обе части результата.

Альтернатива — возвращать последнюю ошибку shell pipeline — отклонена, поскольку она скрывает точку отказа и может ложно сообщить rollback success.

### 5. Integration suite использует public entrypoints и fault injection

Focused suites остаются у трёх owner changes. Новый `tests/zt-integrate-chain-preflight-transactions.zsh` использует временный `ZK_HOME`, public `scripts/zt-*.zsh`, управляемые fake dependencies и deterministic fault hooks. Он проверяет общий phase order и bytes/hashes/modes вне scope до и после сценариев.

Прямые unit calls допустимы только как дополнительная локализация дефекта; они не заменяют public-entrypoint integration evidence.

## Dependency and Ownership Matrix

| Область | Owner change | Integration использует |
|---|---|---|
| Document/UUID/schema preflight | `strengthen-document-integrity-checks` | validated document facts |
| AsciiDoc metadata/links | `unify-asciidoc-metadata-and-links` | canonical parser/serializer |
| Diary/Memo chain | `validate-diary-and-memo-chains` | chain assertions и state fingerprints |
| Dependencies/selection/paths | `standardize-cli-preflight-and-selection` | selected identities и dependency results |
| Manifest/staging/recovery | `add-recoverable-workflow-transactions` | transaction engine и recovery state |
| Cross-phase composition | этот change | phase order, handoff и joint gate |

Новый change не копирует полные требования owner changes и не меняет их status. При конфликте сначала обновляется соответствующий owner change, затем перечитывается эта integration delta.

## Risks / Trade-offs

- **[Дублирование preflight]** Chain/selection checks могут повторяться при revalidation → разделить semantic validation и дешёвую identity/fingerprint revalidation; correctness важнее минимального числа reads.
- **[Слишком общий neutral record]** Plugin policy может протечь в `scripts/lib` → хранить assertions как данные, а их построение/интерпретацию оставить owner plugin.
- **[Lock создаёт ложное чувство полной защиты]** Внешние tools не обязаны соблюдать lock → fingerprints остаются обязательными перед replace.
- **[Большой integration matrix]** Полное декартово произведение failures станет дорогим → owner suites покрывают детали, общий suite содержит минимальный representative set и один end-to-end interruption/recovery path.
- **[Активные core safety changes ещё не архивированы]** Complete tasks не равны принятому lifecycle status → readiness gate проверяет baseline sync и фактический evidence; archive выполняется отдельным поручением.

## Migration Plan

1. Подтвердить core safety baseline/evidence без изменения пользовательского Vault.
2. Реализовать и принять `validate-diary-and-memo-chains`.
3. Реализовать и принять `standardize-cli-preflight-and-selection`, сохранив public compatibility.
4. Реализовать `add-recoverable-workflow-transactions`, потребляя результаты первых двух changes.
5. Добавить shared handoff и integration suite этой дельты; выполнить focused и полный regression.
6. Синхронизировать новые IDs в baseline/legacy exact-once только после подтверждённого runtime behavior.

Rollback source changes выполняется обычным Git revert отдельного scoped commit. Transaction state/user data не мигрируются автоматически. Если тестовый apply оставляет unresolved transaction, fixture сохраняется для диагностики и удаляется вместе с временным `ZK_HOME` после сбора evidence; реальный Vault не используется.

## Validation Strategy

- structural: native OpenSpec strict validation и exact-once legacy IDs;
- static: Zsh syntax, dependency boundaries, path/quoting checks;
- focused: три owner suites;
- integration: phase order, stale selection, stale chain, apply/rollback failure, SIGKILL recovery, repeat recovery;
- forward: existing runtime suite и `zt-check` postflight;
- safety: before/after hashes и modes для out-of-scope files, temporary `ZK_HOME`, no commit/tag/push/archive.

Результаты фиксируются раздельно как `PASS`, `FAIL`, `BLOCKED`, `NOT-RUN` или `SKIP`; component PASS не повышает joint integration status автоматически.
