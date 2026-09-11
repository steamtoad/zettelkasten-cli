# Verification: clarify-topic-membership-contract

## Scope and baseline

Проверены DATA-004, TOPIC-001, BIND-003, REDUCE-003/006/008, DEPR-008 и REFINE-011. Реализация сохраняет выборку Reduce по точному header `:key-topic:`, не нормализует несколько active Topic и не изменяет пользовательский Vault: все runtime fixtures используют временный `ZK_HOME`.

## Primary scenarios

`tests/zt-clarify-topic-membership-contract.zsh` — PASS.

- Memo того же ключа без прямой ссылки входит в Reduce preview и архивируется; Note того же ключа связывается с successor и не архивируется.
- Sibling Topic остаётся active; checker выводит `AMBIGUOUS_TOPIC_LINE` с UUID всех active candidates без ненулевого exit.
- Cancel Reduce сохраняет hashes и file set; activity не создаётся.
- Reduce provenance `Основано на`/`Развитие` принимается checker; старая прямая ссылка к deprecated Topic получает warning и остаётся неизменной.
- Новый library-level binding к deprecated Topic возвращает `DEPRECATED_TOPIC_TARGET` до mutation.
- Refine preview показывает unselected Note и архивирует её при archive-source; Memo binding переносит key только из header, не из title.

## Regression and static checks

- `tests/zt-fix-atomic-write-regressions.zsh` — PASS.
- `tests/zt-standardize-cli-preflight-and-selection.zsh` — PASS.
- `tests/zt-all.zsh` — PASS.
- `zsh -n` изменённых Zsh и primary suite — PASS.
- `openspec validate --all --strict` — PASS, 67 items.
- `dev/scripts/zt-openspec-check.zsh` — PASS, 358 legacy requirements exactly once.
- `dev/scripts/zt-plugin-boundaries-check.zsh` — PASS, 62 dependencies.
- `git diff --check` — PASS.

## Portability and safety

macOS ACL negative fixture выполнился как PASS. Linux-only environment отсутствует: Linux runtime integration отмечен как SKIP, а не PASS. ShellCheck не является доступной семантически применимой проверкой для Zsh в данном окружении. Commit, tag, push, archive change и операции с реальным Vault не выполнялись.
