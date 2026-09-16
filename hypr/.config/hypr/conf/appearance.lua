-- ============================================================================
-- Apariencia
-- ============================================================================
-- Marcos, decoración, layout y animaciones. La entrada (teclado y ratón) vive
-- en conf/input.lua.

hl.env("XCURSOR_THEME", "Nordzy-cursors")
hl.env("XCURSOR_SIZE", "24")

-- ─── Marcos y layout ────────────────────────────────────────────────────────
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

  -- Fullscreen se compone directo al scanout del monitor: menos trabajo de
  -- GPU y menos latencia. Rompe la captura de ventanas fullscreen si el
  -- compositor no puede caer a composición normal para el screencopy.
  render = {
    direct_scanout = true,
  },

  dwindle = {
    preserve_split = true,
  },

  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 0.85,

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
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

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo = true,
  },
})

-- ─── Curvas de animación ────────────────────────────────────────────────────
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

-- ─── Animaciones de ventana ─────────────────────────────────────────────────
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })

-- ─── Animaciones de borde y workspace ───────────────────────────────────────
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
-- Sin `style = "loop"`: el borde giratorio fuerza render continuo a la tasa
-- del monitor y anula el VFR.
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })
