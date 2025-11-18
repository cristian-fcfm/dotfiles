-- Verificación de dependencias ejecutables
local utils = require("utils")

local M = {}

-- Lista de dependencias opcionales y sus propósitos
M.optional_deps = {
  -- Herramientas del sistema
  { cmd = "fzf", desc = "Fuzzy finder (fzf-lua)" },
  { cmd = "rg", desc = "Ripgrep - búsqueda rápida de texto" },
  { cmd = "fd", desc = "Find - búsqueda rápida de archivos" },
  { cmd = "git", desc = "Control de versiones" },

  -- Formatters (instalados vía Mason)
  { cmd = "ruff", desc = "Python formatter/linter" },
  { cmd = "prettier", desc = "Formatter para JSON/YAML/Markdown" },
  { cmd = "shfmt", desc = "Shell script formatter" },
  { cmd = "stylua", desc = "Lua formatter" },

  -- Linters (instalados vía Mason)
  { cmd = "shellcheck", desc = "Bash/Shell linter" },
  { cmd = "yamllint", desc = "YAML linter" },
  { cmd = "markdownlint", desc = "Markdown linter" },
  { cmd = "hadolint", desc = "Dockerfile linter" },
  { cmd = "selene", desc = "Lua linter" },

  -- LSP servers (instalados vía Mason)
  { cmd = "basedpyright-langserver", desc = "Python LSP" },
  { cmd = "bash-language-server", desc = "Bash LSP" },
  { cmd = "vscode-json-language-server", desc = "JSON LSP" },
  { cmd = "yaml-language-server", desc = "YAML LSP" },
  { cmd = "docker-langserver", desc = "Docker LSP" },
  { cmd = "marksman", desc = "Markdown LSP" },
  { cmd = "lua-language-server", desc = "Lua LSP" },
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

-- Verifica si los linters están disponibles
function M.check_linters()
  local linters = { "ruff", "shellcheck", "yamllint", "markdownlint", "hadolint", "selene" }
  local available = {}

  for _, linter in ipairs(linters) do
    if utils.executable(linter) then
      table.insert(available, linter)
    end
  end

  return available
end

-- Verifica si los LSP servers están disponibles
function M.check_lsp_servers()
  local servers = {
    "basedpyright-langserver",
    "bash-language-server",
    "vscode-json-language-server",
    "yaml-language-server",
    "docker-langserver",
    "marksman",
    "lua-language-server",
  }
  local available = {}

  for _, server in ipairs(servers) do
    if utils.executable(server) then
      table.insert(available, server)
    end
  end

  return available
end

-- Comando para ejecutar healthcheck completo
function M.run_full_check()
  local results = {}

  -- Herramientas del sistema
  local system_tools = { "fzf", "rg", "fd", "git" }
  local system_lines = { "[Sistema]" }
  for _, tool in ipairs(system_tools) do
    local status = utils.executable(tool) and "✓" or "✗"
    table.insert(system_lines, string.format("  %s %s", status, tool))
  end
  table.insert(results, table.concat(system_lines, "\n"))

  -- LSP Servers
  local servers = M.check_lsp_servers()
  local lsp_lines = { "[LSP Servers]" }
  for _, server in ipairs({
    "basedpyright-langserver",
    "bash-language-server",
    "vscode-json-language-server",
    "yaml-language-server",
    "docker-langserver",
    "marksman",
    "lua-language-server",
  }) do
    local status = vim.tbl_contains(servers, server) and "✓" or "✗"
    local short_name = server:gsub("%-langserver", ""):gsub("%-language%-server", "")
    table.insert(lsp_lines, string.format("  %s %s", status, short_name))
  end
  table.insert(results, table.concat(lsp_lines, "\n"))

  -- Formatters
  local formatters = M.check_formatters()
  local formatter_lines = { "[Formatters]" }
  for _, fmt in ipairs({ "ruff", "prettier", "shfmt", "stylua" }) do
    local status = vim.tbl_contains(formatters, fmt) and "✓" or "✗"
    table.insert(formatter_lines, string.format("  %s %s", status, fmt))
  end
  table.insert(results, table.concat(formatter_lines, "\n"))

  -- Linters
  local linters = M.check_linters()
  local linter_lines = { "[Linters]" }
  for _, linter in ipairs({ "ruff", "shellcheck", "yamllint", "markdownlint", "hadolint", "selene" }) do
    local status = vim.tbl_contains(linters, linter) and "✓" or "✗"
    table.insert(linter_lines, string.format("  %s %s", status, linter))
  end
  table.insert(results, table.concat(linter_lines, "\n"))

  -- Enviar notificaciones agrupadas por categoría
  vim.notify("=== Neovim Healthcheck ===", vim.log.levels.INFO)
  for _, result in ipairs(results) do
    vim.notify(result, vim.log.levels.INFO)
  end
end

-- Crear comando de usuario
vim.api.nvim_create_user_command("HealthcheckAll", function()
  M.run_full_check()
end, { desc = "Ejecutar healthcheck completo de todas las herramientas" })

return M
