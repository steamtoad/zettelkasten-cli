# Повторная проверка выполненных REFACTOR-дельт

Дата: 2026-09-06. Проверены `refactor-diary-as-plugin`, `refactor-inbox-as-plugin`, `refactor-workspace-as-plugin` и согласованность их baseline/legacy requirements. Пользовательские данные не использовались: все runtime операции выполнялись в disposable fixtures.

## Результат

Прежний `tests/zt-all.zsh` проходил до исправлений. Расширенная проверка первоначально обнаружила failures в 10 из 12 сценариев; отдельная последующая инъекция ошибки записи metadata также выявила дефект. После исправлений проходят все **13/13 edge scenarios**, три прежних plugin suites и общий runner. Это уточняет прежнее заключение: исходные тесты доказывали сохранение выбранных сценариев при переносе, но не полноту обработки ошибок.

## Исправленные дефекты

| Область | Воспроизведённая ошибка | Исправление и проверка |
|---|---|---|
| Inbox / INBOX-007 | `sysopen` системного zsh не открывал Unicode полный путь | Резервирование ASCII basename в subshell с cwd=raw; Unicode capture и processed проходят |
| Inbox / INBOX-007 | Dangling symlink на timestamp basename прерывал capture | Symlink считается занятой записью; 8 конкурентных capture получают уникальные имена без изменения entry |
| Inbox / INBOX-007 | Ошибка промежуточной записи metadata скрывалась успешным последним print | Проверка каждого write, удаление неполного raw, ненулевой exit, editor не запускается |
| Inbox / INBOX-008 | Quoted executable path и аргументы передавались с лишними кавычками | Lexical unquoting без eval; проверены пробелы, пустой аргумент и literal command substitution |
| Inbox / INBOX-009 | Symlink на соседний raw приводил к перемещению target и dangling alias | Symlink leaf отклоняется до physical resolution; source и alias сохраняются |
| Inbox / INBOX-010 | `ln` записывал внутрь directory/symlink destination и затем удалял raw | POSIX `link` резервирует точное имя; directory, symlink и конкурентное создание каталога отклоняются без вложенных файлов |
| Workspace / WORKSPACE-012 | Вместе с выбранной ссылкой удалялись соседние ссылки и ручной текст | Удаляется только выбранный macro; непустая строка и code examples сохраняются; inline links также обрабатываются |
| Workspace / WORKSPACE-013 | TMPDIR мог находиться на другом filesystem; ошибка mv оставляла staging | Temp создаётся рядом с Workspace, cleanup выполняется при выходе, mode 0640 и исходные bytes сохраняются при отказе |
| Boundaries / ARCH-016 | `source` внутри command substitution/compound statement пропускался; relative path считался file-relative | Статический разбор substitutions/compound segments; неподтверждённые relative dependencies отклоняются; literal examples разрешены |

Diary повторно проверен с Unicode Vault path, существующим today с записью Note, previous/next links, invalid state, UUID/metadata, отказами до продвижения state и отказом записи state. Новых ошибок в этих сценариях не выявлено; runtime Diary и neutral constructors не изменялись.

## Проверки

- `tests/zt-all.zsh`: PASS, включая 3 plugin suites, 13 edge scenarios, constructors/zt-check, boundary, coverage и publication checks.
- `.scripts/dev/zt-plugin-boundaries-check.zsh`: PASS, 47 локальных зависимостей.
- `.scripts/dev/zt-openspec-check.zsh`: PASS, 331 stable requirement с exact-once coverage и status parity.
- `openspec validate --all --strict --json --no-interactive`: PASS, 62/62 объектов (25 changes, 37 capabilities).
- `zsh -n`: PASS для shell sources/tests.
- `asciidoctor --failure-level WARN`: PASS для 7 затронутых AsciiDoc документов.
- `git diff --check` и проверка whitespace новых файлов: PASS.

Среда: macOS, системный `/bin/zsh`. ShellCheck не запускается с подменой dialect: Zsh не поддерживается этим анализатором. Live Marta routing штатно SKIP без `ZK_RUN_LIVE_ROUTING=1`. Linux runtime/Docker/Podman недоступны, поэтому отдельный Linux прогон не заявляется. POSIX `link` проверен в локальной среде; внешние editor/fzf/UUID/date моделируются в edge fixtures, нейтральные конструкторы отдельно проверяет runtime-core.

## Границы изменения

Исправления имеют отдельные proposal/design/delta specs/tasks. Старые refactor changes остаются для review; общие изменения ARCH-016 согласованы, чтобы последующая синхронизация не потеряла новые правила. Не реализованы import, миграция данных, полный transaction framework или иные audit roadmap changes. Публичные entrypoints, managed mappings и layout Vault сохранены. Коммит, release и изменение пользовательских документов не выполнялись.

## Архивирование, 2026-09-06

По явному запросу пользователя change перенесён в архив после завершения всех задач и проверки соответствия мастер-спецификациям. Предыдущие разделы сохраняют историю реализации и проверки. Итоговая сверка: [реестр архивирования](../../../archive-2026-09-06.md).
