-- Verificación de herramientas del sistema (no instaladas por Mason)
local utils = require("utils")

local M = {}

-- Herramientas del sistema requeridas
M.system_tools = {
  { cmd = "rg", desc = "Ripgrep - búsqueda rápida de texto", required = true },
  { cmd = "fd", desc = "Find - búsqueda rápida de archivos", required = true },
  { cmd = "git", desc = "Control de versiones", required = true },
  { cmd = "typst", desc = "Compilador Typst", required = false },
}

-- Ejecutar healthcheck de herramientas del sistema
function M.run_check()
  local lines = { "=== Herramientas del Sistema ===" }
  local missing_required = {}

  for _, tool in ipairs(M.system_tools) do
    local available = utils.executable(tool.cmd)
    local status = available and "✓" or "✗"
    local req_marker = tool.required and " (requerido)" or " (opcional)"

    table.insert(lines, string.format("  %s %s%s", status, tool.cmd, req_marker))

    if not available and tool.required then
      table.insert(missing_required, tool)
    end
  end

  -- Mostrar resultado
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)

  -- Advertir sobre herramientas requeridas faltantes
  if #missing_required > 0 then
    local warning = "Herramientas requeridas faltantes:"
    for _, tool in ipairs(missing_required) do
      warning = warning .. string.format("\n  - %s: %s", tool.cmd, tool.desc)
    end
    vim.notify(warning, vim.log.levels.WARN)
  end
end

-- Crear comando de usuario
vim.api.nvim_create_user_command("HealthcheckSystem", function()
  M.run_check()
end, { desc = "Verificar herramientas del sistema" })

return M
