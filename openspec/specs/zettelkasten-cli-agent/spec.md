# Zettelkasten CLI: мастер-спецификация агентной подсистемы и библиотекаря OpenClaw

Документ: `MS-AGENTS-001` · Редакция: `1.0` · Дата: `2026-09-11`.

Статус: **PROPOSED / целевая спецификация**. Описанные изменения ещё не реализованы. Новые требования `ASYS-*` зарезервированы этим документом; их исходный статус — `ROADMAP`.

Предлагаемое место в репозитории: `openspec/master/agents-master-spec.md`. Это мастер-план агентной подсистемы и источник scope для дельт. Единственный действующий нормативный baseline проекта остаётся в `openspec/specs/*/spec.md`.

## Purpose

Определить целевую архитектуру агентной подсистемы Zettelkasten-CLI, её роли, границы, маршрутизацию, contracts, OpenClaw-интеграцию и управляемое развитие через OpenSpec.

## 1. Цель и границы

Включить 34 скилла из прежнего контура Марты в Git-версионируемый проект Zettelkasten CLI, разместить их в каталоге `Agents`, обеспечить доступ локальному агенту разработки и подключить отдельного агента-библиотекаря OpenClaw. Дальнейшее развитие скиллов, их контрактов и интеграции вести через OpenSpec delta changes.

Целевая модель:

- **Локальный агент разработки** сопровождает CLI, OpenSpec, скиллы, адаптеры и проверки. Он может прочитать весь каталог скиллов и проверить runtime-процедуры на временном Vault.
- **Библиотекарь OpenClaw** работает с пользовательским Zettelkasten: захватывает материалы, ищет, связывает, создаёт и развивает знания, выполняет предметные workflow. Его набор доступных операций задаётся отдельным профилем.
- **CLI** выполняет детерминированные файловые операции и обеспечивает инварианты данных. LLM выбирает содержание, классификацию и обоснованные связи.
- **Каталог `Agents`** хранит канонические исходники агентного слоя. Установленные копии в OpenClaw являются развёртыванием определённой версии этих исходников.

В начальный каталог входят **41 скилл: 34 импортируемых и семь уже существующих development skills**. Это количество относится к исходной поставке, а не является постоянным ограничением. Добавление `zettelkasten-inbox-promote` в отдельной дельте увеличит каталог до 42, если к этому моменту другие дельты не изменят состав.

В scope входят импорт, структура, роли, маршрутизация, общие контракты, переносимость, подключение OpenClaw, проверяемое развёртывание и план развития. Вне scope первоначального импорта: массовая правка пользовательских заметок, переименование UUID, запуск периодических задач, изменение каналов доставки сообщений, публикация статей, создание нового хранилища знаний, базы данных или web-сервиса.

Термины `MUST`, `SHALL`, `MUST NOT` обозначают обязательства целевого решения. В этом документе они не означают, что текущая реализация уже им соответствует.

## 2. Проверенная исходная точка

### 2.1. Источники и пределы проверки

| Источник | Что установлено |
|---|---|
| `zettelkasten-cli.zip` | 39 baseline capabilities; 24 top-level `scripts/zt-*.zsh`; семь `dev/skills/zettelkasten-*/SKILL.md`; каталога `Agents` нет |
| `Archive.zip` | 34 файла `SKILL.md`; исходный operational/domain/governance слой Марты |
| `scripts/docs/managed-skills.adoc` | 33 строки manifest: 24 `operational` и девять `meta`; внешний runtime state является текущей точкой интеграции |
| `AGENTS.MD`, `openspec/config.yaml` | Марта определена как development agent; обычная разработка не разрешает изменения пользовательского Vault |
| `openspec/specs/agent-governance/spec.md` | Привязка CLI → skill; Skill Workshop; Detailed Note; SHA-256; специальные OpenClaw binding rules |
| `openspec/specs/development-agent/spec.md` | Семь скиллов разработки, source/data boundary, авторизация и проверки |
| `dev/scripts/docs/skill-contracts/` | Уже существуют общие development, authorization, migration и release contracts |
| `dev/scripts/zt-openspec-check.zsh` | Выполнен: `PASS`, 336 legacy requirements покрыты ровно один раз |
| `dev/scripts/zt-agent-skills-check.zsh` | Выполнен: `PASS`, семь development skills |

SHA-256 исходных архивов:

```text
zettelkasten-cli.zip
1c23083f6889bb66d062fa88b05d4181b51c4ca01636d0170ba1621dda9d2b02

Archive.zip
3b1be559541733616d358ec1e223df7a5b035c24934e7e6ae2bf553956da75a7
```

В архиве CLI `HEAD` указывает на `main`, commit `cf4611d4f203a52298e128b29bac676d11adc973`. Это идентификатор Git HEAD из архива; он сам по себе не доказывает совпадение всех приложенных рабочих файлов с commit. Для воспроизводимости исходной поставки используется также хеш ZIP.

Проверка проводилась на извлечённых исходниках. Реальный пользовательский Vault, Detailed Notes, установленный OpenClaw и эффективный runtime-каталог не проверялись. В среде проверки отсутствовали `openspec` CLI и `asciidoctor`; native validation и rendering не объявляются выполненными. Runtime-регрессии всего CLI для подготовки этого документа не запускались.

### 2.2. Расхождения перед импортом

Из 34 исходных скиллов **31 совпадает** с manifest по SHA-256; два имеют другой хеш; один отсутствует в manifest.

| Скилл | Manifest | Исходный `Archive.zip` | Значение для импорта |
|---|---|---|---|
| `zettelkasten-weekly-new` | `9dd52a8c60f0529e78480eb930753f716e39cc824eafe7a38d6885413ce0b3c9` | `dc31369875b27be35e245b6e09ac9a0d981b06c052247eeab5434ca1cffdea4f` | Нужна явная фиксация принятой редакции |
| `zettelkasten-red-trigger-chain` | `713c42322956d6a7b5c2211b12dd6dc5b8031f46920b0d0ae79536f2b783996e` | `e17fa133df054ec292182e30f591f34a69a6df4af2bedb603355cfd0f5b5d20c` | Нужна явная фиксация принятой редакции |
| `zettelkasten-delta-spec` | Строка отсутствует | `16f4e966d8c1c26efd5d41730c5f9d1c68fbd364b04885011a957193db525c76` | Добавить как `meta`, без фиктивного CLI mapping |

Старые байты двух несовпадающих редакций в manifest не содержатся. Поэтому по одному хешу нельзя восстановить смысловой diff или определить, какая редакция новее. Импортный отчёт фиксирует это ограничение, проверяет предоставленную редакцию относительно baseline и явно документирует её принятие либо оставшийся конфликт. Простое обновление контрольной суммы не считается разрешением смыслового конфликта.

Другие подтверждённые особенности:

- `zettelkasten-delta-spec` ссылается на отсутствующий в обоих архивах внешний `openspec-delta-spec` и абсолютный checkout.
- `zettelkasten-requirements` называет legacy `requirements.adoc` канонической спецификацией; действующий repository baseline уже устанавливает нормативный приоритет OpenSpec.
- `weekly-new` и `weekly-new-memo` расходятся по частным правилам, включая fallback Topic и формирование metadata.
- Root-файл называется `AGENTS.MD`, тогда как стандартная bootstrap-точка OpenClaw — `AGENTS.md`.
- `zt-agent-skills-check.zsh`, публикация и тесты ссылаются на существующий каталог `dev/skills/`; перенос требует их согласованного изменения.
- `scripts/lib/paths.zsh` вычисляет `zk_scripts_dir()` из `ZK_HOME/.scripts`. Введение отдельного корня CLI нельзя осуществить одним добавлением переменной в prompt.
- Исходные скиллы используют `:author: marta`, личные пути и конкретные Topic UUID; это требует разделения общих процедур и локальной конфигурации.

## 3. Источники истины и принятие изменений

| Уровень | Ответственность |
|---|---|
| Действующий `openspec/specs/` | Нормативное поведение и процесс текущей версии |
| Активный `openspec/changes/<change-id>/` | Предлагаемая дельта для конкретного scope; не заменяет текущий baseline |
| Эта мастер-спецификация | Целевая архитектура, декомпозиция, зависимости и реестр зарезервированных `ASYS-*` |
| `scripts/`, тесты и проверенное поведение | Исполнимые факты и доказательства реализации |
| `Agents/skills/`, общие contracts | Процедуры выбранной версии; не могут менять нормативные инварианты |
| `Agents/manifest.json` | Состав, зависимости, профили, пути и контроль версий агентного пакета |
| Legacy requirements | Стабильные ID и синхронные статусы требований |
| Feature List | Только подтверждённые реализованные возможности |
| Detailed Notes и архивированные changes | Объяснение и история; не второй действующий baseline |

После интеграции каждой дельты мастер обновляет ссылки, состояние этапа и evidence, а полное принятое требование находится ровно в одной baseline capability. Мастер не становится независимой редактируемой копией всех принятых требований.

При расхождении baseline, CLI и skill результат — `SPEC_CONFLICT` для затронутой операции. Агент сообщает конкретные источники и не выбирает молча удобную интерпретацию. Независимые read-only операции могут продолжаться.

## 4. Архитектура и структура `Agents`

### 4.1. Ответственность слоёв

| Слой | Содержание | Чего он не определяет |
|---|---|---|
| L0 — repository contracts | OpenSpec, `scripts/`, document model, legacy traceability | Предметное содержание пользовательской заметки |
| L1 — primitive operations | Memo, Note, Topic, Todo, Diary, поиск, чтение, workspace, inbox | Приоритет competing domain workflows |
| L2 — lifecycle | Continue, Reduce, Refine, миграции | Новые правила Topic по предположению модели |
| L3 — knowledge orchestration | Capture, relationships, weekly synthesis, inbox promotion | Собственный формат UUID, metadata или backlinks |
| L4 — domain workflows | Morning thoughts, channels, RED, article drafts | Собственный файловый transaction engine |
| L5 — development/governance | Изменения спецификаций, review, tests, release | Неявную запись пользовательских знаний |

