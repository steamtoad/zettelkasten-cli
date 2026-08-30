---
name: "zettelkasten-system-review"
description: "Audit Zettelkasten-CLI maturity, architecture, requirement coverage, workflow gaps, and refactoring priorities."
---

# Zettelkasten System Review

## Workspace resolution

Resolve the repository through the common development contract.

## Contract loading

Load the common contract and only then inspect the OpenSpec capability map, Feature List, plugin contract, source tree, tests and known roadmap items.

## Normative scope

Common: `SPEC-001..007`, `DOC-001..009`, `DATA-001..004`, `PATH-001..011`, `ARCH-001..019`, `FLOW-001..008`, `AGENT-001..015`, `DEVAGENT-001..012`, `ROADMAP-001..004`, `ZP-ARCH-001..005`, `ZP-COMPAT-001..003`.

Authorization: L0.

## Workflow

1. Build the current architecture map from source, not from README assumptions.
2. Compare OpenSpec baseline, legacy status, Feature List and executable behavior for drift.
3. Evaluate data model, document types, workflows, dependency boundaries and user-data safety.
4. Identify bottlenecks and duplicated responsibilities.
5. Separate recommendations into Level 1 patch, Level 2 refactoring, Level 3 system improvement and Level 4 architecture.
6. Score each major recommendation by immediate value, compatibility, and future-architecture value.
7. Propose the next scripts/specs/tests to build and explicitly list what should not be touched yet.
8. Do not modify repository or user data.

This skill is strictly read-only.
