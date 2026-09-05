## ADDED Requirements

### Requirement: DIST-001 — Публичный тест не требует личного окружения

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Portable suite MUST проходить на чистом clone и распакованном ZIP без IDENTITY/SOUL/USER/TOOLS/HEARTBEAT, OpenClaw state и личных заметок. Он SHALL проверять исключение приватных файлов из поставки; отсутствие .git SHALL давать SKIP только Git-specific assertions.

#### Scenario: Чистый ZIP

- **GIVEN** поставка распакована без .git и private files
- **WHEN** выполнен portable suite
- **THEN** core checks проходят, Git-only проверки явно SKIP; нет fatal not a git repository

#### Scenario: Утечка private artifact

- **GIVEN** в ZIP добавлен USER.md
- **WHEN** проверяется состав публичной поставки
- **THEN** проверка fails с именем запрещённого артефакта

### Requirement: DIST-002 — Bootstrap воспроизводится из README

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

README и example vault MUST содержать проверяемые шаги установки зависимостей macOS/Linux, подключения CLI, задания ZK_HOME, инициализации пустых каталогов, первой записи и zt-check. Example SHALL содержать только синтетические данные и не требовать первого Diary для исправности.

#### Scenario: Первый запуск

- **GIVEN** изолированы HOME/PATH и пустой временный vault
- **WHEN** выполнены шаги README на поддержанной платформе
- **THEN** создана Note с metadata/activity, checker проходит без личных файлов автора

#### Scenario: Не хватает зависимости

- **GIVEN** в PATH отсутствует UUID provider
- **WHEN** выполняется documented first-create
- **THEN** понятная диагностика зависимости до knowledge-записи

### Requirement: DIST-003 — Runtime integration устанавливается и проверяется отдельно

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

Документация и zt-skills-review MUST явно разделять source repository, ZK_HOME и ZK_SKILLS_HOME. Проверка совместимости SHALL использовать manifest revision/hash и выбранный vault для Detailed Notes; отсутствие optional integration SHALL не означать failure core distribution.

#### Scenario: Core без агента

- **GIVEN** у пользователя нет OpenClaw skills
- **WHEN** выполнен portable release check
- **THEN** core result успешен; optional runtime integration отмечена SKIP

#### Scenario: Несовместимая runtime revision

- **GIVEN** пользователь явно запускает integration check с другим hash навыка
- **WHEN** проверяется manifest
- **THEN** integration check сообщает mismatch и ненулевой код без публикации или скачивания
