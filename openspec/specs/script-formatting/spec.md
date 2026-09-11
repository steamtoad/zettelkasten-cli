# script-formatting Specification

## Purpose

Отделить read-only проверку формата shell-файлов от идемпотентного исправления завершающего LF.

## Requirements

### Requirement: SCRIPT-FORMAT-001 — Проверка формата отделена от исправления

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `.scripts/docs/requirements.adoc` → section `Проверки`.

`zt-scripts-patch --check` MUST работать read-only, выдавать список файлов без LF и ненулевой exit при проблемах. Пустые файлы SHALL диагностироваться отдельно; write failures в fix-режиме SHALL возвращать ошибку.

#### Scenario: Read-only lint

- **GIVEN** есть файл без LF и пустой файл
- **WHEN** вызван `--check`
- **THEN** оба диагностированы, хеши и размеры неизменны

#### Scenario: Write failure

- **GIVEN** fixer не может дописать LF
- **WHEN** запущено исправление
- **THEN** ненулевой exit, нет ложного `patched` для неуспешного файла
