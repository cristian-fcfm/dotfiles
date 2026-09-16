-- ============================================================================
-- Atajos de teclado
-- ============================================================================
-- Todo bind lleva `description`: es lo que lista `hyprctl binds`.

local apps = require("conf/apps")
local monitors = require("conf/monitors")

local mod = "SUPER"

-- ─── Apps y sesión ──────────────────────────────────────────────────────────

hl.bind(mod .. " + return", hl.dsp.exec_cmd(apps.terminal), { description = "Abrir terminal" })
hl.bind(
  mod .. " + E",
  hl.dsp.exec_cmd(apps.terminal .. " -e " .. apps.file_manager),
  { description = "Explorador de archivos" }
)
hl.bind(mod .. " + D", hl.dsp.exec_cmd(apps.menu), { description = "Lanzador de apps" })
hl.bind(
  mod .. " + period",
  hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"),
  { description = "Historial del portapapeles" }
)

-- Pasa por hypridle (lock_cmd): evita instancias duplicadas de hyprlock.
hl.bind(mod .. " + X", hl.dsp.exec_cmd(apps.lock), { description = "Bloquear sesión" })

-- hyprshutdown si está disponible; `exit` como último recurso.
hl.bind(
  mod .. " + SHIFT + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
  { description = "Salir de Hyprland" }
)

-- ─── Estado de la ventana ───────────────────────────────────────────────────

hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close(), { description = "Cerrar ventana" })
hl.bind(mod .. " + F", hl.dsp.window.fullscreen(), { description = "Pantalla completa" })
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Flotar/anclar ventana" })
hl.bind(mod .. " + C", hl.dsp.window.center(), { description = "Centrar ventana flotante" })
hl.bind(mod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudotile" })
hl.bind(mod .. " + T", hl.dsp.layout("togglesplit"), { description = "Alternar split (dwindle)" })

-- ─── Grupos de ventanas ─────────────────────────────────────────────
-- Submap: cada acción vuelve a `reset` (submap por defecto) para no
-- quedar atrapado tras pulsarla.

hl.bind(mod .. " + G", hl.dsp.submap("groups"), { description = "Modo grupos de ventanas" })

hl.define_submap("groups", function()
  --- Ejecuta la acción y sale del submap.
  ---@param key string
  ---@param action any dispatcher ya construido
  ---@param desc string
  local function map(key, action, desc)
    hl.bind(key, function()
      hl.dispatch(action)
      hl.dispatch(hl.dsp.submap("reset"))
    end, { description = desc })
  end

  map("g", hl.dsp.group.toggle(), "Agrupar/desagrupar la ventana")

  -- Absorbe la ventana vecina de esa dirección dentro del grupo.
  map("h", hl.dsp.window.move({ into_group = "l" }), "Absorber la ventana de la izquierda")
  map("j", hl.dsp.window.move({ into_group = "d" }), "Absorber la ventana de abajo")
  map("k", hl.dsp.window.move({ into_group = "u" }), "Absorber la ventana de arriba")
  map("l", hl.dsp.window.move({ into_group = "r" }), "Absorber la ventana de la derecha")

  map("e", hl.dsp.window.move({ out_of_group = true }), "Sacar la ventana del grupo")
  map("n", hl.dsp.group.next(), "Siguiente pestaña del grupo")

  hl.bind("escape", function()
    hl.dispatch(hl.dsp.submap("reset"))
  end, { description = "Salir del modo grupos" })
end)

-- ─── Foco, movimiento y tamaño ──────────────────────────────────────────────
-- Cada dirección se alcanza con la tecla vim y con su flecha; SHIFT mueve la
-- ventana y CTRL la redimensiona (solo con las teclas vim: SHIFT + flecha ya
-- está tomado por el cambio de monitor).

local RESIZE_STEP = 40

local directions = {
  { key = "H", arrow = "left", dir = "l", label = "izquierda", dx = -1, dy = 0 },
  { key = "J", arrow = "down", dir = "d", label = "abajo", dx = 0, dy = 1 },
  { key = "K", arrow = "up", dir = "u", label = "arriba", dx = 0, dy = -1 },
  { key = "L", arrow = "right", dir = "r", label = "derecha", dx = 1, dy = 0 },
}

for _, d in ipairs(directions) do
  for _, key in ipairs({ d.key, d.arrow }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = d.dir }), { description = "Foco: " .. d.label })
  end

  hl.bind(
    mod .. " + SHIFT + " .. d.key,
    hl.dsp.window.move({ direction = d.dir }),
    { description = "Mover ventana: " .. d.label }
  )

  hl.bind(
    mod .. " + CTRL + " .. d.key,
    hl.dsp.window.resize({ x = d.dx * RESIZE_STEP, y = d.dy * RESIZE_STEP, relative = true }),
    { repeating = true, description = "Redimensionar: " .. d.label }
  )
