"""Adversarial regressions for completed plugin refactors; disposable data only."""
import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
from plugin_contracts import REPO, Vault


def unicode_capture(v):
    v.home.rename(v.root / "Хранилище с пробелами")
    v.home = v.root / "Хранилище с пробелами"
    v.env["ZK_HOME"] = str(v.home)
    result = v.run("zt-inbox.zsh", "Юникод и пробелы")
    raw = Path(result.stdout.strip())
    assert raw.is_file() and raw.parent == v.home / "inbox/raw"
    v.run("zt-processed.zsh", raw)
    assert not raw.exists() and (v.home / "inbox/processed" / raw.name).is_file()


def quoted_editor(v):
    editor = v.bin / "editor with spaces"
    log = v.root / "quoted-log"
    editor.write_text('#!/usr/bin/env python3\nimport json,os,sys\nfrom pathlib import Path\n'
                      'Path(os.environ["EDITOR_LOG"]).write_text(json.dumps([os.getcwd(),sys.argv[1:]]))\n')
    editor.chmod(0o755)
    # Literal code-like argument must not be executed by editor parsing.
    result = v.run("zt-inbox.zsh", "Quoted editor", EDITOR_LOG=str(log),
                   EDITOR=f'"{editor}" --flag "two words" "" "$(touch NEVER-CREATE)"')
    assert json.loads(log.read_text()) == [str(v.root), ["--flag", "two words", "", "$(touch NEVER-CREATE)", result.stdout.strip()]]
    assert not (v.root / "NEVER-CREATE").exists()


def capture_write_failure(v):
    config = v.root / "zsh config"
    config.mkdir()
    (config / ".zshenv").write_text('print() {\n if [[ "$*" == *":source: manual"* ]]; then return 1; fi\n builtin print "$@"\n}\n')
    result = v.run("zt-inbox.zsh", "Write failure", ZDOTDIR=str(config), code=None)
    assert "cannot write file" in result.stderr
    assert not list((v.home / "inbox/raw").iterdir())
    assert not (v.root / "editor-log").exists()


def capture_collisions(v):
    raw = v.home / "inbox/raw"
    raw.mkdir(parents=True)
    occupied = raw / "2026-09-05-101500.adoc"
    missing = v.root / "missing-target"
    occupied.symlink_to(missing)
    processes = [subprocess.Popen([str(v.scripts / "zt-inbox.zsh"), f"item {n}"],
                                  env=v.env, cwd=v.root, text=True, stdout=subprocess.PIPE,
                                  stderr=subprocess.PIPE) for n in range(8)]
    results = [p.communicate(timeout=30) for p in processes]
    assert all(p.returncode == 0 for p in processes), results
    paths = [Path(out.strip()) for out, err in results]
    assert len(set(paths)) == 8 and all(p.is_file() for p in paths)
    assert occupied.is_symlink() and not missing.exists()
    assert {p.read_text().splitlines()[0] for p in paths} == {f"= item {n}" for n in range(8)}


def processed_fixture(v):
    raw = v.home / "inbox/raw"
    raw.mkdir(parents=True)
    source = raw / "item.adoc"
    source.write_text("source bytes\n")
    destination = v.home / "inbox/processed/item.adoc"
    destination.parent.mkdir(parents=True)
    return source, destination


def internal_symlink(v):
    source, destination = processed_fixture(v)
    alias = source.parent / "alias.adoc"
    alias.symlink_to(source.name)
    for argument in (alias, alias.name):
        v.run("zt-processed.zsh", argument, code=None)
        assert alias.is_symlink() and source.read_text() == "source bytes\n" and not destination.exists()


def destination_collision(v, kind):
    source, destination = processed_fixture(v)
    outside = v.root / "outside"
    if kind == "directory":
        destination.mkdir()
    elif kind == "symlink-directory":
        outside.mkdir()
        destination.symlink_to(outside, target_is_directory=True)
    else:
        destination.symlink_to(outside)
    v.run("zt-processed.zsh", source, code=None)
    assert source.read_text() == "source bytes\n"
    assert not (destination / source.name).exists()
    if kind == "dangling":
        assert not outside.exists()


def racing_destination(v):
    source, destination = processed_fixture(v)
    # Simulate directory creation after every preflight but before the syscall.
    for name in ("ln", "link"):
        real = shutil.which(name)
        stub = v.bin / name
        stub.write_text('#!/usr/bin/env python3\nimport os,sys\nfrom pathlib import Path\n'
                        'Path(sys.argv[-1]).mkdir(exist_ok=True)\n'
                        f'os.execv({real!r}, [{name!r}] + sys.argv[1:])\n')
        stub.chmod(0o755)
    v.run("zt-processed.zsh", source, code=None)
    assert source.read_text() == "source bytes\n" and list(destination.iterdir()) == []


def workspace_fixture(v):
    v.run("zt-workspace-create.zsh", input="Work\n")
    a, b = v.note("a"), v.note("b")
    return v.home / "workspaces/Work.adoc", {p: p.read_bytes() for p in (a, b)}


