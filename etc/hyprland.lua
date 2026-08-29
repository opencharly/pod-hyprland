-- /etc/cstream/hyprland.lua — the nested-Hyprland config.
--
-- Hyprland 0.55+ is Lua-only (hyprlang is gone on main), so this is the whole
-- config surface. Every line here is load-bearing; see the comments.

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- WAYLAND-1 is the output name a nested Hyprland gets from its parent. It is NOT
-- HEADLESS-1 (that is gst-wayland-display's own output name, one layer up).
hl.monitor({ output = "WAYLAND-1", mode = "preferred", position = "0x0", scale = 1 })

hl.config({
    ecosystem  = { enforce_permissions = true },
    -- vfr moved from misc: to debug: in Hyprland 0.55.
    debug      = { vfr = true, enable_stdout_logs = true },
    decoration = { blur = { enabled = false } },
})

-- enforce_permissions gates screencopy PER BINARY. Without this grant, grim -- and
-- therefore plugin-wl's screenshot path and every frame-content guard -- is denied.
hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")

-- Operator escape hatch: a per-user overlay, absent by default.
pcall(require, os.getenv("HOME") .. "/.config/cstream/user.lua")
