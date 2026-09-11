## Why

Core safety primitives теперь покрывают атомарную одиночную запись, строгую целостность документов и общий разбор AsciiDoc, но три следующих слоя безопасности остаются отдельными proposed changes: `validate-diary-and-memo-chains`, `standardize-cli-preflight-and-selection` и `add-recoverable-workflow-transactions`. Без общего интеграционного контракта их можно реализовать в несовместимом порядке: selection или chain state могут устареть до apply, transaction manifest может не включить все проверенные файлы, а ошибка ранней фазы может быть потеряна поздней диагностикой.

Сейчас требуется зафиксировать переход после core safety: сначала получить надёжные read-only chain и CLI preflight results, затем связать их с recoverable transaction plan и доказать совместное поведение на временном Vault.

## Current Behavior

- `strengthen-document-integrity-checks` и `unify-asciidoc-metadata-and-links` имеют выполненные tasks, а базовые atomic-write changes уже интегрированы; это создаёт нижний слой безопасности, но не доказывает многофайловую transactionality.
- `validate-diary-and-memo-chains`, `standardize-cli-preflight-and-selection` и `add-recoverable-workflow-transactions` существуют как отдельные complete planning artifacts с нулевым implementation progress.
- Каждый из трёх changes описывает локальные guards, но canonical contract пока не определяет общий фазовый порядок и передачу fingerprints между chain/selection preflight и transaction apply.
- Текущий runtime выполняет отдельные локальные проверки и записи; общего manifest, который связывает результат выбора, chain state и полный write set, нет.

## Desired Behavior

Mutating workflow SHALL выполнять детерминированную последовательность `resolve dependencies and selection → validate affected chain/state → freeze fingerprints and write set → build and validate transaction manifest → stage → revalidate → apply → postflight`. Результаты preflight SHALL входить в transaction plan как проверяемые identities/fingerprints; устаревание любого результата до первой или очередной замены SHALL завершать workflow как `STATE_CONFLICT` без перезаписи чужих данных.

## What Changes

- Добавляется единый фазовый контракт для композиции `CHAIN-CHECK-*`, `CLI-PREFLIGHT-*` и `TXN-*`, не меняющий владельцев этих требований.
- Фиксируется readiness gate: transaction integration начинается после подтверждённой реализации chain и CLI preflight changes поверх завершённого core safety слоя.
- Определяется immutable handoff record с выбранными identities, chain/state fingerprints, полным write set и dependency evidence.
- Определяется порядок ошибок и запрет поздним фазам маскировать ранний отказ; независимые read-only проверки могут продолжаться только если не влияют на mutation decision.
- Добавляется общий integration regression с interruption, stale selection, stale chain tail, rollback/recovery и postflight на временном `ZK_HOME`.

## Non-Goals

- Не дублировать и не переопределять `CHAIN-CHECK-*`, `CLI-PREFLIGHT-*` или `TXN-*`.
- Не вводить глобальную БД, daemon, обязательный background service или новый пользовательский формат документов.
- Не менять UUID v1, AsciiDoc metadata/link syntax, `:key-topic:`, `:deprecated:`, Diary/Memo semantics, `all-todays` или Workspace semantics.
- Не применять изменения к реальному Vault, не выполнять migration, commit, tag, push, archive или deployment в рамках proposal.
- Не объявлять три зависимых changes или новый интеграционный контракт `IMPLEMENTED` до кода, tests, baseline/legacy sync и evidence.

## Capabilities

### New Capabilities

- `workflow-safety-orchestration`: фазовый и проверяемый контракт композиции chain validation, CLI preflight и recoverable workflow transactions.

### Modified Capabilities

Нет. Существующие capability owners сохраняются; интеграционная дельта ссылается на их stable IDs, не создавая конкурирующих `MODIFIED Requirements`.

## Impact

- **Affected contracts:** `SAFE-001`, `SAFE-002`, `SAFE-004`, `CHECK-004`, `ZP-DIARY-005`, `FLOW-002`; dependent proposed IDs `CHAIN-CHECK-001..003`, `CLI-PREFLIGHT-001..004`, `FZF-002`, `TXN-001..004`.
- **New IDs:** `FLOW-SAFE-001..004`, зарезервированные только этой дельтой до подтверждённой интеграции.
- **Affected implementation:** shared preflight/result structures, Diary/Memo and selector workflows, transaction manifest/staging/recovery, `zt-check` postflight and focused integration tests.
- **Dependencies:** завершённый core safety слой; затем `validate-diary-and-memo-chains` и `standardize-cli-preflight-and-selection`; затем `add-recoverable-workflow-transactions` и эта integration delta.
- **Compatibility:** действующие команды, stdout identities, filenames, links и cancel semantics сохраняются; новые failures появляются только при ранее неоднозначном или небезопасном состоянии.
- **Architecture:** neutral records/primitives могут жить в `scripts/lib`; plugin-specific chain/selection policy остаётся у владельца plugin; sibling plugins не начинают source друг друга.
- **User data:** implementation и validation используют только временный `ZK_HOME`; реальный Vault не изменяется этой proposal-фазой.
- **Migration/destructive impact:** автоматической миграции нет. Обнаруженное старое повреждение диагностируется read-only; исправление требует отдельного плана/recovery.
- **Status:** `PROPOSED`; change не является доказательством реализации зависимых capabilities.
