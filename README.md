# pod-hyprland

The `hyprland` candy of the OpenCharly candy library, as a standalone repo
(kind-prefixed naming). It is the nested-compositor primitive: Hyprland running
inside a parent Wayland display.

## What it provides

Installs Hyprland, hyprlock, and the `wl:`-verb tooling (`grim`, `wl-clipboard`,
`wtype`, `wlr-randr`), stages its Lua config (`/etc/cstream/hyprland.lua`), its
hyprlock config (`/etc/xdg/hypr/hyprlock.conf`), and its session launcher
(`/usr/local/bin/hyprland-session`), and strips file capabilities from the binary
so it can exec under a pod's no-new-privileges.

| Property | Value |
|---|---|
| Service | `cstream-hyprland` (`hyprland-session`, priority 12, `enable: false`) |
| Requires | `plugin-wl` (the out-of-process `wl:` check verb) |
| Packages | `hyprland`, `hyprlock`, `xorg-xwayland`, `libcap`, `grim`, `wl-clipboard`, `wtype`, `wlr-randr` |
| Env | `XDG_RUNTIME_DIR=/tmp/cstream-rt`, `WAYLAND_DISPLAY=wayland-1`, `LIBSEAT_BACKEND=noop`, `HYPRLAND_CONFIG=/etc/cstream/hyprland.lua` |

**Hyprland is always nested here.** It has no headless-only mode — the binary
exposes no `--headless` flag and no `HYPRLAND_HEADLESS_ONLY`, and Aquamarine's
DRM backend needs a KMS card node a rootless pod never gets (a standalone attempt
aborts with `CBackend::create() failed!`). Every bed composing this candy must
supply a parent display that advertises `zwp_linux_dmabuf_v1` and binds
`xdg_wm_base` at version 6 — `layer-gst-wayland-display` (Smithay) clears both.

The service is deliberately **not enabled**: `enable:` is systemd-only, and
charly's deploy walk would start a nested compositor before its parent exists.
The compositor's lifetime is a session, declared by
`wanted_by: cstream-session.target` and a `wait_for` on the parent socket.

## How to use it

Compose the candy into a box that already supplies a parent display
(`layer-gst-wayland-display` in `pod-cstream`):

```yaml
my-desktop:
  candy:
    candy:
      - '@github.com/opencharly/pod-cstream:<tag>'
      - '@github.com/opencharly/pod-hyprland:<tag>'
```

## Layout

- `charly.yml` — the `hyprland:` candy entity.
- `etc/hyprland.lua` — the Lua config (Hyprland 0.55+ is Lua-only).
- `etc/hyprlock.conf` — the lock-screen config (hyprlock refuses to start without
  one).
- `etc/hyprland-session` — the session launcher.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `CHANGELOG/` — per-CalVer history.
- `README.md` — this user overview.

## Related

- Closest family skill: `/charly-check:wl` — the `wl:` check verb, whose
  Hyprland backend routes window management and resolution through `hyprctl` and
  documents the `wl: hypr-*` methods. This candy has no `skill:` entity of its own
  (recorded on
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291)).
- `/charly-distros:omarchy-cstream` — the cstream/Hyprland desktop composition.
- `/charly-selkies:selkies` — the alternative transport (labwc/KDE; cannot host
  Hyprland — the `wl_compositor` v6 constraint).
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI and image builder
- [`opencharly/opencharly`](https://github.com/opencharly/opencharly) — the umbrella
