#!/bin/zsh

#------------------------------------------------------------------------------
# zt-openspec-check.zsh
# Тип: Development Check
# Назначение: проверить полное и однозначное покрытие legacy requirement ID OpenSpec baseline
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

script_dir="${0:A:h}"
repo_root="${script_dir:h:h}"
openspec_dir="${ZK_OPENSPEC_DIR:-${repo_root}/openspec/specs}"
host_requirements="${ZK_HOST_REQUIREMENTS:-${repo_root}/.scripts/docs/requirements.adoc}"
plugin_requirements="${ZK_PLUGIN_REQUIREMENTS:-${repo_root}/.scripts/zettelkasten/docs/requirements.adoc}"

typeset failures=0

fail() {
  print -u2 -- "ERROR: $*"
  failures=$(( failures + 1 ))
}

[[ -d "$openspec_dir" ]] || { print -u2 -- "ERROR: OpenSpec baseline not found: $openspec_dir"; exit 10; }
[[ -f "$host_requirements" ]] || { print -u2 -- "ERROR: host requirements not found: $host_requirements"; exit 10; }
[[ -f "$plugin_requirements" ]] || { print -u2 -- "ERROR: plugin requirements not found: $plugin_requirements"; exit 10; }

legacy_tmp="$(mktemp "${TMPDIR:-/tmp}/zt-legacy-ids.XXXXXX")"
spec_tmp="$(mktemp "${TMPDIR:-/tmp}/zt-openspec-ids.XXXXXX")"
trap 'rm -f -- "$legacy_tmp" "$spec_tmp"' EXIT HUP INT TERM

rg -o '`[A-Z][A-Z0-9-]*-[0-9]{3} \[(IMPLEMENTED|ROADMAP|INVARIANT|PROCESS)\]`' \
  "$host_requirements" "$plugin_requirements" \
  | sed -E 's/.*`([A-Z][A-Z0-9-]*-[0-9]{3}) .*/\1/' \
  | sort > "$legacy_tmp"

rg -o '^### Requirement: [A-Z][A-Z0-9-]*-[0-9]{3} —' "$openspec_dir" \
  | sed -E 's/.*Requirement: ([A-Z][A-Z0-9-]*-[0-9]{3}) —/\1/' \
  | sort > "$spec_tmp"

while IFS= read -r requirement_id; do
  [[ -n "$requirement_id" ]] || continue
  count="$(grep -cxF -- "$requirement_id" "$spec_tmp" || true)"
  [[ "$count" == 1 ]] || fail "legacy requirement must occur exactly once in OpenSpec: $requirement_id (found $count)"
done < <(sort -u "$legacy_tmp")

while IFS= read -r requirement_id; do
  [[ -n "$requirement_id" ]] || continue
  count="$(grep -cxF -- "$requirement_id" "$legacy_tmp" || true)"
  [[ "$count" == 1 ]] || fail "OpenSpec requirement has missing or duplicate legacy traceability: $requirement_id (found $count)"
done < <(sort -u "$spec_tmp")

while IFS= read -r duplicate; do
  [[ -z "$duplicate" ]] || fail "duplicate OpenSpec requirement ID: $duplicate"
done < <(uniq -d "$spec_tmp")

while IFS= read -r spec_file; do
  awk -v file="$spec_file" '
    /^### Requirement: / {
      if (seen_requirement && !seen_scenario) {
        print "ERROR: " file ": requirement has no Scenario: " requirement > "/dev/stderr"
        failures++
      }
      requirement=$0
      seen_requirement=1
      seen_scenario=0
      next
    }
    /^#### Scenario: / && seen_requirement { seen_scenario=1 }
    END {
      if (seen_requirement && !seen_scenario) {
        print "ERROR: " file ": requirement has no Scenario: " requirement > "/dev/stderr"
        failures++
      }
      exit(failures ? 1 : 0)
    }
  ' "$spec_file" || failures=$(( failures + 1 ))
done < <(find "$openspec_dir" -type f -name spec.md -print | sort)

(( failures == 0 )) || exit 10
print -r -- "PASS: OpenSpec baseline covers $(wc -l < "$legacy_tmp" | tr -d ' ') legacy requirements exactly once"
