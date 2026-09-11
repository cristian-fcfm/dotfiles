-- ============================================================================
-- Monitores y workspaces
-- ============================================================================
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
local HDMI_OUTPUT = "desc:" .. HDMI_DESC
local HDMI_MODE = "2560x1080@74.99"
local HDMI_POSITION = "-2560x0" -- a la izquierda de DP-1

local FIXED = { 1, 2, 3, 4, 5 } -- siempre en DP-1
local SHARED = { 6, 7, 8, 9, 10 } -- migran entre monitores

-- ─── Outputs ────────────────────────────────────────────────────────────────
hl.monitor({ output = DP, mode = "2560x1440@165", position = "0x0", scale = 1 })
hl.monitor({ output = HDMI_OUTPUT, disabled = true })
hl.monitor({ output = "", disabled = true }) -- fallback: cualquier otro monitor, apagado

-- ─── Reglas de workspace ────────────────────────────────────────────────────
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

-- ─── Estado del HDMI ────────────────────────────────────────────────────────

--- true si el monitor es el HDMI (identificado por descripción).
---@param monitor HL.Monitor
---@return boolean
local function is_hdmi(monitor)
  return monitor.description:find(HDMI_DESC, 1, true) ~= nil
end

--- Devuelve el monitor HDMI si está activo en el layout, o nil.
--- El estado se lee del compositor, nunca se cachea: así el toggle es
--- idempotente y sobrevive a los reloads.
---@return HL.Monitor|nil
local function active_hdmi()
  for _, monitor in ipairs(hl.get_monitors()) do
    if is_hdmi(monitor) then
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

-- ─── Encendido y apagado ────────────────────────────────────────────────────

--- Enciende o apaga el monitor HDMI. La migración de workspaces la hacen
--- los handlers de monitor.added / monitor.removed, que reciben el output
--- ya dentro del layout (sin adivinar con timers).
function M.toggle()
  if active_hdmi() then
    hl.monitor({ output = HDMI_OUTPUT, disabled = true })
    return
  end

  hl.monitor({
    output = HDMI_OUTPUT,
    mode = HDMI_MODE,
    position = HDMI_POSITION,
    scale = 1,
    -- Explícito: las reglas de un output se fusionan y sin esto seguiría
    -- vigente el `disabled = true` de la config base.
    disabled = false,
  })
end

-- ─── Reconciliación ante altas y bajas ──────────────────────────────────────
-- Cubre tanto M.toggle() como el hotplug físico del cable.

hl.on("monitor.added", function(monitor)
  -- Un output que aparece después del arranque nace sin wallpaper (awww lo
  -- crea en negro), así que hay que reaplicarlo en cada alta de monitor.
  hl.exec_cmd(apps.wallpaper_cmd())

  if not is_hdmi(monitor) then
    return
  end

  bind_shared_to(monitor.name, true)
  hl.dispatch(hl.dsp.focus({ monitor = monitor.name }))
  hl.dispatch(hl.dsp.focus({ workspace = SHARED[1] }))
  notify("Dual: DP-1 + " .. monitor.name)
end)

hl.on("monitor.removed", function(monitor)
  if not is_hdmi(monitor) then
    return
  end

  bind_shared_to(DP, false)
  notify("Solo DP-1 activo")
end)

return M
