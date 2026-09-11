## Context

См. [proposal.md](proposal.md) — `Why`. Сейчас `scripts/inbox/capture.zsh` создаёт `inbox/raw`, резервирует файл и записывает metadata до разбора и проверки `$EDITOR`. Baseline `INBOX-008` закрепляет этот порядок, поэтому целевой preflight из `standardize-cli-preflight-and-selection` требует отдельной согласованной модификации capability `inbox`.

## Goals / Non-Goals

**Goals:**

- Проверять editor command до первого filesystem side effect Inbox.
- Сохранить безопасный Zsh lexical parsing, quoted executable/arguments и default `vim` только для отсутствующей переменной.
- Проверять поведение через публичный `scripts/zt-inbox.zsh` на временном `ZK_HOME`.

**Non-Goals:**

- Унификация остальных dependency checks и selectors.
- Изменение raw schema, collision reservation, root resolution или processed workflow.
- Очистка raw-файлов, оставшихся от прежнего поведения.

## Decisions

### 1. Различать отсутствующий и явно пустой EDITOR

Отсутствующий `EDITOR` сохраняет совместимый default `vim`; присутствующий, но пустой `EDITOR` отклоняется. Это выполняет новый contract без неожиданного отказа у пользователей, которые никогда не задавали переменную.

Альтернатива — применять `${EDITOR:-vim}` и к отсутствующему, и к пустому значению — отклонена: явно пустая конфигурация маскировалась бы default и не проходила обязательный negative scenario.

### 2. Выполнять полный editor preflight до mkdir

Lexical parsing и `command -v` перемещаются после проверки CLI title, но до `mkdir -p "$RAW_DIR"`, timestamp generation и reservation raw-файла. После preflight используется уже разобранный массив аргументов, поэтому между проверкой и `exec` команда не разбирается повторно.

Альтернатива — удалять raw после поздней ошибки editor — отклонена: она оставляет observable mutation window и не выполняет требование отсутствия любых Inbox side effects.

### 3. Сохранить plugin boundary и compatibility entrypoint

Изменение остаётся в `scripts/inbox/capture.zsh`; `scripts/zt-inbox.zsh` продолжает direct `exec` delegation. Общая библиотека не добавляется, поскольку изменение принадлежит одному plugin и не требует новой межплагинной primitive.

Альтернатива — одновременно вводить общий preflight library — отклонена как scope `standardize-cli-preflight-and-selection`, а не этой точечной модификации `INBOX-008`.

## Risks / Trade-offs

- [Между `command -v` и `exec` executable может исчезнуть] → `exec` остаётся authoritative operation и возвращает ненулевой status; raw уже создан, но такой внешний race не приравнивается к заведомо невалидной конфигурации preflight.
- [Изменяется прежний ошибочный side effect] → изменение помечено как breaking только для invalid-editor path и покрывается assertions на отсутствие directories/raw.
- [Разбор Zsh может изменить quoted semantics при переносе кода] → regression сохраняет path с пробелами, quoted arguments, пустой argument и literal command-substitution text.

## Migration Plan

1. Добавить regression fixtures для unset, empty, missing и quoted `EDITOR` на временном `ZK_HOME`.
2. Переместить parsing/preflight до filesystem mutations, не меняя остальной capture path.
3. Выполнить Inbox и repository validation; затем синхронизировать `INBOX-008` в baseline, legacy requirements и Feature List.
4. Отдельно обновить dependency/composition в `standardize-cli-preflight-and-selection` перед его повторным apply.

Rollback — вернуть прежний порядок в implementation и baseline одним согласованным изменением; существующие пользовательские raw-файлы не удаляются и не преобразуются. Change не выполняет commit/tag/push и не затрагивает реальный Vault.
