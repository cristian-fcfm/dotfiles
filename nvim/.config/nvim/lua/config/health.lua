local utils = require("utils")

local M = {}

local system_tools = {
  { cmd = "git", desc = "Control de versiones (lo necesita vim.pack)", required = true },
  { cmd = "rg", desc = "Ripgrep - busqueda rapida", required = true },
  { cmd = "lazygit", desc = "Git TUI" },
  { cmd = "pandoc", desc = "Exportar markdown a PDF vía typst (:MarkdownExportPDF)" },
  { cmd = "prettier", desc = "Formateo markdown/json/css al guardar (conform)" },
  { cmd = "markdown-oxide", desc = "LSP markdown con backlinks (vault zk)" },
  { cmd = "zk", desc = "CLI de notas, la usan los comandos Zk*" },
  { cmd = "typst", desc = "Compilador Typst" },
  { cmd = "npm", desc = "Build de markdown-preview.nvim" },
  { cmd = "debugpy-adapter", desc = "DAP Python (uv tool install debugpy)" },
}

--- Resuelve el ejecutable de un linter de nvim-lint.
--- @param name string Nombre del linter en `lint.linters`
--- @return string|nil cmd Ejecutable, nil si no se pudo resolver
--- @return string|nil err Motivo, presente solo cuando `cmd` es nil
local function linter_cmd(name)
  local ok, linter = pcall(function()
    return require("lint").linters[name]
  end)
  if not ok or type(linter) ~= "table" then
    return nil, "nvim-lint no define este linter"
  end

  if type(linter.cmd) == "function" then
    local resolved, cmd = pcall(linter.cmd)
    if not resolved or type(cmd) ~= "string" then
      return nil, "su `cmd` dinamico no devolvio un ejecutable"
    end
    return cmd
  end

  if type(linter.cmd) ~= "string" then
    return nil, "el linter no declara `cmd`"
  end
  return linter.cmd
end

--- Agrupa los linters activos por nombre, con los filetypes que los usan.
--- @return table<string, string[]>
local function linters_by_name()
  local ok, lint = pcall(require, "lint")
  if not ok then
    return {}
  end

  local grouped = {}
  for filetype, names in pairs(lint.linters_by_ft) do
    for _, name in ipairs(names) do
      grouped[name] = grouped[name] or {}
      table.insert(grouped[name], filetype)
    end
  end
  return grouped
end

function M.check()
  vim.health.start("Entorno del sistema")

  local version = tostring(vim.version())
  if vim.fn.has("nvim-0.12") == 1 then
    vim.health.ok("Neovim " .. version)
  else
    vim.health.error("Neovim " .. version .. " (esta configuracion requiere 0.12+)")
  end

  vim.health.start("Herramientas del sistema")

  for _, tool in ipairs(system_tools) do
    if utils.executable(tool.cmd) then
      vim.health.ok(string.format("%s - %s", tool.cmd, tool.desc))
    elseif tool.required then
      vim.health.error(string.format("%s - %s (requerido)", tool.cmd, tool.desc))
    else
      vim.health.warn(string.format("%s - %s", tool.cmd, tool.desc))
    end
  end

  vim.health.start("Linters (nvim-lint)")

  local grouped = linters_by_name()
  if vim.tbl_isempty(grouped) then
    vim.health.warn("nvim-lint todavia no esta cargado: reintenta con un buffer abierto")
  end

  for name, filetypes in vim.spairs(grouped) do
    table.sort(filetypes)
    local label = string.format("%s - %s", name, table.concat(filetypes, ", "))
    local cmd, err = linter_cmd(name)
    if not cmd then
      vim.health.error(string.format("%s (%s)", label, err))
    elseif utils.executable(cmd) then
      vim.health.ok(label)
    else
      vim.health.warn(label .. string.format(" (falta %s)", cmd))
    end
  end

  vim.health.info("LSP: `:checkhealth vim.lsp` | formateadores: `:checkhealth conform`")
end

return M
