# Проверка refactor-inbox-as-plugin

Реализация и проверка: 2026-09-06. Scope: перенос владения кодом внутри текущего repository с сохранением observable behavior.

Проверены пустой/многострочный title, stderr usage, capture metadata, timestamp collision, аргументы и exit status editor, прежний момент проверки отсутствующего editor, приоритет путей и fallback без переменных. Для processed проверены basename/absolute input, внешние/вложенные/symlink targets, коллизия назначения, ошибки hard link и удаления raw, cleanup destination, сохранение содержимого. Import и регистрация в all-todays не добавлены.

До переноса behavioral часть `tests/zt-inbox-as-plugin.zsh --behavior-only` прошла на исходной реализации. Structural assertions отклонили исходную архитектуру. После переноса полный тест проходит через top-level entrypoints, включая точное forwarding аргументов, stdout/stderr, exit 37 и прежний managed skill mapping. Все операции выполняются в disposable fixtures.

Проверки общей реализации:

- `zsh -n` для Zsh sources и tests — PASS.
- `tests/zt-inbox-as-plugin.zsh` — PASS.
- `tests/zt-runtime-core.zsh` — PASS в составе общего runner.
- `.scripts/dev/zt-plugin-boundaries-check.zsh` — PASS, 47 локальных зависимостей.
- `tests/zt-plugin-boundaries.zsh` — PASS, positive и negative fixtures для запрещённых направлений.
- `.scripts/dev/zt-openspec-check.zsh` — PASS: 331 stable legacy requirements, exact-once coverage и совпадение статусов в пяти sources.
- `tests/zt-openspec-coverage.zsh` — PASS, включая negative fixtures новых plugin sources.
- `tests/zt-all.zsh` — PASS; live Marta routing штатно SKIP без `ZK_RUN_LIVE_ROUTING=1`.
- `openspec validate refactor-inbox-as-plugin --strict --no-interactive` — PASS.
- `openspec validate --all --strict --json --no-interactive` — PASS: 24 changes и 37 baseline capabilities, без failures.
- `git diff --check` — PASS.

Stable IDs сохранены, требования и features перенесены к соответствующему владельцу. Общий `ARCH-016` согласован между Diary/Workspace deltas и baseline с учётом Inbox: sibling plugins не зависят друг от друга. Задачи выполнены; change оставлен в `changes/` для review, без автоматического archive.

Отдельное существующее ограничение окружения: системный `/bin/zsh` на проверяемом Mac воспроизводит ошибку `sysopen` для пути `Хранилище с пробелами` даже в минимальном примере до переноса кода. Рефакторинг не устраняет её. Regression fixtures используют путь с пробелами и проверяют Unicode в пользовательских значениях; переносимость Unicode пути не заявляется доказанной. Полный transactional rollback и остальные audit fixes остаются отдельными changes.

## Повторная проверка и исправления, 2026-09-06

Первоначальный отчёт выше описывает состояние механического переноса. Последующая
проверка по запросу пользователя расширена `tests/zt-plugin-edge-cases.zsh`.
Выявленные defects исправляются отдельным change
[fix-plugin-regression-edge-cases](../2026-09-06-fix-plugin-regression-edge-cases/verification.md).
Указанное выше ограничение Inbox на Unicode путь устранено; контроль ошибки
metadata write и editor quoting усилен. Workspace сохраняет соседние macros и
ручной текст, staging и cleanup исправлены. Diary и прежние публичные команды
повторно проверяются на временном Vault.

## Архивирование, 2026-09-06

По явному запросу пользователя change перенесён в архив после завершения всех задач и проверки соответствия мастер-спецификациям. Предыдущие разделы сохраняют историю реализации и проверки. Итоговая сверка: [реестр архивирования](../../../archive-2026-09-06.md).
