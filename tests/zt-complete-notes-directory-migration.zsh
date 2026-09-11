#!/bin/zsh

#------------------------------------------------------------------------------
# zt-complete-notes-directory-migration.zsh
# Тип: Runtime Regression Test
# Назначение: проверить полный граф ссылок при миграции notes/
#------------------------------------------------------------------------------

emulate -L zsh
setopt errexit pipe_fail no_unset

repo="${0:A:h:h}"
fixture="$(mktemp -d "${TMPDIR:-/tmp}/zt-notes-migration.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT HUP INT TERM
id='10000000-0000-1000-8000-000000000001.adoc'

make_root() {
  local root="$1"
  mkdir -p "$root/all-todays" "$root/workspaces" "$root/.scripts" "$root/knowledge"
  print -rl -- '= Note' ':date: 2026-09-11' ':type: note' ':keywords: note' ':author: test' ':description: Note' \
    ":doclink: link:${id}[Note]" ":docfilename: $id" '' 'body' > "$root/$id"
}

root="$fixture/Vault с пробелами Ж"
make_root "$root"
print -r -- "link:${id}[Overview]" > "$root/overview.adoc"
print -rl -- '= Заметки за 11-09-2026' '' "link:../${id}[Today]" > "$root/all-todays/2026-09-11.adoc"
print -r -- "link:../${id}[Workspace]" > "$root/workspaces/current.adoc"
print -r -- "link:../${id}[Knowledge]" > "$root/knowledge/index.adoc"

ZK_HOME="$root" "$repo/scripts/zt-migrate-notes-dir.zsh" --dry-run > "$fixture/dry.out"
rg -qF "REWRITE overview.adoc: link:${id} -> link:notes/${id}" "$fixture/dry.out" || { print -ru2 -- 'FAIL: dry-run omitted root overview rewrite'; exit 1; }
[[ -f "$root/$id" && ! -e "$root/notes" ]] || { print -ru2 -- 'FAIL: dry-run changed Vault'; exit 1; }

ZK_HOME="$root" "$repo/scripts/zt-migrate-notes-dir.zsh" --apply > "$fixture/apply.out"
[[ -f "$root/notes/$id" && ! -e "$root/$id" ]] || { print -ru2 -- 'FAIL: apply did not move root document'; exit 1; }
rg -qF "link:notes/${id}[Overview]" "$root/overview.adoc" || { print -ru2 -- 'FAIL: root overview remained broken'; exit 1; }
rg -qF "link:../notes/${id}[Today]" "$root/all-todays/2026-09-11.adoc" || { print -ru2 -- 'FAIL: all-todays target wrong'; exit 1; }
rg -qF "link:../notes/${id}[Workspace]" "$root/workspaces/current.adoc" || { print -ru2 -- 'FAIL: Workspace target wrong'; exit 1; }
rg -qF "link:../notes/${id}[Knowledge]" "$root/knowledge/index.adoc" || { print -ru2 -- 'FAIL: plugin source target wrong'; exit 1; }
ZK_HOME="$root" "$repo/scripts/zt-check.zsh" >/dev/null || { print -ru2 -- 'FAIL: migrated mixed graph failed checker'; exit 1; }
ZK_HOME="$root" "$repo/scripts/zt-migrate-notes-dir.zsh" --apply > "$fixture/repeat.out"
rg -qF 'No migration work required' "$fixture/repeat.out" || { print -ru2 -- 'FAIL: repeat migration was not a no-op'; exit 1; }

collision="$fixture/collision"
make_root "$collision"
mkdir -p "$collision/notes"
print -r -- foreign > "$collision/notes/$id"
if ZK_HOME="$collision" "$repo/scripts/zt-migrate-notes-dir.zsh" --apply > /dev/null 2> "$fixture/collision.err"; then print -ru2 -- 'FAIL: destination collision succeeded'; exit 1; fi
[[ -f "$collision/$id" && "$(<"$collision/notes/$id")" == foreign ]] || { print -ru2 -- 'FAIL: collision changed either file'; exit 1; }

opaque="$fixture/opaque"
make_root "$opaque"
print -rl -- '----' "link:${id}[ambiguous]" > "$opaque/overview.adoc"
if ZK_HOME="$opaque" "$repo/scripts/zt-migrate-notes-dir.zsh" --apply > /dev/null 2> "$fixture/opaque.err"; then print -ru2 -- 'FAIL: unsupported source succeeded'; exit 1; fi
[[ -f "$opaque/$id" && ! -e "$opaque/notes" ]] || { print -ru2 -- 'FAIL: unsupported source mutated before preflight'; exit 1; }

recovery="$fixture/recovery"
make_root "$recovery"
print -r -- "link:${id}[Overview]" > "$recovery/overview.adoc"
if ZK_HOME="$recovery" ZK_MIGRATE_TEST_LEAVE_OLD_TARGET=overview.adoc "$repo/scripts/zt-migrate-notes-dir.zsh" --apply > "$fixture/recovery.out" 2> "$fixture/recovery.err"; then print -ru2 -- 'FAIL: failed postflight was accepted'; exit 1; fi
rg -qF 'RECOVERY_REQUIRED: postflight validation failed' "$fixture/recovery.err" || { print -ru2 -- 'FAIL: postflight failure omitted recovery diagnostic'; exit 1; }
[[ -f "$recovery/$id" && ! -e "$recovery/notes/$id" ]] || { print -ru2 -- 'FAIL: postflight recovery did not restore document'; exit 1; }
rg -qF "link:${id}[Overview]" "$recovery/overview.adoc" || { print -ru2 -- 'FAIL: postflight recovery did not restore overview'; exit 1; }

print -r -- 'PASS: complete notes-directory migration coverage'
