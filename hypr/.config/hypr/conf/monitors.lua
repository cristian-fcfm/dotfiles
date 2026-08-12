-- Monitores y workspaces.
--
-- Layout: DP-1 en 0x0; el HDMI a su izquierda (x negativo), deshabilitado
-- hasta que M.toggle() lo encienda.
--
-- El HDMI se identifica por descripción y no por puerto: el número de
-- HDMI-A-N cambia al renumerar los outputs, la descripción no.
--
-- Workspaces 1-5: siempre en DP-1. Workspaces 6-10: migran al HDMI cuando
-- está encendido y vuelven a DP-1 cuando se apaga.

local apps = require("conf/apps")

local M = {}

local DP = "DP-1"
local HDMI_DESC = "LG Electronics LG HDR WFHD 0x00041906"
local HDMI_MODE = "2560x1080@74.99"
local HDMI_POSITION = "-2560x0" -- a la izquierda de DP-1

local FIXED = { 1, 2, 3, 4, 5 } -- siempre en DP-1
local SHARED = { 6, 7, 8, 9, 10 } -- migran entre monitores

---------------------------------------------------------------------------
-- Configuración base (se aplica al cargar la config)
---------------------------------------------------------------------------

hl.monitor({ output = DP, mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.monitor({ output = "desc:" .. HDMI_DESC, disabled = true })
hl.monitor({ output = "", disabled = true }) -- fallback: cualquier otro monitor, apagado

for _, id in ipairs(FIXED) do
  hl.workspace_rule({
    workspace = tostring(id),
    monitor = DP,
    persistent = true,
    default = (id == 1),
  })
end

for _, id in ipairs(SHARED) do
  hl.workspace_rule({ workspace = tostring(id), monitor = DP })
end

---------------------------------------------------------------------------
-- Reconciliación ante hotplug
---------------------------------------------------------------------------

-- Un output que aparece después del arranque nace sin wallpaper (awww lo
-- crea en negro), así que hay que reaplicarlo en cada alta de monitor.
hl.on("monitor.added", function()
  hl.exec_cmd(apps.wallpaper_cmd())
end)

---------------------------------------------------------------------------
-- Toggle del HDMI
---------------------------------------------------------------------------

--- Devuelve el monitor HDMI si está activo en el layout, o nil.
--- El estado se lee del compositor, nunca se cachea: así el toggle es
--- idempotente y sobrevive a los reloads.
---@return HL.Monitor|nil
local function active_hdmi()
  for _, monitor in ipairs(hl.get_monitors()) do
    if monitor.description:find(HDMI_DESC, 1, true) then
      return monitor
    end
  end
  return nil
end

--- Reasigna los workspaces compartidos a un monitor y los mueve allí.
---@param name string nombre real del output (ej. "DP-1")
---@param persistent boolean
local function bind_shared_to(name, persistent)
  for _, id in ipairs(SHARED) do
    hl.workspace_rule({ workspace = tostring(id), monitor = name, persistent = persistent })
    hl.dispatch(hl.dsp.workspace.move({ workspace = id, monitor = name }))
  end
end

local function notify(msg)
  hl.exec_cmd(string.format("notify-send 'Monitores' %q", msg))
end

--- Enciende o apaga el monitor HDMI.
function M.toggle()
  if active_hdmi() then
    -- Activo -> devolver workspaces a DP-1 y apagarlo.
    bind_shared_to(DP, false)
    hl.monitor({ output = "desc:" .. HDMI_DESC, disabled = true })
    notify("Solo DP-1 activo")
    return
  end

  hl.monitor({
    output = "desc:" .. HDMI_DESC,
    mode = HDMI_MODE,
    position = HDMI_POSITION,
    scale = 1,
    -- Explícito: las reglas de un output se fusionan y sin esto seguiría
    -- vigente el `disabled = true` de la config base.
    disabled = false,
  })

  -- El monitor tarda en entrar al layout: esperamos un tick para resolver su
  -- nombre real antes de mover workspaces.
  hl.timer(function()
    local hdmi = active_hdmi()
    if not hdmi then
      notify("No se pudo activar el HDMI")
      return
    end

    bind_shared_to(hdmi.name, true)
    hl.dispatch(hl.dsp.focus({ monitor = hdmi.name }))
    hl.dispatch(hl.dsp.focus({ workspace = SHARED[1] }))
    notify("Dual: DP-1 + " .. hdmi.name)
  end, { timeout = 200, type = "oneshot" })
end

return M
