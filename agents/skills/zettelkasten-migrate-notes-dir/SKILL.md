---
name: "zettelkasten-migrate-notes-dir"
description: "Безопасно мигрирует UUID core documents в notes/ через dry-run и rollback."
---

# Zettelkasten Migrate Notes Directory

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a40d81a-a0c6-11f1-8e56-5304bffd7df5.adoc`.

Использовать только по явному запросу на миграцию документов ядра из корня в `notes/`.

## Источники

- `.scripts/zt-migrate-notes-dir.zsh`
- `.scripts/lib/paths.zsh`
- `.scripts/lib/asciidoc.zsh`
- `.scripts/docs/notes-directory-migration.adoc`
- требования `PATH-001`–`PATH-011`

## Процедура

1. Запустить `.scripts/zt-migrate-notes-dir.zsh --dry-run`.
2. Проверить количество документов и индексных файлов, коллизии и точный scope типов note, memo, todo, diary, topic.
3. Перед `--apply` потребовать чистое Git-дерево.
4. Не переносить repository-level документы.
5. Запустить `--apply`; не обходить встроенный backup/rollback.
6. Проверить, что внутренние ссылки остались `link:UUID.adoc[]`, а all-todays/Workspace используют `../notes/UUID.adoc`.
7. Запустить полный `.scripts/zt-check.zsh`, `zsh -n` и `git diff --check`.
8. Убедиться, что повторный dry-run показывает ноль документов.

Не запускать apply при неясном scope, коллизиях или грязном Git-дереве.
