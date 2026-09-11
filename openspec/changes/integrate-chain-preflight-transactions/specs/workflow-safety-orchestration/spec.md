## Purpose

Определить единый наблюдаемый порядок preflight, chain validation и recoverable transaction для многофайловых mutating workflows без изменения существующей модели документов.

## ADDED Requirements

### Requirement: FLOW-SAFE-001 — Mutating workflow имеет единый порядок фаз

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется только после проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Workflow, изменяющий документ, связь, `all-todays` или state, MUST до первой knowledge-записи завершить dependency/selection preflight и проверку затрагиваемой chain/state. После них workflow SHALL зафиксировать полный write set и выполнить transaction plan, staging, повторную проверку, apply и postflight именно в этом порядке. Пропущенная или неуспешная фаза MUST запрещать последующие mutating phases.

#### Scenario: Ошибка chain до transaction

- **GIVEN** выбранный Diary tail существует, но его `next` уже занят
- **WHEN** workflow пытается создать следующий Diary
- **THEN** chain preflight завершается ошибкой до создания manifest со статусом apply-ready
- **AND** документы, `all-todays` и `.last-diary` сохраняют исходные bytes

#### Scenario: Успешный фазовый проход

- **GIVEN** dependencies, selection, chain и все предполагаемые изменения валидны
- **WHEN** mutating workflow успешно завершается
- **THEN** transaction evidence показывает последовательность preflight, frozen plan, staging, revalidation, apply и postflight
- **AND** success публикуется только после успешного postflight

### Requirement: FLOW-SAFE-002 — Preflight results связаны с transaction plan

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется только после проверенной интеграции.

Transaction plan MUST включать machine identities выбранных объектов, fingerprints каждого прочитанного документа и state-файла, ожидаемые отсутствующие targets, полный write set и применимые chain assertions. Перед первой и каждой последующей заменой workflow SHALL повторно проверить относящиеся к ней fingerprints и absence assertions. Изменившийся либо исчезнувший input MUST давать `STATE_CONFLICT`; recovery MUST NOT перезаписывать обнаруженные чужие bytes.

#### Scenario: Selection устарел после preflight

- **GIVEN** selector вернул active Memo и его fingerprint вошёл в transaction plan
- **WHEN** Memo изменён внешним процессом до apply
- **THEN** workflow завершается `STATE_CONFLICT` без создания binding или нового документа
- **AND** внешняя версия Memo сохраняется

#### Scenario: Diary tail изменён между staging и apply

- **GIVEN** staged Diary построен для определённого `.last-diary` и tail fingerprint
- **WHEN** другой writer обновил tail либо pointer до первой замены
- **THEN** старый plan отклонён как `STATE_CONFLICT`
- **AND** workflow не создаёт второй `next` от прежнего tail

### Requirement: FLOW-SAFE-003 — Результат отказа сохраняет первичную причину и recovery state

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется только после проверенной интеграции.

Workflow MUST различать dependency failure, cancel, invalid selection, chain corruption, `STATE_CONFLICT`, apply failure и `RECOVERY_REQUIRED`. Поздняя cleanup, postflight или rollback ошибка SHALL дополнять, но MUST NOT скрывать первичную причину. Cancel SHALL сохранять действующую совместимую семантику только если ни одна mutating phase не начиналась; unresolved recovery SHALL блокировать новый writer, но не обязано блокировать независимую read-only диагностику.

#### Scenario: Rollback тоже завершился ошибкой

- **GIVEN** apply failure запустил rollback, который не восстановил один файл
- **WHEN** workflow формирует итоговый результат
- **THEN** результат содержит первичную apply error и `RECOVERY_REQUIRED` с affected files и backup location
- **AND** workflow не сообщает полный rollback или success

#### Scenario: Независимая read-only диагностика

- **GIVEN** в Vault обнаружена unresolved transaction
- **WHEN** запускаются следующий writer и read-only checker
- **THEN** writer прекращает работу до mutation с `RECOVERY_REQUIRED`
- **AND** checker читает доступные данные и сообщает ту же unresolved transaction без их изменения

### Requirement: FLOW-SAFE-004 — Совместная готовность доказывается integration regression

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется только после проверенной интеграции.

Проект MUST иметь executable integration regression на временном `ZK_HOME`, который совместно проверяет принятые `CHAIN-CHECK-*`, `CLI-PREFLIGHT-*` и `TXN-*`. Change SHALL NOT считаться implementation-ready для archive, если отдельные suites проходят, но совместный сценарий не подтверждает phase order, immutable handoff, stale-state rejection, interruption recovery, idempotent retry, postflight и отсутствие out-of-scope mutations.

#### Scenario: Совместный happy path и interruption

- **GIVEN** synthetic Vault содержит валидные Diary/Memo chains и доступные dependencies
- **WHEN** suite выполняет успешный workflow и отдельный workflow с interruption после первой замены
- **THEN** happy path имеет согласованные документы, links, journal и state
- **AND** interrupted path обнаруживается следующим writer/checker и восстанавливается по `TXN-*` без потери чужих данных

#### Scenario: Одни component tests недостаточны

- **GIVEN** focused chain, preflight и transaction tests прошли отдельно
- **WHEN** общий integration regression отсутствует, пропущен или завершился ненулевым exit
- **THEN** integration change остаётся `PROPOSED` или `BLOCKED`
- **AND** его status MUST NOT повышаться до `IMPLEMENTED`
