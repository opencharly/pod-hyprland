# AGENTS.md — pod-hyprland

Standalone candy repo for the `hyprland` candy — the nested-compositor primitive:
Hyprland running inside a parent Wayland display. The candy lives in `charly.yml`
at the repo root plus its `etc/` staged files.

Canonical files:

- `charly.yml` — the `hyprland:` candy entity (description, `require`, `package`,
  `service`, `plan`).
- `etc/hyprland.lua` — the Lua config (Hyprland 0.55+ is Lua-only).
- `etc/hyprlock.conf` — the lock-screen config staged to `/etc/xdg/hypr/`.
- `etc/hyprland-session` — the session launcher.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `CHANGELOG/` — per-CalVer history.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-check:wl` — the closest family skill: the `wl:` check verb, whose
  Hyprland backend routes window management and resolution through `hyprctl` and
  documents the `wl: hypr-*` methods. **This candy has no `skill:` entity of its
  own** — the gap is recorded on
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- `/charly-distros:omarchy-cstream` — the cstream/Hyprland desktop composition
  that consumes this primitive.
- `/charly-check:check` — the check/R10 framework: the `check:` step verbs and
  `charly check run <bed>`.
- `/charly-pod:pod` — the `kind: pod` / deploy schema reference (this candy is
  composed into a box; tree-position nesting, volumes, ports).
- `/charly-image:layer` — the candy authoring reference (`charly.yml` schema,
  `plan:` step verbs, `wait_for`, `wanted_by`, service declarations).
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `charly box validate` at the repo root — the structural check: the manifest
  must parse and validate at the installed charly.
- The live R10 witness is a composing box's `check` bed; the candy's own `check:`
  steps assert the binary, the absent file capabilities, the `XDG_RUNTIME_DIR`
  requirement, the hyprlock config blocks, the launcher's `exec Hyprland` + socket
  wait, the `wl:` tooling binaries, and the Lua config's output / screencopy / vfr
  settings.
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate. Its only workflow file is
  `.github/workflows/tag-on-merge.yml`.

## Modify this repo

- Edit the `hyprland:` candy entity in `charly.yml`; there is no `skill:` entity in
  this repo (the gap is tracked on opencharly/opencharly#291).
- Keep the service `enable: false` + `wanted_by: cstream-session.target` + the
  parent-socket `wait_for`: a nested compositor cannot survive being started before
  its parent exists.
- `plugin-wl` is a **pinned require** — without it the `wl:` steps SKIP with
  "unknown verb", which reads as not-failed. Do not drop it.
- The Lua config's `WAYLAND-1` output, the `enforce_permissions` screencopy grant,
  and the `debug = { vfr = true }` location are each asserted; keep config and
  checks in step.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
