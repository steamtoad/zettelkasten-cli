---
name: "zettelkasten-publish-cli-version"
description: "Публикует только публичные CLI-артефакты через dry-run и явный apply."
---

# Zettelkasten Publish CLI Version

Repository: `/Users/steamtoad/zettelkasten`.
Detailed reference: `/Users/steamtoad/zettelkasten/notes/4a4140b6-a0c6-11f1-8f48-0bc5de6e398f.adoc`.

Использовать при явном запросе на публикацию текущих scripts и корневых артефактов в открытый CLI-репозиторий.

## Источники

- `.scripts/zt-develop-publish-version.zsh`
- source `ZK_DEV_HOME`
- destination `ZK_PUBLISH_HOME`

## Процедура

1. Проверить source и destination, а также наличие `.scripts/`, `LICENSE`, `README.MD`, `.gitignore`.
2. Сначала запустить скрипт с `--dry-run`.
3. Просмотреть полный rsync plan и убедиться, что destination выбран правильно.
4. Перед `--apply` проверить syntax, документацию и `.scripts/zt-check.zsh`.
5. Запускать `--apply` только по явному запросу пользователя.
6. После копирования сравнить source/destination для опубликованного scope и проверить Git status обоих репозиториев.

Не считать копирование commit, push или release; эти внешние действия требуют отдельного запроса.
