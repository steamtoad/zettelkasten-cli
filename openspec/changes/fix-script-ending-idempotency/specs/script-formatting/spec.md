## ADDED Requirements

### Requirement: SCRIPT-FORMAT-001 — Проверка формата отделена от исправления

**Stable ID:** зарезервирован этой дельтой; legacy запись добавляется при проверенной интеграции.

**Статус изменения:** `PROPOSED`, не подтверждение реализации.

zt-scripts-patch --check MUST работать read-only, выдавать список файлов без LF и ненулевой exit при проблемах. Пустые файлы SHALL диагностироваться отдельно; write failures в fix-режиме SHALL возвращать ошибку.

#### Scenario: Read-only lint

- **GIVEN** есть файл без LF и пустой файл
- **WHEN** вызван --check
- **THEN** оба диагностированы, хеши и размеры неизменны

#### Scenario: Write failure

- **GIVEN** fixer не может дописать LF
- **WHEN** запущено исправление
- **THEN** ненулевой exit, нет ложного patched для неуспешного файла
