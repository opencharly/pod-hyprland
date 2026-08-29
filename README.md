# pod-hyprland

The nested-compositor primitive: Hyprland running inside a parent Wayland display,
with its Lua config (`/etc/cstream/hyprland.lua`), its session launcher
(`/usr/local/bin/hyprland-session`), and the file-capability strip that lets it exec
under a pod's no-new-privileges.

**Hyprland is always nested here.** It has no headless-only mode, and Aquamarine's DRM
backend needs a KMS card node a rootless pod never gets. Every bed composing this candy
must supply a parent display that advertises `zwp_linux_dmabuf_v1` and binds
`xdg_wm_base` at version 6 — `layer-gst-wayland-display` is that parent.
