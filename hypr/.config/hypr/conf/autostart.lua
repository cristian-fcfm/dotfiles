-- ============================================================================
-- Autostart
-- ============================================================================
-- Lo que arranca y para con la sesión gráfica. Los daemons de larga vida los
-- gestiona systemd: docs/adr/0002-systemd-dueno-de-los-daemons-de-sesion.md

local apps = require("conf/apps")

hl.on("hyprland.start", function()
  -- El target de systemd solo arranca útil si el entorno Wayland ya viajó al
  -- bus: primero exportarlo, después levantarlo.
  hl.exec_cmd(
    "dbus-update-activation-environment --systemd"
      .. " WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XDG_SESSION_TYPE"
      .. " && systemctl --user start hyprland-session.target"
  )

  hl.exec_cmd(apps.browser)
  hl.exec_cmd(apps.terminal, { workspace = "2 silent" })

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

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
