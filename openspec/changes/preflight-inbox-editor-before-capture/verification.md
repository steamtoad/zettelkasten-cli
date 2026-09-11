# Verification: preflight-inbox-editor-before-capture

## Regression evidence

До implementation новые negative fixtures воспроизводили дефект:

- `tests/zt-inbox-as-plugin.zsh` завершался ошибкой, потому что missing editor создавал дополнительный raw-файл.
- `tests/zt-plugin-edge-cases.zsh` завершался ошибкой в `editor_preflight`, потому что явно пустой `EDITOR` подменялся на `vim` и capture возвращал success.

После implementation:

- `zsh -n scripts/inbox/capture.zsh scripts/zt-inbox.zsh` — PASS.
- `tests/zt-inbox-as-plugin.zsh` — PASS.
- `tests/zt-plugin-edge-cases.zsh` — PASS, 14/14; подтверждены empty/missing/unset/quoted editor, Unicode path, collisions и другие Inbox/plugin regressions.
- `tests/zt-all.zsh` — PASS; live Marta routing отмечен самой suite как `SKIP`, так как `ZK_RUN_LIVE_ROUTING=1` не задан. Ожидаемые fault-injection diagnostics и sandbox warning `nice(5) failed: operation not permitted` не изменили успешный exit suite.

## Contract and repository checks

- `openspec validate --all --strict` — PASS, 65 items.
- `dev/scripts/zt-openspec-check.zsh` — PASS, 347 legacy requirements exactly once.
- `dev/scripts/zt-agent-skills-check.zsh` — PASS, 7 skills.
- `dev/scripts/zt-plugin-boundaries-check.zsh` — PASS, 49 local dependencies.
- `git diff --check` — PASS.
- `shellcheck scripts/inbox/capture.zsh` — SKIP: installed ShellCheck reports `SC1071`, because it does not support the `/bin/zsh` shebang; Zsh syntax is covered by `zsh -n`.

## Scope and archive readiness

Tests operated only on disposable temporary `ZK_HOME` fixtures. This change performed no real-Vault mutation, migration, commit, tag, push or archive.

`standardize-cli-preflight-and-selection` still needs a separate planning update to declare this completed `INBOX-008` contract as its dependency before that change is applied.
