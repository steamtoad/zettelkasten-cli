# Исправление регрессий атомарной записи

## Why

Проверка текущего рабочего дерева 2026-09-06 поверх HEAD `cf4611d4f203a52298e128b29bac676d11adc973` выявила пять дефектов реализации `fix-atomic-document-writes`. OpenSpec 60/60, оба primary tests и общий suite проходили, но дополнительные поведенческие fixtures опровергли полноту гарантий. Самодостаточные воспроизведения зафиксированы в [evidence.md](evidence.md).

## Current Behavior

1. P1: Refine после коллизии exclusive create удаляет чужой файл или symlink в rollback.
2. P1: Reduce Full Copy маскирует отказ producer `awk`, создаёт невалидный successor, архивирует старую Topic и сообщает успех.
3. P1: writer сохраняет mode, но молча теряет macOS ACL при замене.
4. P2: `zk_topic_create` обходит прежний preflight `zk_topic_write` и принимает пустой key-topic.
5. P2: recovery-список Reduce не включает уже изменённый `all-todays`.

## Desired Behavior

Коллизия сохраняет чужое назначение на всём пути, включая rollback. Ошибка подготовки или обязательного чтения не превращается в успешное создание. ACL/ownership сохраняются в поддерживаемой политике либо диагностируются до замены. Topic с пустым key-topic отклоняется до записи. Recovery-диагностика перечисляет все уже затронутые knowledge-файлы, включая журнал.

## What Changes

- Полные MODIFIED blocks `WRITE-SAFE-001…004`: сохраняются исходные требования и сценарии; добавляются контрпримеры замены, Full Copy, Refine rollback и recovery-списка.
- Полный MODIFIED block `TOPIC-003`: проверка непустого key-topic явно распространяется на прямой вызов object constructor и sourced function.
- Primary test будущей реализации: `tests/zt-fix-atomic-write-regressions.zsh`.
- Новые stable IDs не вводятся; runtime implementation этой задачей не изменяется.

## Non-Goals

Общие многофайловые транзакции, блокировки, SIGKILL recovery и fsync-durability остаются scope `add-recoverable-workflow-transactions`. Полная валидация CR/LF/whitespace-only всех полей остаётся scope `strengthen-document-integrity-checks`. Исправление LF прошло проверку и не входит в эту дельту. Миграция Vault, архивирование changes, commit/tag/push и публикация не выполняются.

## Capabilities

### New Capabilities

Нет.

### Modified Capabilities

- `file-write-safety`: `WRITE-SAFE-001`, `WRITE-SAFE-002`, `WRITE-SAFE-003`, `WRITE-SAFE-004`.
- `topic-semantics`: `TOPIC-003`.

## Impact

- Уровень предполагаемой реализации: L1, приоритет P1; единый scope — исправление пяти дефектов атомарной записи.
- Основные файлы: `.scripts/lib/asciidoc.zsh`, `.scripts/zt-refine.zsh`, `.scripts/zt-reduce.zsh`, `.scripts/objects/topic-create.zsh`; проверяются вызывающие creation/binding entrypoints и общий test runner.
- Baseline traceability: пять изменяемых IDs выше; связанные неизменяемые `SAFE-001`, `SAFE-002`, `DOC-002`, `TOPIC-002`, `REFINE-010`, `SPEC-001`, `SPEC-002`, `SPEC-006`.
- Польза сейчас: исключение подтверждённого удаления данных, ложного успеха и потери ACL; восстановление входной валидации и диагностики.
- Совместимость: сохраняются UUID v1, существующие имена/links, пять типов, Topic key semantics, AsciiDoc, Vim и Zsh CLI. Неподдерживаемая ACL/ownership policy даёт явный отказ вместо скрытой потери свойств.
- Польза будущей архитектуре: общий writer и object preflight сохраняют нейтральные boundaries, пригодные для zcreate; новые зависимости на sibling plugins не нужны.
- User-data/destructive impact: только синтетические временные ZK_HOME для tests; пользовательские данные не изменяются. Автоматическая миграция не требуется.
- Статус: PROPOSED. Baseline уже утверждает часть гарантий, которым реализация не соответствует; это известный implementation/spec mismatch, а не доказательство реализации данного change.

## Dependencies and Composition

Дельта применяется поверх `fix-atomic-document-writes` и его уже синхронизированного в текущем рабочем дереве `file-write-safety` baseline. Если в другой ветке baseline отсутствует, сначала интегрируется предшественник; порядок нельзя менять.

Пересечение `WRITE-SAFE-001…004` намеренно. Итоговая последовательность: predecessor additions → эти MODIFIED blocks. При baseline synchronization/archive predecessor старые ADDED blocks не должны затирать уточнённые требования. Перед интеграцией требуется явное сравнение полного merged preview. Не считать predecessor archive-ready, пока пять противоречий не закрыты evidence. Его прежние tasks/verification остаются историческим утверждением, которое новая проверка опровергла; их актуализация включена в будущие задачи.

`fix-script-ending-idempotency` независим. Новая дельта не повышает ROADMAP `SAFE-002`/`TXN-*` до IMPLEMENTED.

## Verification

Primary test: `tests/zt-fix-atomic-write-regressions.zsh`, создаваемый на этапе реализации. Он должен проверять exit/stdout/stderr, точные bytes/modes/ACL и множество изменённых файлов. Проверки наличия имени helper, ID или строки `Already changed files` не заменяют поведенческие assertions.

Формальная валидация этой спецификации не означает исправление runtime. Все implementation/verification tasks остаются открытыми до соответствующего evidence.
