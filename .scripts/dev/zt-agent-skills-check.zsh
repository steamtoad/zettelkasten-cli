#!/bin/zsh

#------------------------------------------------------------------------------
# zt-agent-skills-check.zsh
# Тип: Development Check
# Назначение: проверить packaging, contracts, authorization и OpenSpec references skills Marta
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

script_dir="${0:A:h}"
repo_root="${script_dir:h:h}"
skills_dir="${ZK_DEV_SKILLS_DIR:-${repo_root}/skills}"
contract_dir="${ZK_DEV_CONTRACT_DIR:-${script_dir}/docs/skill-contracts}"
openspec_dir="${ZK_OPEN_SPEC_DIR:-${repo_root}/openspec/specs}"
source_contract="${contract_dir}/zettelkasten-development-contract-v1.md"
source_authorization="${contract_dir}/skill-authorization-policy-v1.md"
source_migration="${contract_dir}/zettelkasten-migration-contract-v1.md"
source_release="${contract_dir}/zettelkasten-release-contract-v1.md"

typeset -a skill_names=(
  zettelkasten-development
  zettelkasten-openspec-change
  zettelkasten-script-review
  zettelkasten-system-review
  zettelkasten-validation
  zettelkasten-migration
  zettelkasten-release
)

typeset -A expected_descriptions expected_authorizations
expected_descriptions=(
  zettelkasten-development 'Implement a scoped Zettelkasten-CLI source change with OpenSpec traceability and regression verification.'
  zettelkasten-openspec-change 'Design and maintain Zettelkasten-CLI OpenSpec changes, baseline requirements, and stable legacy traceability.'
  zettelkasten-script-review 'Review Zettelkasten-CLI Zsh scripts for correctness, portability, layer violations, and requirement drift.'
  zettelkasten-system-review 'Audit Zettelkasten-CLI maturity, architecture, requirement coverage, workflow gaps, and refactoring priorities.'
  zettelkasten-validation 'Run and interpret Zettelkasten-CLI repository, OpenSpec, skill, shell, and temporary-Vault validation checks.'
  zettelkasten-migration 'Plan and apply explicit Zettelkasten-CLI data or layout migrations with dry-run, Git preflight, and integrity checks.'
  zettelkasten-release 'Prepare and publish a Zettelkasten-CLI version through verified dry-run, explicit apply, and separate Git actions.'
)
expected_authorizations=(
  zettelkasten-development 'Authorization: L1 for a bounded patch; L2 for an explicitly requested coordinated behavior/spec change.'
  zettelkasten-openspec-change 'Authorization: L0 for analysis/draft; L2 when the user explicitly asks to change normative behavior or baseline contracts.'
  zettelkasten-script-review 'Authorization: L0.'
  zettelkasten-system-review 'Authorization: L0.'
  zettelkasten-validation 'Authorization: L0 for repository/static checks and read-only validation. Temporary test fixtures may be created outside user data as part of the explicit validation request.'
  zettelkasten-migration 'Authorization: L0 for audit/dry-run planning; L3 for apply.'
  zettelkasten-release 'Authorization: L0/L2 for preparation and dry-run; L3 for publication apply, commit, tag or push.'
)

typeset failures=0
fail() { print -u2 -- "ERROR: $*"; failures=$(( failures + 1 )); }

for required in "$source_contract" "$source_authorization" "$source_migration" "$source_release"; do
  [[ -f "$required" ]] || fail "canonical skill contract not found: $required"
done
[[ -d "$skills_dir" ]] || fail "development skills directory not found: $skills_dir"
[[ -d "$openspec_dir" ]] || fail "OpenSpec directory not found: $openspec_dir"

for skill_name in "${skill_names[@]}"; do
  skill_file="${skills_dir}/${skill_name}/SKILL.md"
  ref_dir="${skills_dir}/${skill_name}/references"
  common_ref="${ref_dir}/zettelkasten-development-contract-v1.md"
  auth_ref="${ref_dir}/skill-authorization-policy-v1.md"

  [[ -f "$skill_file" ]] || { fail "skill not found: $skill_file"; continue; }
  [[ -f "$common_ref" ]] || { fail "common reference not found: $common_ref"; continue; }
  [[ -f "$auth_ref" ]] || { fail "authorization reference not found: $auth_ref"; continue; }

  frontmatter_name="$(awk -F': ' '/^name:/{gsub(/"/, "", $2); print $2; exit}' "$skill_file")"
  description="$(awk -F': ' '/^description:/{sub(/^description: /, ""); gsub(/^"|"$/, ""); print; exit}' "$skill_file")"
  [[ "$frontmatter_name" == "$skill_name" ]] || fail "$skill_name: invalid frontmatter name"
  [[ "$description" == "${expected_descriptions[$skill_name]}" ]] || fail "$skill_name: description routing contract drift"
  (( ${#description} <= 160 )) || fail "$skill_name: description exceeds 160 characters"
  rg -qxF "${expected_authorizations[$skill_name]}" "$skill_file" || fail "$skill_name: authorization scope drift"

  cmp -s "$source_contract" "$common_ref" || fail "$skill_name: common contract hash drift"
  cmp -s "$source_authorization" "$auth_ref" || fail "$skill_name: authorization policy hash drift"

  if [[ "$skill_name" == zettelkasten-migration ]]; then
    cmp -s "$source_migration" "${ref_dir}/zettelkasten-migration-contract-v1.md" || fail "$skill_name: migration contract hash drift"
    rg -q 'L3 for apply' "$skill_file" || fail "$skill_name: migration apply gate is missing"
  fi
  if [[ "$skill_name" == zettelkasten-release ]]; then
    cmp -s "$source_release" "${ref_dir}/zettelkasten-release-contract-v1.md" || fail "$skill_name: release contract hash drift"
    rg -q 'separate actions' "$skill_file" || fail "$skill_name: separate Git-action gate is missing"
  fi
  if [[ "$skill_name" == zettelkasten-script-review || "$skill_name" == zettelkasten-system-review ]]; then
    rg -q 'strictly read-only' "$skill_file" || fail "$skill_name: read-only guarantee is missing"
  fi

  while IFS= read -r requirement_id; do
    [[ -n "$requirement_id" ]] || continue
    rg -q "^### Requirement: ${requirement_id} —" "$openspec_dir" || fail "$skill_name: unknown OpenSpec requirement ID $requirement_id"
  done < <(rg -o '[A-Z][A-Z0-9-]*-[0-9]{3}' "$skill_file" | sort -u)

  while IFS= read -r requirement_range; do
    [[ -n "$requirement_range" ]] || continue
    range_prefix="${requirement_range%%-[0-9][0-9][0-9]..*}"
    range_start="${requirement_range#${range_prefix}-}"
    range_start="${range_start%%..*}"
    range_end="${requirement_range##*..}"
    for (( requirement_number = 10#$range_start; requirement_number <= 10#$range_end; requirement_number++ )); do
      requirement_id="${range_prefix}-$(printf '%03d' "$requirement_number")"
      rg -q "^### Requirement: ${requirement_id} —" "$openspec_dir" || fail "$skill_name: unknown OpenSpec requirement ID $requirement_id"
    done
  done < <(rg -o '[A-Z][A-Z0-9-]*-[0-9]{3}\.\.[0-9]{3}' "$skill_file" | sort -u)

done

while IFS= read -r artifact; do
  [[ -z "$artifact" ]] || fail "distribution artifact is not allowed: $artifact"
done < <(find "$skills_dir" -type f -name '.DS_Store' -print)

(( failures == 0 )) || exit 10
print -r -- "PASS: Marta development skill contracts (${#skill_names[@]} skills)"
