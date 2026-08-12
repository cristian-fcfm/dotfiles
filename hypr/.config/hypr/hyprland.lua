-- Hyprland config. https://wiki.hypr.land/Configuring/Start/
--
-- `require` traduce los puntos a separadores de ruta: el directorio de
-- módulos se llama "conf", no "conf.d".

local apps = require("conf/apps")

require("conf/monitors")
require("conf/rules")

---------------------------------------------------------------------------
-- AUTOSTART
---------------------------------------------------------------------------

hl.on("hyprland.start", function()
  -- Arranca los daemons de la sesión (waybar, swaync, portal) vía systemd.
  -- El entorno debe exportarse antes: el portal necesita WAYLAND_DISPLAY.
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_SESSION_TYPE"
      .. " && systemctl --user start hyprland-session.target"
  )

  hl.exec_cmd(apps.browser)
  hl.exec_cmd(apps.terminal, { workspace = "2 silent" })

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("wlsunset -t 5200 -S 9:00 -s 19:30")

  -- Espera (máx 5s) a que el daemon acepte conexiones antes de pedirle nada.
  hl.exec_cmd(
    "awww-daemon & timeout 5 sh -c 'until awww query >/dev/null 2>&1; do sleep 0.1; done'"
      .. " && "
      .. apps.wallpaper_cmd()
  )
end)

hl.on("hyprland.shutdown", function()
  hl.exec_cmd("systemctl --user stop hyprland-session.target")
end)

---------------------------------------------------------------------------
-- VARIABLES DE ENTORNO
---------------------------------------------------------------------------

hl.env("XCURSOR_THEME", "Nordzy-cursors")
hl.env("XCURSOR_SIZE", "24")

---------------------------------------------------------------------------
-- LOOK AND FEEL
---------------------------------------------------------------------------

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 2,
    col = {
      active_border = { colors = { "rgba(7e9cd8ff)", "rgba(957fb8ff)" }, angle = 45 },
      inactive_border = "rgba(54546dff)",
    },
    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 0.85,

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      xray = true,
      ignore_opacity = true,
    },

    shadow = {
      offset = { 1, 2 },
      range = 10,
      render_power = 5,
      color = 0x6616161d,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
  },

  input = {
    kb_layout = "us,us",
    kb_variant = ",intl",
    kb_options = "grp:alt_shift_toggle",
    follow_mouse = 1,
    sensitivity = 0,
  },
})

---------------------------------------------------------------------------
-- ANIMACIONES
---------------------------------------------------------------------------

hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
-- Sin `style = "loop"`: el borde giratorio fuerza render continuo a la tasa
-- del monitor y anula el VFR.
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

---------------------------------------------------------------------------
-- KEYBINDINGS
---------------------------------------------------------------------------

require("conf/keybinds")