def selective_remove(v):
    workspace, documents = workspace_fixture(v)
    initial = ("= Work\n\n== Документы\n\n"
               "* context link:../notes/a.adoc[A] and link:../notes/b.adoc[B] keep\n"
               "* link:../notes/a.adoc[A]\n"
               "Inline link:../notes/a.adoc[A] trailing\n"
               "----\n* link:../notes/a.adoc[Example]\n----\n")
    workspace.write_text(initial)
    v.run("zt-workspace-remove.zsh", SELECT='["a.adoc"]')
    assert workspace.read_text() == ("= Work\n\n== Документы\n\n"
                                     "* context  and link:../notes/b.adoc[B] keep\n"
                                     "Inline  trailing\n"
                                     "----\n* link:../notes/a.adoc[Example]\n----\n")
    assert all(p.read_bytes() == data for p, data in documents.items())


def staging_and_cleanup(v):
    workspace, documents = workspace_fixture(v)
    workspace.write_text("= Work\n\n* link:../notes/a.adoc[A]\n")
    workspace.chmod(0o640)
    original = workspace.read_bytes()
    real = shutil.which("mktemp")
    stub = v.bin / "mktemp"
    stub.write_text('#!/usr/bin/env python3\nimport os,sys\nfrom pathlib import Path\n'
                    'assert Path(sys.argv[-1]).parent == Path(os.environ["EXPECTED_STAGING"])\n'
                    f'os.execv({real!r}, ["mktemp"]+sys.argv[1:])\n')
    stub.chmod(0o755)
    v.run("zt-workspace-remove.zsh", FAIL_MV="1", EXPECTED_STAGING=str(workspace.parent), code=None)
    assert workspace.read_bytes() == original and workspace.stat().st_mode & 0o777 == 0o640
    assert not list(v.root.rglob("*zk-workspace-remove.*"))
    v.run("zt-workspace-remove.zsh", EXPECTED_STAGING=str(workspace.parent))
    assert workspace.stat().st_mode & 0o777 == 0o640
    assert all(p.read_bytes() == data for p, data in documents.items())


def diary_existing_today(v):
    v.home.rename(v.root / "Дневник с пробелами")
    v.home = v.root / "Дневник с пробелами"
    v.env["ZK_HOME"] = str(v.home)
    today = v.home / "all-todays/2026-09-05.adoc"
    today.parent.mkdir()
    previous = "= Заметки за 05-09-2026\n\n* 09.00 - link:../notes/old.adoc[Note]\n"
    today.write_text(previous)
    v.run("zt-diary.zsh")
    state = (v.home / ".last-diary").read_text().strip()
    assert today.read_text() == previous + f"* 10.15 - link:../notes/{state}[Diary - 05-09-2026]\n"
    original = v.snapshot()
    (v.home / ".last-diary").unlink()
    (v.home / ".last-diary").mkdir()
    v.run("zt-diary.zsh", code=None)
    assert (v.home / ".last-diary").is_dir()
    assert len((v.root / "editor-log").read_text().splitlines()) == 1
    assert (v.home / "notes" / state).read_bytes() == original[f"notes/{state}"]


def boundary_substitution(v):
    spec = importlib.util.spec_from_file_location("boundary", REPO / "dev/scripts/plugin_boundaries.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    root = v.root / "boundary/scripts"
    shutil.copytree(REPO / "scripts", root)
    probe = root / "diary/probe.zsh"
    bad = '"$script_dir/../zettelkasten/lib/today.zsh"'
    cases = [f'value="$(source {bad})"', f'( source {bad} )', f'{{ source {bad}; }}',
             f'if true; then source {bad}; fi', f'value=`source {bad}`',
             'source ../lib/paths.zsh']
    for case in cases:
        probe.write_text('script_dir="${0:A:h}"\n' + case + '\n')
        assert module.check(root)[1], case
    probe.write_text('script_dir="${0:A:h}"\nvalue="$(source "$script_dir/../lib/paths.zsh")"\n')
    assert not module.check(root)[1]
    probe.write_text("print -r -- 'literal $(source ../zettelkasten/lib/today.zsh)'\n")
    assert not module.check(root)[1]


CASES = {"unicode_capture": unicode_capture, "quoted_editor": quoted_editor,
         "capture_collisions": capture_collisions, "capture_write_failure": capture_write_failure, "internal_symlink": internal_symlink,
         "destination_directory": lambda v: destination_collision(v, "directory"),
         "destination_symlink_directory": lambda v: destination_collision(v, "symlink-directory"),
         "destination_dangling": lambda v: destination_collision(v, "dangling"),
         "racing_destination": racing_destination, "selective_remove": selective_remove,
         "staging_and_cleanup": staging_and_cleanup, "diary_existing_today": diary_existing_today,
         "boundary_substitution": boundary_substitution}

failed = []
for name, case in CASES.items():
    with tempfile.TemporaryDirectory(prefix="zt-edge-") as tmp:
        try:
            case(Vault(Path(tmp).resolve()))
        except (AssertionError, OSError, subprocess.TimeoutExpired) as error:
            failed.append(name)
            print(f"FAIL: {name}: {error}", flush=True)
        else:
            print(f"PASS: {name}", flush=True)
print(f"Plugin edge cases: {len(CASES) - len(failed)}/{len(CASES)} passed")
sys.exit(bool(failed))
