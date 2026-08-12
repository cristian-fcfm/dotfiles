-- Keybindings.

local apps = require("conf/apps")
local monitors = require("conf/monitors")

local mod = "SUPER"

-- ─── Core Actions ────────────────────────────────────────────────────────────
hl.bind(mod .. " + return", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + E", hl.dsp.exec_cmd(apps.terminal .. " -e " .. apps.file_manager))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(apps.menu))
hl.bind(mod .. " + X", hl.dsp.exec_cmd(apps.lock))
hl.bind(mod .. " + period", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit")) -- dwindle

-- hyprshutdown si está disponible; `exit` como último recurso.
hl.bind(
  mod .. " + SHIFT + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- ─── Monitores ──────────────────────────────────────────────────────────────
hl.bind(mod .. " + ALT + M", monitors.toggle, { description = "Encender/apagar el monitor HDMI" })

-- ─── Foco (vim-style + flechas) ─────────────────────────────────────────────
local directions = { H = "l", J = "d", K = "u", L = "r", left = "l", down = "d", up = "u", right = "r" }
for key, dir in pairs(directions) do
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
end

-- ─── Mover ventanas dentro del workspace ────────────────────────────────────
for _, key in ipairs({ "H", "J", "K", "L" }) do
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = directions[key] }))
end

-- ─── Workspaces ─────────────────────────────────────────────────────────────
-- SUPER: ir al workspace | +SHIFT: llevar ventana y seguirla
-- +CTRL: llevar ventana sin seguirla (silent)
for id = 1, 10 do
  local key = id % 10 -- el 10 va en la tecla 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = id }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = id }))
  hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = id, follow = false }))
end

-- ─── Special workspace (scratchpad) ─────────────────────────────────────────
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- ─── Ventanas entre monitores ───────────────────────────────────────────────
hl.bind(mod .. " + C", hl.dsp.window.center())
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ monitor = "+1" }))

-- ─── Scroll y ciclo de workspaces ───────────────────────────────────────────
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "m-1" }))

-- ─── Ratón: mover / redimensionar ───────────────────────────────────────────
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ─── Redimensionar con teclado (repetible) ──────────────────────────────────
local resize_step = 40
local resize = {
  H = { x = -resize_step, y = 0 },
  L = { x = resize_step, y = 0 },
  K = { x = 0, y = -resize_step },
  J = { x = 0, y = resize_step },
}
for key, delta in pairs(resize) do
  hl.bind(
    mod .. " + CTRL + " .. key,
    hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }),
    { repeating = true }
  )
end

-- ─── Capturas ───────────────────────────────────────────────────────────────
hl.bind("Print", hl.dsp.exec_cmd("~/.scripts/screenshot/screenshot_monitor.sh"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd("~/.scripts/screenshot/screenshot_area.sh"))

-- ─── Multimedia / hardware ──────────────────────────────────────────────────
-- `locked` para que sigan funcionando con hyprlock activo.
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
