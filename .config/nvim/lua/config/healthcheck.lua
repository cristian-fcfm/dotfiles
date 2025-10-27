-- Verificación de dependencias ejecutables
local utils = require("utils")

local M = {}

-- Lista de dependencias opcionales y sus propósitos
M.optional_deps = {
  { cmd = "fzf", desc = "Fuzzy finder (fzf-lua)" },
  { cmd = "rg", desc = "Ripgrep - búsqueda rápida de texto" },
  { cmd = "fd", desc = "Find - búsqueda rápida de archivos" },
  { cmd = "git", desc = "Control de versiones" },
  { cmd = "ruff", desc = "Python formatter/linter (Mason o sistema)" },
  { cmd = "prettier", desc = "Formatter para JSON/YAML/Markdown (Mason o sistema)" },
  { cmd = "shfmt", desc = "Shell script formatter (Mason o sistema)" },
  { cmd = "stylua", desc = "Lua formatter (Mason o sistema)" },
}

-- Verifica todas las dependencias opcionales
function M.check_optional_deps()
  local missing = {}

  for _, dep in ipairs(M.optional_deps) do
    if not utils.executable(dep.cmd) then
      table.insert(missing, dep)
    end
  end

  if #missing > 0 then
    vim.notify("Dependencias opcionales faltantes:", vim.log.levels.WARN)
    for _, dep in ipairs(missing) do
      vim.notify(string.format("  - %s: %s", dep.cmd, dep.desc), vim.log.levels.WARN)
    end
  end
end

-- Verifica si los formatters están disponibles
function M.check_formatters()
  local formatters = { "ruff", "prettier", "shfmt", "stylua" }
  local available = {}

  for _, fmt in ipairs(formatters) do
    if utils.executable(fmt) then
      table.insert(available, fmt)
    end
  end

  return available
end

return M
