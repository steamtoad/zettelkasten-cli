## MODIFIED Requirements

### Requirement: CHECK-013 — после создания или изменения документов агент запускает scripts/zt-check.zsh

**Legacy status:** `PROCESS`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверки`.

Development, migration или runtime process MUST соблюдать следующее правило: после создания или изменения документов агент запускает `scripts/zt-check.zsh`.

#### Scenario: Validation command resolves after rename

- **WHEN** a document-changing workflow completes
- **THEN** it invokes `scripts/zt-check.zsh`, and the old `.scripts/zt-check.zsh` path is not required

#### Scenario: CHECK-013 contract is verified

- **GIVEN** выполняется изменение, проверка или операция, к которой относится это process requirement
- **WHEN** workflow достигает соответствующего шага
- **THEN** указанное process rule SHALL быть выполнено
- **AND** его обход SHALL считаться нарушением project contract

### Requirement: CHECK-023 — runtime core проверяется на временном Zettelkasten

**Legacy status:** `IMPLEMENTED`.
**Traceability:** `scripts/docs/requirements.adoc` → section `Проверки`.

Repository regression suite MUST на временном `ZK_HOME` проверять canonical constructors и `scripts/zt-check.zsh`; пользовательский Vault SHALL оставаться неизменным.

#### Scenario: Relocated runtime passes temporary-vault regression

- **GIVEN** создан новый временный `ZK_HOME`
- **WHEN** regression suite invokes relocated constructors and checker
- **THEN** valid fixtures pass, broken links fail, and the working Vault is unchanged

#### Scenario: Runtime constructors and checker are exercised without user data

- **GIVEN** создан новый временный Zettelkasten
- **WHEN** runtime core integration test создаёт canonical persistent object types и запускает `scripts/zt-check.zsh`
- **THEN** корректный fixture SHALL пройти validation
- **AND** broken link SHALL привести к validation failure
- **AND** пользовательский Vault SHALL оставаться неизменным