end

-- ─── Ratón ──────────────────────────────────────────────────────────────────

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Arrastrar ventana" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Redimensionar ventana" })

-- ─── Workspaces ─────────────────────────────────────────────────────────────

for id = 1, 10 do
  local key = id % 10 -- el 10 va en la tecla 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = id }), { description = "Ir al workspace " .. id })
  hl.bind(
    mod .. " + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = id }),
    { description = "Llevar ventana al workspace " .. id }
  )
  hl.bind(
    mod .. " + CTRL + " .. key,
    hl.dsp.window.move({ workspace = id, follow = false }),
    { description = "Enviar ventana al workspace " .. id .. " sin seguirla" }
  )
end

hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Mostrar/ocultar scratchpad" })
hl.bind(
  mod .. " + SHIFT + S",
  hl.dsp.window.move({ workspace = "special:scratchpad" }),
  { description = "Enviar ventana al scratchpad" }
)

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Workspace siguiente" })
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace anterior" })
hl.bind(
  "CTRL + ALT + right",
  hl.dsp.focus({ workspace = "m+1" }),
  { description = "Workspace siguiente en este monitor" }
)
hl.bind(
  "CTRL + ALT + left",
  hl.dsp.focus({ workspace = "m-1" }),
  { description = "Workspace anterior en este monitor" }
)

-- ─── Monitores ──────────────────────────────────────────────────────────────

hl.bind(mod .. " + ALT + M", monitors.toggle, { description = "Encender/apagar el monitor HDMI" })
hl.bind(
  mod .. " + SHIFT + left",
  hl.dsp.window.move({ monitor = "-1" }),
  { description = "Mover ventana al monitor anterior" }
)
hl.bind(
  mod .. " + SHIFT + right",
  hl.dsp.window.move({ monitor = "+1" }),
  { description = "Mover ventana al monitor siguiente" }
)

-- ─── Capturas ───────────────────────────────────────────────────────────────

-- El monitor enfocado se resuelve aquí: el script no tiene que parsear hyprctl.
hl.bind("Print", function()
  local monitor = hl.get_active_monitor()
  if monitor then
    hl.dispatch(hl.dsp.exec_cmd("~/.scripts/screenshot/screenshot_monitor.sh " .. monitor.name))
  end
end, { description = "Capturar monitor enfocado" })

hl.bind(
  mod .. " + SHIFT + Print",
  hl.dsp.exec_cmd("~/.scripts/screenshot/screenshot_area.sh"),
  { description = "Capturar zona" }
)

-- ─── Multimedia y hardware ──────────────────────────────────────────────────
-- `locked` para que sigan funcionando con hyprlock activo.

hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true, description = "Bajar volumen" }
)
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true, description = "Subir volumen" }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, description = "Silenciar salida" }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, description = "Silenciar micrófono" }
)

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Reproducir/pausar" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Reproducir/pausar" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Pista anterior" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Pista siguiente" })