Композиция скиллов означает чтение и применение контрактов в пределах одного workflow. Она не предполагает наличие API вызова skill, запуска подагента или автоматической передачи сообщений между агентами.

### 4.2. Целевая раскладка

Все перечисленные новые пути — проектное решение этой спецификации, а не утверждение об их наличии в архиве.

| Путь | Содержание |
|---|---|
| `Agents/README.md` | Вход в агентную подсистему, роли, навигация и поддерживаемый способ подключения |
| `Agents/skills/<skill-name>/SKILL.md` | Единственная каноническая редактируемая версия каждого из 41 исходных скиллов |
| `Agents/skills/<skill-name>/references/` | Только специфические материалы данного skill |
| `Agents/manifest.json` | Машиночитаемый каталог скиллов и их контрактов |
| `Agents/manifest.schema.json` | Схема и правила проверки manifest |
| `Agents/contracts/runtime-v1.md` | Корни, scope, статусы, авторизация, общий runtime-протокол |
| `Agents/contracts/document-operations-v1.md` | Ссылки на нормативную механику документов и проверяемые postconditions |
| `Agents/contracts/routing-v1.md` | Приоритеты, negative triggers и композиция |
| `Agents/contracts/relationships-v1.md` | Поиск кандидатов и доказательство связи |
| `Agents/contracts/topic-policy-v1.md` | Роли Topic и ограничения lifecycle |
| `Agents/contracts/write-validation-v1.md` | Общий write/postflight protocol поверх CLI |
| `Agents/contracts/weekly-review-v1.md` | Единая процедура weekly и режимы ответа |
| `Agents/profiles/developer/AGENTS.md` | Инструкции роли разработки без привязки к имени Марта |
| `Agents/profiles/librarian/AGENTS.md` | Инструкции библиотекаря и разрешённые классы операций |
| `Agents/profiles/librarian/SOUL.md` | Поведение библиотекаря, работа с источниками и неопределённостью |
| `Agents/profiles/librarian/IDENTITY.md` | Значения по умолчанию для нового агента |
| `Agents/profiles/librarian/config.example.json` | Обезличенная схема локальных путей, автора и Topic bindings |
| `Agents/adapters/openclaw/README.md` | Поддерживаемые версии, установка, effective discovery и обновление сессии |
| `Agents/migrations/` | Импортный отчёт, сопоставление старых и новых путей, принятых редакций |
| `tests/zt-agent-*.zsh` | Проверки каталога, профилей, routing, установки и поведений |
| `dev/scripts/` | Детерминированные средства проверки/развёртывания; точные новые CLI определяет соответствующая дельта |

Существующие `dev/scripts/docs/skill-contracts/` остаются каноническими development references. Новые runtime contracts не копируют их целиком. Их возможный последующий перенос выполняется отдельно, с проверкой всех ссылок.

В первой дельте семь development skills перемещаются из `dev/skills/` в `Agents/skills/`. Все repo-local consumers изменяются в том же scope. Старый каталог удаляется только после проверки отсутствия действующих ссылок; две независимо редактируемые копии не сохраняются. Если нужен переходный compatibility export, он помечается generated, имеет срок удаления и не становится источником для авторинга.

Root `AGENTS.MD` приводится к `AGENTS.md` через переименование одного файла. На case-insensitive файловой системе используется промежуточное имя; файлы, различающиеся только регистром расширения, одновременно не создаются. Repository markers, README, tests, publisher и references обновляются согласованно. Root-файл содержит общие инварианты и переход к нужному профилю.

В `Agents` не сохраняются OpenClaw sessions, credentials, memory, локальная конфигурация с личными путями, временные backups и установленное runtime state.

## 5. Роли, конфигурация и подключение OpenClaw

### 5.1. Матрица полномочий

| Действие | Локальный developer | Библиотекарь |
|---|---|---|
| Читать каталог и относящиеся к задаче contracts | Да, весь каталог | Да, разрешённый профиль и зависимости |
| Изменять CLI, скиллы, specs, tests | В рамках задачи разработки | Нет; формирует предложение на изменение |
| Проверять runtime-операции | Временный `ZK_HOME` | Настроенный Vault в рамках задачи пользователя |
| Искать и читать реальные заметки | Только если это входит в запрос | Да |
| Создавать Memo/Note/Todo/Diary | В тестовом Vault; production — отдельная runtime-задача | По явному намерению пользователя и своему профилю |
| Reduce/Refine, миграция данных | По отдельному конкретному плану | По конкретному scope и полномочию на операцию |
| Review CLI/skills без записи | Да | Допустимая диагностика, если включена в профиль |
| Release apply, commit, tag, push | В пределах явно порученной операции | Не включены в обычный профиль |
| Создание proposal/delta | Да | Можно подготовить запрос/черновик; запись в source repo — задача developer |

Наличие файла `SKILL.md` или его видимость не выдаёт полномочия на запись. Успешное выполнение библиотекарем Memo workflow не даёт ему права исправить обнаруженный дефект CLI. Создание дельты не означает её реализацию или archive.

Начальный librarian profile включает 29 исходных имён: 26 обычных процедур и три процедуры с отдельным lifecycle/migration scope — `reduce`, `refine`, `migrate-notes-dir`. Пять исходных скиллов остаются developer-only: `scripts-patch`, `publish-cli-version`, `requirements`, `features`, `delta-spec`. Семь development skills также не включаются в библиотечный runtime-профиль. `scripts-review` и `skills-review` доступны библиотекарю только для диагностики без записи. Доступность процедуры в профиле дополнительно ограничивается её readiness; включение имени не разрешает неподготовленный apply.

Адаптер отдельно фиксирует, обеспечивается ли граница source/Vault средствами executor, файловыми правами или только процедурными инструкциями. Правила в prompt и skill allowlist сами по себе не считаются доказательством технической изоляции.

Уже данное пользователем полномочие применяется ко всему согласованному scope операции. Скиллы не требуют повторного подтверждения для каждой заметки, обратной ссылки или файла, заранее включённых в этот scope. Новый запрос требуется при существенном расширении операции или неоднозначности, которую нельзя разрешить из контекста.

### 5.2. Конфигурационные границы

| Параметр | Значение и способ разрешения |
|---|---|
| `ZK_DEV_HOME` | Source checkout CLI; явная настройка либо текущий Git root с проверенными project markers |
| `ZK_HOME` | Пользовательский Vault; для библиотекаря задаётся явно, для tests — временный каталог |
| `ZK_AGENTS_HOME` | Корень `Agents` читаемой версии: в source checkout либо в проверенном runtime bundle |
| `ZK_CLI_HOME` | Целевой корень исполняемой версии CLI; существование и поддержка отделения от Vault доказываются адаптером |
| `ZK_SKILLS_HOME` | Сохраняемый compatibility override для проверок установленного каталога; не заменяет источник авторинга |
| `ZK_AGENT_CONFIG` | Локальный файл настроек профиля без секретов в исходниках |
| `ZK_AGENT_AUTHOR` | Автор новых документов библиотекаря; по умолчанию `librarian` |
| `ZK_AGENT_TIMEZONE` | Часовой пояс activity, generated dates и границ weekly window |
| `ZK_ARTICLES_HOME` | Явный внешний каталог для Markdown-черновиков; требуется только для article workflow |

Для новых параметров дельта определяет реальную передачу в executor, формат и проверку значений. Запись имени переменной в Markdown сама по себе не настраивает процесс.

Перед файловой операцией корни приводятся к абсолютным realpath и проверяются по назначению. Для Vault и статей запрещён выход через `..` или symlink за разрешённую область. Совпадение source checkout и пользовательского Vault по умолчанию диагностируется; такое размещение допустимо только при явной конфигурации и доказанном разделении writes.

Чтение CLI из отдельного checkout разрешается только если проверены все его path helpers. Пока используется существующий `zk_scripts_dir()`, адаптер должен либо работать с проверенной установкой в `ZK_HOME/.scripts`, либо явно поддерживать раздельные корни через принятую дельту. Смешивание библиотек двух версий запрещено.

Topic UUID и точные ключи для OpenClaw, RED, утренних мыслей и каналов задаются локальной конфигурацией. При первом переносе они сохраняют значения исходного Vault. На другом Vault нужны явно разрешённые соответствия; совпадение отображаемого названия само по себе не доказывает identity.

Имя `marta` не заменяется в существующих заметках. Новые документы получают configured author. Переименование агента не меняет UUID, происхождение исторического текста или атрибуцию автора пользовательского материала.

### 5.3. Способ подключения

Наличие `Agents/skills` в Git **недостаточно для автоматической загрузки OpenClaw**. Официальная документация описывает workspace `skills`, дополнительные каталоги и приоритеты одинаковых имён; стандартный bootstrap-файл называется `AGENTS.md`. Эти детали используются адаптером, а не предполагаются универсальными свойствами любого локального агента. [OpenClaw Skills](https://docs.openclaw.ai/tools/skills), [Agent workspace](https://docs.openclaw.ai/concepts/agent-workspace).

Проектное решение по умолчанию — **проверенная копия выбранного профиля в отдельный workspace библиотекаря**:

1. Выбрать source revision и profile; проверить hashes, contracts, dependencies и permissions.
2. Подготовить staging bundle: выбранные `Agents/skills/<name>/SKILL.md`, supporting files, используемые `Agents/contracts`, профиль и bootstrap.
3. Проверить все references в условиях целевого executor. В sandbox передать разрешённые копии и реальные mounted roots; путь на host не считается автоматически доступным.
4. Сравнить текущую установку с предыдущим deployment receipt. Не перезаписывать неизвестные или локально изменённые файлы.
5. Применить подготовленное обновление, сохранить прежнюю версию для отката и записать receipt: source revision, profile, package digest, пути, версия OpenClaw, результат проверок.
6. Проверить эффективный источник каждого выбранного skill и загрузку новой версии в новой/обновлённой сессии. Каталог на диске и загруженная сессия проверяются отдельно.

Runtime-копии являются generated artifacts. Общие references включаются в bundle так, чтобы canonical `SKILL.md` мог разрешить их через configured `ZK_AGENTS_HOME`; молчаливое переписывание содержимого skill при установке не допускается.

Допустим и режим прямого чтения source через `skills.load.extraDirs`, если пользователь выбирает немедленное использование изменений checkout. По документации этот источник имеет низший приоритет, а доверие к symlink targets настраивается отдельно. Поэтому такой режим требует проверки shadowing и области доверия. Конкретная настройка подтверждается установленной версией, без выдуманного per-agent `extraDirs`. [OpenClaw Skills config](https://docs.openclaw.ai/tools/skills-config).

Для аудита доступны `openclaw skills list`, `info`, `check`; актуальная документация также описывает выбор агента. Адаптер сначала проверяет локальные `--version`/`--help`, затем использует поддерживаемые команды. Вывод списка не заменяет проверку реальной загрузки contracts. [OpenClaw Skills CLI](https://docs.openclaw.ai/cli/skills).

Профиль с доступом только к чтению может быть подключён раньше mutating skills. До появления проверенного noninteractive write path библиотекарь не заявляется готовым к автономной записи.

## 6. Каталог всех 34 импортируемых скиллов

Префикс каждого имени в таблице — `zettelkasten-`. Имена сохраняются при импорте. Обозначения: `N` — `notes/`; `A` — `all-todays/`; `W` — `workspaces/`; `I` — `inbox/`; `R` — source repository; `E` — внешний каталог статей. Общие validation/write rules наследуются; в таблице указаны дополнительные особенности. Ссылки в колонке «Композиция» описывают целевое использование контрактов, а не подтверждённые вызовы между исходными скиллами.

| № | Имя без префикса | Trigger и владелец | Reads → writes | CLI / композиция | Целевая обработка и проверка |
|---|---|---|---|---|---|
| 1 | `check` | Проверить Vault; библиотекарь | N/A/W/I/state → нет | `zt-check.zsh` | Сохранить read-only; различать существующие дефекты и результат операции |
| 2 | `diary` | Создать/продолжить Diary | N/Diary state → N/A/Diary state | `zt-diary.zsh` | Сохранить chain contract; не вести Diary через общий Memo |
| 3 | `edit` | Изменить указанный документ | Выбранный N → согласованный N и связанные файлы при необходимости | `zt-edit.zsh` | Exact scope; editor не считается unattended primitive |
| 4 | `find` | Найти документы | N и явно заданный scope → нет | `zt-find.zsh` | Лексический поиск; не обещать embedding search |
| 5 | `getlink` | Получить ссылку | Выбранный документ → нет | `zt-getlink.zsh` | Проверить identity и контекст пути |
| 6 | `keytopic` | Создать Topic | Активные Topic/N → N/A/обратные связи | `zt-keytopic.zsh` | Exact `:key-topic:`, active/deprecated, duplicate protection |
| 7 | `memo` | Явно создать Memo | Topic/related N → N/A/обратные связи | `zt-memo.zsh` | Канонический primitive; предметные исключения через policy |
| 8 | `note` | Создать развитую Note | Исходники/связи → N/A/обратные связи | `zt-note.zsh` | Канонический primitive; не копировать формат в orchestration |
| 9 | `read` | Прочитать документ | Выбранный N → нет | `zt-read.zsh` | Не создавать capture как побочный эффект чтения |
| 10 | `todo` | Зафиксировать задачу | Topic/related N → N/A/обратные связи | `zt-todo.zsh` | Сохранить Todo contract и явно выбранный контекст |
| 11 | `workspace-create` | Создать рабочий набор | Workspace names → W | `zt-workspace-create.zsh` | Containment и no-overwrite |
| 12 | `workspace-open` | Открыть набор | W и targets → нет | `zt-workspace-open.zsh` | Отображать broken/deprecated targets без исправления документов |
| 13 | `workspace-add` | Добавить документ в набор | W/target → W | `zt-workspace-add.zsh` | Идемпотентность; точный relative link |
| 14 | `workspace-remove` | Убрать документ из набора | W → W | `zt-workspace-remove.zsh` | Atomic update, сохранение mode; не удалять сам документ |
| 15 | `continue-memo` | Продолжить Memo | Chain/Topic → N/A/chain links | `zt-continue.zsh` | Точная цепочка, повторное чтение tail, корректная ветка только по contract |
| 16 | `reduce` | Свернуть выбранную Topic | Topic line/Memo/Note → новое поколение N/A/links/deprecated | `zt-reduce.zsh` | Preview всего scope; semantic role; Note не архивируются автоматически |
| 17 | `refine` | Разделить/уточнить выбранный набор | Выбранный N/links → N/A/rekey/provenance | `zt-refine.zsh` | Exact scope, backlink replacement и проверяемое восстановление |
| 18 | `migrate-notes-dir` | Миграция данных; отдельное поручение | Vault/layout → согласованный Vault scope | `zt-migrate-notes-dir.zsh` | Dry-run, коллизии, backup/recovery; не часть обычного capture |
| 19 | `inbox-capture` | Положить исходный материал во входящие | Вход пользователя → I/raw | `zt-inbox.zsh` | Не создавать постоянные документы автоматически |
| 20 | `inbox-processed` | Завершить staging-обработку | I/raw → I/processed | `zt-processed.zsh` | Не означает import; N/A не изменяются |
| 21 | `scripts-review` | Проверить скрипты | CLI/source → нет | `zt-scripts-review.zsh` | Отличать operational CLI wrapper от `script-review` development skill |
| 22 | `scripts-patch` | Исправить окончания файлов; developer | Скрипты → согласованные скрипты | `zt-scripts-patch.zsh` | Только предусмотренный форматный scope; не универсальный bugfix |
| 23 | `skills-review` | Аудит каталога/установки | Manifest/source/runtime refs → нет | `zt-skills-review.zsh` | Разделить source/package/deployment проверки и reported status |
| 24 | `publish-cli-version` | Вызвать publication workflow; developer | R/destination → publication destination | `zt-develop-publish-version.zsh` | Проверяемая публикация, явный apply; не выдавать выпуск за запись заметки |
| 25 | `requirements` | Изменить требования; developer bridge | OpenSpec/legacy/code → R; optional N отдельной операцией | `openspec-change`, canonical Note | Устранить приоритет legacy над OpenSpec; история редакций сохраняется |
| 26 | `features` | Сверить/обновить Feature List; developer bridge | Code/tests/Feature List → R; optional N | `validation`, canonical Note | Только проверенные функции; история фич без автоматической deprecation |
| 27 | `delta-spec` | Создать OpenSpec change; developer bridge | Baseline/source → R/openspec/changes | `zettelkasten-openspec-change` | Убрать обязательную внешнюю зависимость; draft не равен implement/archive |
| 28 | `theme-capture` | Общий захват знания без более точного workflow | Relevant N → N/A/обратные связи | `memo`, `note`, `keytopic`, relationships | Сократить до orchestration; не дублировать механику документов |
| 29 | `weekly-new` | Обзор недели с полным ответом | Git/new N → weekly N/A/выбранные backlinks | Общий weekly contract + `memo` | Полный body в ответе совпадает с сохранённым body |
| 30 | `weekly-new-memo` | Сохранить weekly с кратким ответом | То же → то же | Тот же weekly contract + `memo` | Сохранить имя как совместимый режим; не второй engine |
| 31 | `morning-thoughts` | Разбор утренней записи | Исходный текст/config/N → N/A/links | `theme-capture`/primitives по resolved plan | Смысловая сегментация, raw provenance, без повторного capture дочерних идей |
| 32 | `capture-channel-topic` | Идея для конкретного канала/каналов | Исходная идея/channel policy/N → N/A/links | `memo`, channel policy, relationships | Сохранить editorial lenses; multi-channel policy явная |
| 33 | `article-drafts` | Написать статью из базы знаний | N/config → E/*.md | Поиск/чтение + article output contract | Vault read-only; точный H1; Memo/Todo отделены как планы |
| 34 | `red-trigger-chain` | Первая непустая строка с RED prefix | RED Topic/chain/input → N/A/chain links | `memo`, `continue-memo`, write protocol | Exact identity `(kind, category)`, линейность, chronology; без выдуманных рисков |

Семь существующих development skills также сохраняют имена:

| Скилл | Ответственность после переноса |
|---|---|
| `zettelkasten-development` | Реализация и исправление согласованного source scope |
| `zettelkasten-openspec-change` | Единственная каноническая repo-local процедура OpenSpec changes |
| `zettelkasten-script-review` | Анализ выбранных скриптов; отличается от CLI wrapper `scripts-review` |
| `zettelkasten-system-review` | Архитектура, зрелость, coverage и расхождения |
| `zettelkasten-validation` | Проверки и evidence, включая агентный слой |
| `zettelkasten-migration` | Планирование и проверка миграций; не неявный runtime apply |
| `zettelkasten-release` | Подготовка и выполнение явно порученного release workflow |

## 7. Manifest и общие контракты

### 7.1. Manifest

Manifest хранит минимум следующие поля:

| Поле | Контракт |
|---|---|
| `schema_version`, `package_version` | Версия формата и агентного пакета |
| `id`, `path`, `kind`, `layer` | Уникальный skill ID; relative path; `primitive/orchestrator/governance/development`; слой L1–L5 |
| `legacy_class`, `command` | Сохранённый `operational/meta` и точное CLI соответствие; у development отдельный класс; отсутствие command — `null` |
| `profiles`, `allowed_modes` | Какие профили и режимы могут применять процедуру |
| `triggers`, `negative_triggers` | Условия выбора и запреты на захват чужого запроса |
| `requires_skills`, `requires_contracts`, `requires_capabilities`, `requires_tools` | Явные зависимости, включая версию/совместимость там, где это существенно |
| `reads`, `writes` | Разрешённые области и типы побочных эффектов |
| `interaction_mode` | `read-only`, `noninteractive`, `interactive-only` или `gated`; не выводится из имени skill |
| `authorization`, `idempotency`, `validation` | Категория операции, правила повторов, обязательные проверки |
| `source_sha256`, `bundle_digest` | Хеш `SKILL.md` и digest полного относящегося к skill набора файлов |
| `source_provenance`, `legacy_detailed_note` | Откуда импортирована редакция; прежний Detailed Note UUID как историческая ссылка, если имеется |
| `status`, `introduced_by`, `superseded_by` | Состояние каталога и change traceability |

`imported`, `verified`, `deprecated` описывают исходник. Runtime-readiness вычисляется по конкретным профилю, environment, mode и dependencies; поле source status не выдаёт готовность к запуску.

Digest общего пакета учитывает stable relative paths, bytes и требуемые executable modes. Производные checksum-поля и deployment timestamps исключаются из собственного hash input. Изменение shared contract делает зависимые bundles устаревшими, даже если сам `SKILL.md` не менялся.

В первой дельте `Agents/manifest.json` становится источником integration data. `scripts/docs/managed-skills.adoc` сохраняется как производное человекочитаемое представление с указанием source, пока действующие consumers не мигрированы. Ручное независимое редактирование двух manifest запрещено.

### 7.2. Форма operation plan/result

Это внутренний контракт адаптера, а не утверждение о JSON-интерфейсе существующих `zt-*`.

| Поле | Назначение |
|---|---|
| `operation_id`, `request_key` | Идентификатор операции и, если есть, устойчивый ID исходного события |
| `profile`, `root_skill`, `dependency_chain` | Кто выполняет и какой workflow владеет операцией |
| `source_revision`, `package_digest`, `cli_revision` | Версии исполняемых правил и CLI |
| `roots`, `scope`, `source_fingerprints` | Разрешённые области, полный write set, версии затронутых файлов |
| `inputs`, `policy`, `topic_identity` | Явные решения о типах, bindings и предметном workflow |
| `expected_effects` | Новые документы, links, activity/state, изменения metadata |
| `status`, `validation`, `changed_paths`, `recovery` | Проверенный результат, доказательства и необходимость восстановления |

Общие статусы: `OK`, `NOT_FOUND`, `SPEC_CONFLICT`, `STATE_CONFLICT`, `VALIDATION_FAILED`, `RECOVERY_REQUIRED`; дополнительно для адаптера — `DEPENDENCY_UNAVAILABLE`, `INTERACTIVE_REQUIRED`, `LOCKED`. `SKIP` допустим только для явно необязательной проверки и не превращает невыполненный обязательный gate в `OK`.

## Requirements

Целевые требования и приёмочные сценарии.

Каждый `ASYS-*` ниже имеет исходный статус `ROADMAP` и одну owning capability, заданную в разделе 10. Сценарии описывают приёмку будущей реализации. Они не являются отчётом о выполненных тестах.

### Requirement: ASYS-001 — Канонический каталог в Agents

Проект MUST хранить все скиллы принятой поставки в `Agents/skills/<id>/SKILL.md`; каждый ID SHALL иметь ровно один редактируемый source. Локальный developer SHALL получать навигацию ко всем 41 исходным скиллам через repository entrypoint и каталог, без зависимости от личного workspace Марты.

#### Scenario: Чистый checkout

- **GIVEN** получен checkout принятой версии, внешний OpenClaw state отсутствует
- **WHEN** developer загружает repository instructions
- **THEN** он находит каталог и все 41 исходных скилла
- **AND** старый каталог `dev/skills/` не содержит второй редактируемой версии.

### Requirement: ASYS-002 — Проверяемое происхождение импорта

Импорт MUST сохранять ID, исходные hashes и происхождение каждого skill, явно фиксируя два hash mismatch и отсутствующую строку `delta-spec`. Несовпадающая редакция SHALL проходить содержательную проверку относительно baseline; unresolved conflict SHALL исключать затронутую операцию из готового runtime-профиля.

#### Scenario: Неизвестная старая редакция

- **GIVEN** hash RED skill отличается, старые байты недоступны
- **WHEN** выполняется импорт
- **THEN** отчёт содержит оба хеша, ограничение сравнения и принятое решение по предоставленной редакции
- **AND** система не заявляет, что сравнила недоступные исходные тексты.

### Requirement: ASYS-003 — Полный и непротиворечивый manifest

Manifest MUST покрывать каждый skill ровно один раз, сохранять 24 исходных one-to-one CLI mappings и отделять operational mappings от meta/development skills. Новые top-level `zt-*` SHALL получать mapping в той же дельте. Проверка MUST обнаруживать missing, duplicate, unknown path, hash drift и dependency cycle.

#### Scenario: Потерянный delta-spec

- **GIVEN** `zettelkasten-delta-spec/SKILL.md` есть в source, строки manifest нет
- **WHEN** выполняется проверка каталога
- **THEN** проверка завершается ошибкой с именем скилла
- **AND** добавление `command: null` для meta skill не требует фиктивного скрипта.

### Requirement: ASYS-004 — Самодостаточные процедурные ссылки

Каждый skill MUST ссылаться только на поставляемые contracts, проверяемые executable interfaces или явно объявленные внешние prerequisites. Работа с исходниками SHALL NOT требовать личного Detailed Note. `delta-spec` MUST использовать repo-local `zettelkasten-openspec-change`; внешний `openspec-delta-spec` может оставаться лишь необязательным источником дополнительных правил без второго normative authority.

#### Scenario: Нет старого workspace

- **GIVEN** каталог прежней Марты и внешний `openspec-delta-spec` отсутствуют
- **WHEN** developer готовит change
- **THEN** загружается repo-local change procedure
- **AND** если native CLI отсутствует, draft возможен, но native validation отмечается невыполненной.

### Requirement: ASYS-005 — Версия полного набора зависимостей

Каталог и deployment MUST идентифицировать полную версию skills и shared contracts, а не только SHA-256 `SKILL.md`. Несоответствие загруженных файлов заявленному digest SHALL блокировать ready-status затронутого профиля.

#### Scenario: Изменился только shared contract

- **GIVEN** документный контракт изменён, `SKILL.md` Memo не изменён
- **WHEN** проверяется прежняя deployment receipt
- **THEN** изменение зависимости обнаружено и требуется проверка новой поставки.

### Requirement: ASYS-006 — Разделённые роли

Developer и librarian MUST иметь разные профили. Обычная разработка SHALL писать только source/docs/tests и временный Vault; обычная библиотечная операция SHALL писать только разрешённый пользовательский scope. Переключение роли MUST NOT происходить как скрытый побочный эффект ошибки.

#### Scenario: Библиотекарь обнаружил баг

- **GIVEN** при Memo workflow выявлено противоречие CLI и baseline
- **WHEN** библиотекарь формирует результат
- **THEN** он сообщает `SPEC_CONFLICT` и воспроизводимый запрос на исправление
- **AND** не патчит `scripts/` и не расширяет права своего профиля.

### Requirement: ASYS-007 — Конфигурируемая идентичность

Новые документы библиотекаря MUST получать configured author и generated date в заданном часовом поясе. Исторические `:author: marta`, исходный текст и UUID SHALL сохраняться. В source profiles MUST NOT попадать персональные credentials и абсолютные пути конкретного пользователя.

#### Scenario: Замена Марты библиотекарем

- **GIVEN** в Vault есть Memo Марты, configured author равен `librarian`
- **WHEN** создаётся новая Memo
- **THEN** её author — `librarian`
- **AND** старые документы и их авторство не меняются.

### Requirement: ASYS-008 — Проверенные корни и версия CLI

Перед действием агент MUST разрешить source, Vault, Agents и требуемый external output root независимо, проверить containment и совместимость CLI. Отсутствие обязательного root SHALL завершать операцию до записи. Личные `$HOME` defaults SHALL NOT подменять явную runtime-конфигурацию библиотекаря.

#### Scenario: Раздельные CLI и Vault

- **GIVEN** CLI лежит в source checkout, Vault расположен отдельно
- **WHEN** запускается создание
- **THEN** все используемые helpers принадлежат одной проверенной версии CLI
- **AND** при неподдерживаемом разделении операция завершается до изменения Vault.

### Requirement: ASYS-009 — Авторизация по полному scope

Операция MUST иметь достаточное полномочие на свой полный write set. Намерение создать Memo SHALL покрывать заранее определённые canonical activity и backlinks. Массовая миграция, lifecycle apply и release SHALL требовать соответствующего operation-specific намерения; уже данное полномочие MUST NOT запрашиваться повторно без изменения scope.

#### Scenario: Одна Memo с двумя backlinks

- **GIVEN** пользователь поручил создание Memo, plan включает документ, activity и два backlinks
- **WHEN** plan прошёл проверки
- **THEN** workflow выполняется как одна операция без отдельных запросов на каждый файл
- **AND** найденная потребность архивировать ещё 200 Memo не добавляется в scope автоматически.

### Requirement: ASYS-010 — Честная readiness

Профиль MUST различать наличие skill, source validation, dependency eligibility, live discovery и проверенную готовность конкретного режима. Mutating skill без подтверждённого noninteractive path SHALL NOT маркироваться unattended-ready. Отсутствие prerequisite одной возможности SHALL NOT блокировать независимое чтение.

#### Scenario: Доступен только интерактивный Memo CLI

- **GIVEN** скилл установлен, CLI требует Vim/fzf/terminal
- **WHEN** библиотекарь без TTY запрашивает создание
- **THEN** результат — `INTERACTIVE_REQUIRED` либо `DEPENDENCY_UNAVAILABLE`, без частичной записи
- **AND** `read` и `find` остаются доступны.

### Requirement: ASYS-011 — Эффективная загрузка OpenClaw

Адаптер MUST обеспечивать обнаружение выбранных skills и доступность всех их references в реальном executor. Проверка SHALL устанавливать effective source каждого выбранного ID и выявлять shadowing. Наличие `Agents` или symlink само по себе SHALL NOT считаться успешным подключением.

#### Scenario: Старый скилл перекрывает новый

- **GIVEN** в workspace остался одноимённый `zettelkasten-memo`, новый пакет указан через extra directory
- **WHEN** выполняется integration check
- **THEN** отчёт показывает фактически выбранный старый источник
- **AND** новая установка не получает статус готовой.

### Requirement: ASYS-012 — Обновление без потери локальных правок

Deployment MUST иметь plan, staging, receipt, conflict detection и проверяемый rollback. Неизвестные или изменённые локальные файлы SHALL сохраняться. Активная сессия MUST использовать целостную версию skill/contracts; обновление на диске SHALL NOT выдаваться за обновление уже загруженной сессии.

#### Scenario: Локальная правка после установки

- **GIVEN** установленный skill отличается от receipt из-за локальной правки
- **WHEN** запрошено обновление
- **THEN** обнаруживается `STATE_CONFLICT`, исходная правка сохраняется
- **AND** автоматическое force-overwrite не выполняется.

### Requirement: ASYS-013 — Один root workflow

Router MUST определять один root workflow для каждого смыслового поручения и учитывать явный выбор пользователя, роль, negative triggers и приоритет специализации. Root workflow MAY применять другие skills как dependencies, но MUST владеть общим operation plan и исключать повторную обработку уже распределённых фрагментов.

#### Scenario: Утренние мысли содержат идею канала

- **GIVEN** пользователь передал утреннюю запись с одной идеей для канала
- **WHEN** выбран `morning-thoughts`
- **THEN** channel policy применяется к назначенному фрагменту внутри root plan
- **AND** независимые `theme-capture` и `capture-channel-topic` не создают дубли того же фрагмента.

### Requirement: ASYS-014 — Явные команды и negative triggers

Router MUST сохранять пользовательские ограничения на тип, запись, канал и scope. Простое упоминание предмета внутри читаемого документа SHALL NOT активировать mutating domain workflow. Неоднозначность SHALL разрешаться безопасным read-only разбором или конкретным вопросом, если от ответа зависит запись.

#### Scenario: Чтение RED Memo

- **GIVEN** запрос «прочитай это RED Memo»
- **WHEN** выбирается маршрут
- **THEN** запускается чтение
- **AND** новое событие RED и новая Memo не создаются.

### Requirement: ASYS-015 — Единая механика документов

Primitive document contracts MUST наследовать действующие UUID, filename, header, link, binding, deprecation и activity semantics CLI/OpenSpec. Domain skills SHALL задавать только содержание и разрешённые policy additions. Metadata parsing MUST ограничиваться настоящим header, не примером атрибута внутри body.

#### Scenario: В исходном тексте есть псевдоатрибут

- **GIVEN** захватываемый текст содержит пример `:deprecated:` в literal/source block
- **WHEN** создаётся Memo
- **THEN** пример остаётся данными, а Memo не становится deprecated.

### Requirement: ASYS-016 — Проверенный путь записи вместо ручного воспроизведения

Новый runtime profile MUST использовать детерминированный проверенный CLI/helper interface для постоянных файловых изменений. Интерактивный script SHALL запускаться только в подходящем режиме. Произвольное ручное воспроизведение его семантики LLM SHALL NOT служить unattended fallback. Минимальный адаптер допустим через дельту и тесты общих postconditions.

#### Scenario: Отсутствует поддержка no-edit

- **GIVEN** установленная версия не поддерживает согласованный noninteractive mode
- **WHEN** workflow пытается выполнить запись
- **THEN** он останавливается до записи и называет требуемую capability
- **AND** не подменяет её прямым созданием `.adoc` из prompt.

### Requirement: ASYS-017 — Предметные binding policies

Обычные и специальные bindings MUST разрешаться до записи через named policy. Начальная миграция SHALL сохранять OpenClaw Memo без Topic/`:key-topic:` и только с допустимыми Memo links, а OpenClaw Note — с обязательной активной Topic `Open Claw`. Имя runtime платформы MUST NOT автоматически выбирать предметную политику для всех заметок.

#### Scenario: OpenClaw — исполнитель, а тема Memo — SQL

- **GIVEN** библиотекарь работает в OpenClaw и создаёт Memo о SQL
- **WHEN** выбирается policy
- **THEN** применяется обычная предметная binding policy
- **AND** исключение OpenClaw Memo не выбирается только из-за платформы агента.

### Requirement: ASYS-018 — Обоснованные семантические связи

Relationship discovery MUST искать кандидатов по explicit links, exact Topic membership, keywords, title/description и содержанию с чтением кандидатов. Каждая дополнительная связь SHALL иметь понятное основание. Допускается ноль дополнительных связей; квота `2–5` SHALL NOT заставлять создавать слабые links. Обязательные структурные bindings и chain links считаются отдельно.

#### Scenario: Сильных совпадений нет

- **GIVEN** найдено пять заметок лишь с общим словом «система»
- **WHEN** оцениваются дополнительные связи
- **THEN** число добавленных семантических links равно нулю
- **AND** обязательный Topic binding, если он предусмотрен policy, сохраняется.

### Requirement: ASYS-019 — Роли Topic и защищённый lifecycle

Агентная policy MUST различать `semantic`, `workflow`, `channel`, `registry`, `system`, `index` и `unknown` для выбранной Topic identity. Первое введение роли SHALL использовать локальное отображение UUID → role без массового изменения `:key-topic:`. Библиотекарь MUST NOT выполнять broad Reduce для несемантической или неизвестной роли; он SHALL показать scope и требуемое решение.

#### Scenario: Reduce утренних мыслей

- **GIVEN** Topic «Утренние мысли» имеет роль `workflow` и содержит разнотематические Memo
- **WHEN** запрошен Reduce всей Topic
- **THEN** массовая deprecation не выполняется автоматически
- **AND** предлагается конкретный scope Refine/promote в semantic Topic без изменения происхождения материалов.

### Requirement: ASYS-020 — Единый write/recovery protocol

Многофайловая операция MUST использовать общий CLI transaction contract: полный план, staging/backups, проверка fingerprints, ограниченная блокировка согласованного scope, apply и postflight. Конфликт SHALL сохранять чужие изменения. После сбоя результат MUST различать полный rollback и `RECOVERY_REQUIRED`; recovery MUST NOT восстанавливать старую версию поверх чужой новой правки.

#### Scenario: Два writers обновляют один Topic

- **GIVEN** два процесса подготовили backlinks к одной версии Topic
- **WHEN** они применяют операции
- **THEN** записи сериализуются или один writer получает `LOCKED`/`STATE_CONFLICT`
- **AND** ни одна подтверждённая ссылка не теряется.

### Requirement: ASYS-021 — Полный postflight и честный результат

Workflow MUST проверять весь changed-file scope: документы, reciprocal links, activity, chain/state и формат. Обязательные rendering/integrity проверки SHALL выполняться в соответствии с capability; отсутствие инструмента MUST NOT считаться PASS. Pre-existing findings SHALL отделяться от новых дефектов; затронутые инварианты при этом не ослабляются.

#### Scenario: Новый документ корректен, backlink повреждён

- **GIVEN** Memo прошла локальную проверку, обратная ссылка в Topic некорректна
- **WHEN** выполняется postflight
- **THEN** общий результат не `OK`, применяется проверяемое восстановление или сообщается `RECOVERY_REQUIRED`
- **AND** пользователю не сообщается об успешном завершении всего workflow.

### Requirement: ASYS-022 — Повтор запроса без дублирования

Повтор доставки одного operation/request key MUST возвращать ранее подтверждённый результат либо продолжать явное recovery, не создавая новые документы и links. Ключ SHALL учитывать Vault, источник события и его устойчивую identity; одинаковые event IDs из разных источников не объединяются. Семантически похожий текст без устойчивого ключа SHALL NOT автоматически считаться тем же событием. Состояние незавершённой операции MUST проверяться до нового apply.

#### Scenario: Gateway повторил доставку

- **GIVEN** операция создания завершилась, ответ потерян, тот же event ID доставлен снова
- **WHEN** библиотекарь обрабатывает повтор
- **THEN** возвращаются прежние UUID и результат
- **AND** activity и backlinks не дублируются.

### Requirement: ASYS-023 — Единый weekly workflow

`weekly-new` и `weekly-new-memo` MUST применять одну процедуру selection, grouping, metadata, bindings, deduplication и validation. Отличается только режим ответа. Window SHALL иметь явные границы и timezone; источник — Git additions плюс новые untracked files, mtime — диагностируемый fallback. Exact Topic SHALL NOT подменяться случайной близкой темой.

#### Scenario: Один обзор в двух режимах

- **GIVEN** одинаковый snapshot, окно и сохранённый review body
- **WHEN** вызывается full либо memo-only alias
- **THEN** результат сохранения и UUID совпадают по idempotency policy
- **AND** full выводит тот же body, memo-only — краткий статус; второй Memo не создаётся.

Если обязательная weekly Topic отсутствует, workflow подготавливает draft и сообщает отсутствующий binding; создание новой Topic либо иная policy входит в явный plan. Эта унификация является изменением исходного поведения и принимается отдельной дельтой.

### Requirement: ASYS-024 — Утренние мысли как прослеживаемый capture

Morning workflow MUST сегментировать смысловые единицы, сохранять исходные фрагменты, различать атрибуцию и confidence, объединять повторы только внутри согласованного scope. Эмоциональность SHALL NOT служить единственным основанием priority. Перенос в semantic Topic SHALL сохранять source-workflow provenance.

#### Scenario: Два абзаца выражают одну мысль

- **GIVEN** одна идея повторена разными словами, а рядом есть независимая карьерная мысль
- **WHEN** выполняется capture
- **THEN** повтор объединён с сохранением provenance, карьерная мысль выделена отдельно
- **AND** оба результата прослеживаются к исходным фрагментам.

### Requirement: ASYS-025 — Явная политика каналов

Channel workflow MUST сохранять разные editorial lenses каналов и учитывать выбранный пользователем destination. Для отсутствующего канала начальная совместимая policy SHALL сохранять исходное создание двух вариантов; возможность `best-fit` или одного варианта добавляется только явной дельтой, с критериями выбора. Ни один вариант SHALL автоматически публиковаться.

#### Scenario: Указан один канал

- **GIVEN** пользователь просит сохранить идею только для «Демона Максвелла»
- **WHEN** выполняется capture
- **THEN** создаётся только согласованный вариант
- **AND** общая policy двух каналов не переопределяет слово «только».

### Requirement: ASYS-026 — Сохранение линейных RED-цепочек

RED workflow MUST сохранять identity `(red-kind, normalized red-category)`, exact Topic binding, взаимность previous/next, единственный хвост и проверяемый хронологический порядок. Синонимы SHALL NOT объединяться автоматически; middle insertion MUST быть общей транзакцией. Неоднозначность или повреждение chain SHALL останавливать запись.

#### Scenario: RED Trigger и RED Risk одной категории

- **GIVEN** существуют сообщения `RED Trigger: Переезд` и `RED Risk: Переезд`
- **WHEN** добавляется новый RED Risk той же нормализованной категории
- **THEN** продолжается только Risk chain
- **AND** исходный текст сохраняется без добавленных рисков, сроков или решений.

Если дата/время и порядок регистрации не позволяют однозначно выбрать позицию, требуется конкретное уточнение либо диагностика конфликта; «текущее время» не подменяет неизвестное время исходного события.

### Requirement: ASYS-027 — Статьи с границей источника и результата

Article workflow MUST читать разрешённые документы Vault и писать только в configured articles destination. Заголовок SHALL сохранять формулировку пользователя с допустимой нормализацией пробелов. Note/Topic обосновывают основную часть, Memo/Todo отделяются как планы; раздел планов, если он есть, SHALL оставаться последним содержательным разделом.

#### Scenario: Черновик уже существует

- **GIVEN** файл с выбранным именем есть, запрос не разрешает его обновление
- **WHEN** сохраняется новая статья
- **THEN** создаётся различимое новое имя по принятой naming policy
- **AND** исходные заметки, прежняя статья и настройки Obsidian не меняются.

### Requirement: ASYS-028 — Завершённый inbox promotion

Новый `zettelkasten-inbox-promote` MUST переводить явно выбранный staging item в подтверждённые Memo/Note/Todo либо состояние `discarded` с причиной. Он SHALL сохранять source identity/fingerprint, provenance и target UUID. Исходник SHALL NOT исчезать до успешного commit; `discarded` само по себе не означает физическое удаление. Повтор promotion MUST быть идемпотентным.

#### Scenario: Частичный сбой promotion

- **GIVEN** подготовлены два target documents из одного processed item
- **WHEN** вторая запись отказала
- **THEN** операция не помечает item успешно promoted
- **AND** исходник сохранён, результат соответствует общему recovery protocol.

Существующий `inbox-processed` сохраняет своё значение «staging обработан». Композиция inbox и document creation выполняется на host/orchestration layer; `inbox` plugin не начинает напрямую зависеть от sibling `zettelkasten` plugin.

### Requirement: ASYS-029 — Governance через repository source

Изменения skills MUST вноситься в канонический `Agents` source через соответствующий OpenSpec scope. `requirements`, `features`, `delta-spec`, review и release SHALL применять действующую иерархию источников. Detailed Notes MAY документировать изменения отдельной пользовательской операцией; обычная разработка MUST NOT создавать их в реальном Vault автоматически.

#### Scenario: Обновлена процедура Memo

- **GIVEN** developer реализовал принятую дельту skill contract
- **WHEN** завершается source update
- **THEN** обновлены skill, manifest, evidence и соответствующие specs/status
- **AND** отсутствие доступа к личным Detailed Notes не ломает source проверку и не вызывает запись в Vault.

Skill Workshop, если применяется в конкретной установке, служит источником предложений или поддерживаемым механизмом для его собственных runtime skills. Его результат не становится канонической версией репозиторных skills до review и интеграции в source. Старый governance меняется явно по stable IDs, перечисленным ниже.

### Requirement: ASYS-030 — Дельта как единица развития

Каждое observable изменение agent behavior, routing, policy, metadata semantics, прав, dependency или deployment MUST иметь ограниченный change scope, требования со scenarios, задачи и evidence. Реализация SHALL соответствовать активной дельте. Archive MUST сохранять change и синхронизировать принятую дельту в baseline после необходимых проверок; незавершённые этапы SHALL NOT маскироваться обновлением мастера.

#### Scenario: Найдено новое изменение поведения

- **GIVEN** при централизации weekly обнаружена потребность изменить роль Topic
- **WHEN** developer оценивает scope
- **THEN** он дополняет согласованные change artifacts или создаёт отдельную зависимую дельту
- **AND** не меняет schema/lifecycle попутно как редакторскую правку.

### Requirement: ASYS-031 — Проверки маршрутов и эффектов

Проверки agent subsystem MUST включать структуру, dependencies, positive/negative routing, действительные filesystem effects и профильные границы. Live routing SHALL фиксировать agent/model/runtime/version и повторяемые входы; статический тест матрицы MUST NOT выдаваться за проверку поведения LLM. Тесты записи SHALL использовать временный Vault.

#### Scenario: JSON routing test проходит, live route иной

- **GIVEN** статическая матрица валидна, live агент выбирает `theme-capture` вместо read-only `read`
- **WHEN** оценивается качество
- **THEN** structural check остаётся PASS, live routing — FAIL
- **AND** общий readiness для этого маршрута не считается подтверждённым.

### Requirement: ASYS-032 — Согласованная поставка и миграция

Публикация CLI MUST включать требуемый `Agents` source/package и документацию без локальных данных агента. Перенос paths и governance SHALL обновлять checker, publisher, tests, references и profile bootstrap в согласованном change. Старые пользовательские документы и установленные runtime skills MUST NOT удаляться как побочный эффект source migration.

#### Scenario: Проверка публикационного destination

- **GIVEN** подготовлена новая CLI поставка
- **WHEN** выполняется dry-run и проверка полученного дерева
- **THEN** `Agents`, его manifest и references доступны, старые `dev/skills/` references устранены
- **AND** credentials, sessions, memory и пользовательский Vault не включены в distribution.

## 9. Нормативная матрица маршрутизации

Порядок разрешения: полномочия и явные ограничения → явно названный skill/операция → developer intent → специализированный runtime workflow → общий capture. Для составного запроса root сначала составляет разбиение поручений. Ограничение «только прочитать» действует раньше любого предметного trigger.

| Запрос / контекст | Ожидаемый root | Исключённый независимый root |
|---|---|---|
| «Прочитай это Memo» | `read` | `memo`, `theme-capture` |
| «Найди заметки про OpenClaw» | `find` | `theme-capture`, special Memo creation |
| «Создай обычный Memo, без привязки к Topic» | `memo` с явным ограничением | `theme-capture`, automatic binding |
| «Зафиксируй эту тему» без типа и специализации | `theme-capture` | Независимый второй `memo` |
| Первая непустая строка `RED Trigger: ...` | `red-trigger-chain` | `theme-capture`, generic `continue-memo` |
| «Прочитай документ с заголовком RED Risk» | `read` | `red-trigger-chain` |
| «Разбери утренние мысли» | `morning-thoughts` | Параллельный capture всех фрагментов другими roots |
| Утренние мысли с channel idea | `morning-thoughts`, channel dependency | Второй top-level `capture-channel-topic` на тот же фрагмент |
| «Тема для Демона Максвелла» | `capture-channel-topic` | Generic capture |
| «Тема только для Сучьей Фабрики» | `capture-channel-topic`, один destination | Автоматическая вторая Memo |
| «Что нового за неделю?» | `weekly-new` | Второй weekly engine |
| «Сохрани weekly, в чат только ссылку» | `weekly-new-memo` | Полный вывод обзора |
| «Напиши черновик статьи на тему X» | `article-drafts` | Создание постоянной Note без поручения |
| «Добавь исходный текст во входящие» | `inbox-capture` | Promotion в постоянные документы |
| «Перемести во входящие обработанные» для точного item | `inbox-processed` | Автоматическое создание Memo |
| «Преврати этот processed item в Note» | `inbox-promote` после принятия дельты | Повторный независимый `note` |
| «Продолжи это Memo» | `continue-memo` | RED workflow без RED identity |
| «Reduce Topic “Утренние мысли”» | `reduce` preview + topic-role gate | Автоматическая deprecation всей линии |
| «Добавь дельтаспек в Zettelkasten» | `delta-spec` → developer OpenSpec procedure | Запись requirements Note или реализация CLI |
| «Проверь требования, ничего не меняй» | Developer review/OpenSpec analysis | `requirements` apply, feature update |
| «Почини CLI» | `development` | `scripts-patch` только на основании слова «почини» |
| «Добавь недостающий LF скриптам» | `scripts-patch` | Функциональный refactoring |
| «Подготовь выпуск» | `release` с dry-run | Неоговорённые apply/commit/tag/push |

Имена в этой таблице сокращены тем же префиксом `zettelkasten-`. Ограничения исходных `reduce/refine` на конкретный scope сохраняются. Детерминированный router policy задаёт ожидаемое поведение; его соблюдение LLM проверяется отдельно.

## 10. Capability ownership и изменения существующего baseline

### 10.1. Единственные владельцы новых требований

| Будущая capability | Зарезервированные IDs |
|---|---|
| `agent-catalog` | `ASYS-001`–`ASYS-005`, `ASYS-032` |
| `agent-profiles` | `ASYS-006`–`ASYS-010` |
| `agent-openclaw` | `ASYS-011`–`ASYS-012` |
| `agent-routing` | `ASYS-013`–`ASYS-014` |
| `agent-operations` | `ASYS-015`–`ASYS-019`, `ASYS-022` |
| `agent-write-protocol` | `ASYS-020`–`ASYS-021` |
| `agent-knowledge-workflows` | `ASYS-023`–`ASYS-028` |
| `agent-change-management` | `ASYS-029`–`ASYS-030` |
| `agent-quality` | `ASYS-031` |

Эти capability slugs пока являются целевой схемой. Они создаются по мере интеграции дельт, а не заранее объявляют всю подсистему работающей.

### 10.2. Существующие stable IDs, которые нельзя обойти новым каталогом

| Capability / IDs | Необходимая дельта |
|---|---|
| `agent-governance`: `AGENT-001`, `002`, `006` | Точки входа, маршрутизация, новый source path; сохранить краткость bootstrap |
| `AGENT-003` | Сохранить one-to-one mapping для top-level CLI и отделить domain/development skills |
| `AGENT-004`, `010` | Каноническая процедура хранится в repository `Agents`; runtime — выбранная версия |
| `AGENT-005`, `014` | Заменить обязательный внешний Workshop authoring для repo-owned skills на source change + проверенный deployment |
| `AGENT-007` | Сохранить обязательные части skill; добавить dependency/profile contracts |
| `AGENT-008`, `009` | Detailed Notes сохраняют историю, но не являются обязательной runtime/source dependency; новая Note-редакция — отдельная пользовательская операция |
| `AGENT-011` | Сохранить `.agent-skills/` историческим архивом, не включать в discovery |
| `AGENT-012`, `013` | Новый manifest, source/package/deployment checks; legacy manifest — производное представление |
| `AGENT-015` | Сохранить смысл OpenClaw exceptions; вынести в policy и убрать зависимость от имени агента |
| `development-agent`: `DEVAGENT-001`, `002` | Роль developer без персонального имени; `Agents/skills/`; разделение с librarian |
| `DEVAGENT-003`, `004`, `011` | Новый repository entrypoint, contracts и проверки нового packaging |
| `DEVAGENT-005`–`010`, `012` | Сохранить изменение через specs, data boundary, Git safety, migration/release authorization и ID/status checks |
| `spec-governance`: `SPEC-001`–`007` | Сохранить baseline authority, stable IDs и доказуемое `IMPLEMENTED` |
| `publication`, architecture и legacy publication IDs | Уточнить состав export, исключения и references после `dev/skills/` → `Agents/skills/`; конкретные ID выбрать из актуального baseline в дельте |

Тексты `MODIFIED Requirements` берутся целиком из актуального baseline и заменяются полной новой редакцией со scenarios. Существующие заголовки идентифицируются точно; stable IDs не переименовываются ради нового дизайна.

Новые ASYS IDs при переносе в baseline получают ровно одну запись в `scripts/docs/requirements.adoc` с тем же status. Это необходимо текущему checker: он проверяет соответствие **в обе стороны**, а не только наличие старых требований. Резервирование ID в proposed change не требует преждевременного объявления реализации в legacy/Feature List.

## 11. План дельта-спецификаций

Каждая строка — самостоятельный change с `proposal.md`, `specs/<capability>/spec.md`, при необходимости `design.md`, `tasks.md` и `verification.md`. Числовые обозначения `D01` и далее — последовательность мастер-плана; change ID используется без номера.

| Этап / change ID | Scope и требования | Зависимости | Проверяемый результат |
|---|---|---|---|
| D01 `add-repository-agents-catalog` | Импорт 34 + перенос семи; source authority; manifest/provenance; self-contained refs; baseline governance; `ASYS-001`–`005`, `029`, `030`, `032` | Исходные архивы и актуальный repository baseline | 41 source skill, 24 mappings, документированы три расхождения; refs/checker/publisher согласованы; Vault не менялся |
| D02 `define-librarian-profile-and-routing` | Профили, root bootstrap/case, автор, paths, declared permissions, routing; `ASYS-006`–`010`, `013`, `014` | D01 | Один source catalogue, разные роли; позитивные/негативные маршруты; полный write scope |
| D03 `centralize-agent-operation-contracts` | Document policies и relationships; устранение дублирования; проверенный noninteractive adapter; `ASYS-015`–`018` | D01–D02; нужные CLI capabilities из существующих changes | Примитивы и domain orchestration используют один документный контракт; нет handwritten LLM fallback |
| D04 `integrate-openclaw-agent-workspace` | Staging deployment, profile selection, effective discovery, session version и rollback; `ASYS-011`, `012` | D01–D02; D03 для mutating eligibility | Рабочий read-only профиль; mutating skills включаются только после своих gates |
| D05 `unify-weekly-review-skills` | Один weekly engine, два совместимых имени, window/dedup/Topic contract; `ASYS-023` | D03 и write gate D07 для unattended apply | Одинаковый saved body, различается только ответ; нет duplicated weekly Memo |
| D06 `add-agent-topic-role-policy` | Semantic/workflow/channel/registry roles, conservative Reduce, controlled promotion; `ASYS-019` | D02–D03; учитывать `clarify-topic-membership-contract` | Роли без массового изменения metadata; исключено broad Reduce служебных Topic |
| D07 `integrate-agent-write-protocol` | Привязка всех writers к общему CLI transaction/recovery/postflight; event idempotency; `ASYS-020`–`022` | D03; принятая и проверенная transaction capability | Проверены конфликты, failures, recovery и повтор доставки на временном Vault |
| D08 `normalize-librarian-domain-workflows` | Morning, channel, RED и article как composition; portability/provenance; `ASYS-024`–`027` | D03, D06; D07 для mutating workflows | Сохранены исходные предметные правила, отрицательные маршруты и output boundaries |
| D09 `add-inbox-promotion-workflow` | Новый skill, явные terminal states и provenance; `ASYS-028` | D03, D07 | `raw/processed → permanent/discarded`; rollback не теряет source; repeat не плодит UUID |
| D10 `add-agent-behavior-release-gates` | Сводная acceptance suite и live routing evidence; `ASYS-031` | Проверки добавляются с D01; итоговая проверка всех включаемых workflows | Отдельные structural/native/static/live/runtime статусы и readiness каждого профиля |

Строки не требуют строго линейной реализации: read-only deployment D04 возможен до полного write protocol. **Включение unattended writers зависит от D03 и D07**, даже если соответствующие SKILL.md уже импортированы. Multi-writer readiness не заявляется до проверки CLI transactions.

### 11.1. Существующие changes, которые надо переиспользовать

| Уже существующий change | Связь с агентной подсистемой |
|---|---|
| `add-zcreate-workflow` | Предлагает `--no-edit`, выбор типа и binding; кандидат на основной creation interface |
| `add-recoverable-workflow-transactions` | Владелец CLI transaction contract `TXN-*`; агентная дельта добавляет потребление и профильные сценарии, не второй engine |
| `unify-asciidoc-metadata-and-links` | Общий parser header/links; исключает разные разборы metadata в skills |
| `clarify-topic-membership-contract` | Exact key и неоднозначность Topic line; роли Topic не заменяют этот контракт |
| `strengthen-document-integrity-checks` | Integrity postflight и классификация findings |
| `validate-diary-and-memo-chains` | Общая chain validation; RED сохраняет собственные ограничения поверх неё |
| `fix-atomic-document-writes`, `fix-atomic-write-regressions` | Atomicity и известные регрессии; завершённость отдельных tasks не доказывает recoverable transaction целиком |
| `standardize-cli-preflight-and-selection` | Предварительные проверки и интерактивность |
| `add-runtime-regression-release-gates` | Общие CLI runtime release gates; D10 дополняет их agent behavior checks |
| `harden-publication-preflight`, `make-public-distribution-reproducible` | Безопасный и воспроизводимый export `Agents` |
| `add-openspec-archive-contract` | Архивирование завершённых changes с синхронизацией baseline |
| `add-knowledge-plugin`, `add-article-creation-mode` | Возможные изменения creation/knowledge ownership и статьи; перед затрагивающей их дельтой проверить пересечения |

Наличие этих каталогов не подтверждает implementation. В предоставленном snapshot многие содержат незавершённые tasks. Перед использованием dependency её состояние проверяется заново по baseline, коду и evidence. Если capability ещё не принята, зависимая задача получает `blocked` с конкретной причиной либо сужается до независимого read-only scope.

## 12. Рабочий цикл одной дельты

OpenSpec разделяет текущие specs и proposed changes; секции `ADDED`, `MODIFIED` и `REMOVED Requirements` задают, что добавляется, заменяется или удаляется при интеграции. Ниже — процесс проекта, уточняющий эту модель. [OpenSpec Concepts](https://github.com/Fission-AI/OpenSpec/blob/main/docs/concepts.md).

1. Прочитать действующий repository entrypoint, config, master scope, affected baseline, skills, CLI, tests, legacy IDs и незавершённые пересекающиеся changes.
2. Зафиксировать проблему, текущий и целевой контракт, non-goals, stable IDs, пользовательские эффекты, compatibility/migration impact и зависимости.
3. Создать change с ограниченным именем. Новое требование — `ADDED`; изменение существующего — `MODIFIED` с полным актуальным текстом; удаление — явное `REMOVED` с причиной и переходом. Один ID не добавляется повторно в нескольких capabilities.
4. В design описать source/runtime authority, пути, разрешение dependencies, write/recovery boundary, migration/rollback и существенные альтернативы.
5. Связать каждую задачу с requirement и scenario. Тестовый контекст проекта сохраняется: `tests_dir=tests`, `test_prefix=zt-`, `test_extension=.zsh`; конкретное имя теста фиксируется в tasks.
6. Проверить proposal/delta. `openspec validate <change-id> --strict` применяется, если поддерживается установленной CLI; отдельно выполняется project checker baseline. Структурная проверка baseline не доказывает валидность активной дельты.
7. При порученной реализации изменить только согласованный scope. Обнаруженный новый behavior gap сначала отразить в change artifacts.
8. Выполнить относящиеся к scope tests, package/deployment checks и `git diff --check`. Для новых untracked текстовых файлов отдельно проверить формат и окончания строк: обычный Git diff их не включает.
9. Записать в `verification.md` фактические команды, версии, exit codes, fixture scope, результаты scenarios, ограничения и нерешённые конфликты. Задачи отмечаются выполненными по evidence.
10. После завершения интегрировать delta в baseline, синхронно обновить legacy IDs/status и Feature List. Проверить baseline и его source traceability. Сохранить change в archive, обновить состояние этапа в master.
11. Если change влияет на runtime, отдельно выполнить разрешённый deployment и проверить effective profile. Source integration и установка — разные подтверждаемые события.

Native OpenSpec CLI обязателен для заявления о пройденной native validation и готовности к финальной интеграции по этому плану. Его отсутствие не препятствует подготовке draft, но результат записывается как `NOT_FOUND / native validation not run`. Нельзя заменять это утверждением «локальный regex checker равнозначен OpenSpec».

В исходных repository checkers используется `rg`. Новые/изменяемые агентные инструменты должны иметь проверенный путь работы в целевой среде без обязательного `rg`: выбор файлов через glob, при необходимости `find`, затем `grep`/`awk` по ограниченному набору. Для неизменённых checkers фиксируется фактическая зависимость; их запуск без неё не объявляется успешным. Переносимость не достигается молчаливым пропуском gate.

## 13. Конкретный scope первой дельты

Change ID: **`add-repository-agents-catalog`**. Цель — получить проверяемую source-поставку всех 41 скилла и устранить противоречие между repo-owned source и старым external-only governance.

| Артефакт | Обязательное содержание |
|---|---|
| `proposal.md` | Почему внешний runtime source больше не соответствует модели; импорт 34 + перенос семи; три расхождения; no user-data migration |
| `specs/agent-catalog/spec.md` | `ADDED` для `ASYS-001`–`005`, `ASYS-032` |
| `specs/agent-change-management/spec.md` | `ADDED` для `ASYS-029`, `ASYS-030` |
| `specs/agent-governance/spec.md` | `MODIFIED` затронутых `AGENT-*`: source authority, manifest, Workshop, Detailed Notes |
| `specs/development-agent/spec.md` | `MODIFIED` путей/процедур `DEVAGENT-*`, необходимых переносу семи скиллов |
| При необходимости affected publication/architecture specs | Полные `MODIFIED` действующих требований к distribution и references |
| `design.md` | Канонический source, legacy manifest projection, import provenance, compatibility consumers, отсутствие автоматической runtime активации |
| `tasks.md` | Импортный inventory, перенос, адаптация source refs, manifest/schema, checker/publisher/tests, spec/status sync, verification |
| `verification.md` | Проверенные counts, mappings, hashes, dependencies, source boundaries и ограничения |

При импорте исходные скиллы не выдаются за уже готовые к unattended use. Изменения путей, источников истины и self-contained references фиксируются в D01. Более глубокое изменение механики, routing, policy, weekly и transactions остаётся в соответствующих последующих дельтах.

Если D01 публикует совместимый исходный skill, который ещё допускает старое ручное воспроизведение CLI, его manifest отмечает это ограничение; librarian mutating profile до D03/D07 его не включает. Таким образом импорт не превращается в скрытое разрешение небезопасного fallback и не требует переписать все workflow одним изменением.

## 14. Приёмка и доказательства

| Контур | Что проверять | Что не является достаточным доказательством |
|---|---|---|
| Structural | ID/path/frontmatter/schema, dependencies, single ownership, 41 initial skills, 24 CLI mappings | Наличие 41 каталога без чтения manifest и references |
| Source consistency | Hashes полного bundle; исключения импорта; legacy/source agreement | Обновлённый SHA без содержательной проверки конфликтов |
| Specification | Native OpenSpec + project legacy ID/status checker + scope review | Только наличие `MUST` и одного Scenario |
| Routing static | Все positive/negative rows и dependencies root workflow | Сравнение двух одинаково захардкоженных словарей |
| Routing live | Реальный профиль, версия runtime/model, read-only trial, выбранные root/dependencies | Ответ модели с ожидаемым названием без проверки выбранного пути/эффектов |
| Runtime effects | Temporary Vault до/после; UUID/header/links/activity/chain; output boundary | Один успешный happy path создания файла |
| Recovery | Fault injection между writes, stale fingerprints, retry, interrupted transaction | Только atomic rename одного файла |
| Deployment | Source receipt → staged bundle → effective origin → fresh session | Успех copy или список файлов на диске |
| Compatibility | macOS/Linux, case-sensitive paths, spaces/Cyrillic, no-TTY, legacy names | Проверка только одного личного пути на macOS |
| Publication | Состав export, refs, исключение runtime state и личных данных | Наличие папки `Agents` в source checkout |

Обязательные негативные сценарии соответствующих этапов: неправильный Vault root; отсутствующая Topic; deprecated target; неоднозначная Topic line; отсутствующий helper; выход через symlink; старый skill перекрывает новый; чужая правка Topic после plan; отказ второго write; отказ rollback; повтор event ID; два RED tails; неизвестная chronology; запрос read-only с domain keywords; попытка библиотекаря изменить source repository.

Критерии завершения всей программы:

- Все 34 исходных скилла и семь development skills представлены в source catalog либо имеют явно принятую запись о замене/совместимом alias.
- Старые личные paths и обязательные внешние skill references устранены из исполняемых процедур; исторические evidence могут сохранять их как данные.
- Библиотекарь обнаруживает выбранную проверенную версию, а developer видит весь source catalogue.
- Общие contracts имеют единственного владельца; domain skills применяют их через declared dependencies.
- Все включённые mutating workflows используют проверенный noninteractive path и общий recovery protocol.
- Weekly aliases совместимы; Topic roles защищают служебные линии; inbox promotion завершает staging lifecycle.
- Требования, код, tests, manifest, legacy status и Feature List согласованы; required failures отсутствуют.
- Source, deployment и live readiness имеют отдельные evidence; отсутствующие инструменты или live environment перечислены, а соответствующая готовность не заявлена.

## 15. Решения и отложенные изменения

| Решение | Принятая позиция |
|---|---|
| Кто заменяет Марту | Runtime-библиотекарь OpenClaw; developer становится неперсонализированной ролью |
| Где хранятся skills | Канонически только `Agents/skills`; runtime получает проверенную версию |
| Один или несколько наборов файлов | Один catalogue, профильные представления; не два независимо развиваемых дерева |
| Что делать с Detailed Notes | Сохранить историю; сделать необязательной для source/runtime выполнения через явное изменение governance |
| Что делать со Skill Workshop | Учитывать в поддерживаемом adapter scope; repo-owned изменения сначала принимаются в Git/OpenSpec source |
| Нужно ли сразу объединять weekly names | Нет: сохранить оба имени как режимы одной процедуры |
| Менять ли `:key-topic:` всем заметкам | Нет: сначала агентные роли и явный lifecycle; storage migration — отдельная дельта |
| OpenClaw Memo исключения | Сохранить как предметную policy, не применять ко всем заметкам библиотекаря |
| Неуказанный канал | Начально сохранить два варианта; best-fit — отдельное изменение, не молчаливый «оптимизатор» |
| Semantic linking | Ноль дополнительных links допустим; обязательные bindings проверяются отдельно |
| Embeddings / vector DB | Не требуются; lexical candidates + чтение + обоснованная моделью оценка |
| Одновременные writers | Только через общий CLI transaction contract; наличие нескольких агентов не доказывает безопасность |
| Когда править master | После каждой принятой дельты: состояние, связи, evidence; не переписывать им факт реализации |

## 16. Задание локальному агенту для начала работы

> Прочитай `openspec/master/agents-master-spec.md`, действующий repository entrypoint, `openspec/config.yaml`, связанные baseline capabilities и repo-local `zettelkasten-openspec-change`. Подготовь change `add-repository-agents-catalog` по разделу 13. Используй 34 исходных скилла из `Archive.zip` и семь development skills текущего репозитория. Проверь два несовпадения SHA-256 и отсутствие `zettelkasten-delta-spec` в legacy manifest; сохрани provenance и не объявляй неизвестный старый diff восстановленным. Целевой source — `Agents/skills`; OpenSpec baseline меняется только при проверенной интеграции дельты. На этом шаге подготовь proposal, delta specs, design, tasks и отчёт validation. Не считай создание дельты поручением реализовать CLI, менять пользовательский Vault, активировать OpenClaw или архивировать change. Укажи конкретные blockers и следующий выполнимый шаг.

Этот стартовый scope готовит первую дельту. Если пользователь в том же поручении явно просит реализовать её или выполнить deployment, соответствующее уже данное полномочие учитывается без повторного запроса; остальные инварианты и необходимые проверки сохраняются.
