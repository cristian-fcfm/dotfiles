local utils = require("utils")

local M = {}

M.system_tools = {
  { cmd = "git", desc = "Control de versiones", required = true },
  { cmd = "rg", desc = "Ripgrep - busqueda rapida", required = true },

  { cmd = "lua-language-server", desc = "LSP: Lua", required = false },
  { cmd = "bash-language-server", desc = "LSP: Bash", required = false },
  { cmd = "vscode-json-language-server", desc = "LSP: JSON", required = false },
  { cmd = "yaml-language-server", desc = "LSP: YAML", required = false },
  { cmd = "docker-langserver", desc = "LSP: Docker", required = false },
  { cmd = "marksman", desc = "LSP: Markdown", required = false },
  { cmd = "tinymist", desc = "LSP: Typst", required = false },
  { cmd = "rust-analyzer", desc = "LSP: Rust", required = false },
  { cmd = "vscode-html-language-server", desc = "LSP: HTML", required = false },
  { cmd = "vscode-css-language-server", desc = "LSP: CSS", required = false },
  { cmd = "ty", desc = "LSP: Python (ty)", required = false },
  { cmd = "zk", desc = "LSP: Zettelkasten", required = false },

  { cmd = "ruff", desc = "Linter: Python", required = false },
  { cmd = "shellcheck", desc = "Linter: Bash", required = false },
  { cmd = "yamllint", desc = "Linter: YAML", required = false },
  { cmd = "markdownlint", desc = "Linter: Markdown", required = false },
  { cmd = "hadolint", desc = "Linter: Docker", required = false },
  { cmd = "selene", desc = "Linter: Lua", required = false },
  { cmd = "stylelint", desc = "Linter: CSS", required = false },

  { cmd = "stylua", desc = "Formatter: Lua", required = false },
  { cmd = "shfmt", desc = "Formatter: Bash", required = false },
  { cmd = "prettier", desc = "Formatter: JSON/YAML/MD/HTML/CSS", required = false },
  { cmd = "rustfmt", desc = "Formatter: Rust", required = false },

  { cmd = "lazygit", desc = "Git TUI", required = false },
  { cmd = "pandoc", desc = "Document converter", required = false },
  { cmd = "typst", desc = "Typst compiler", required = false },
  { cmd = "zathura", desc = "PDF viewer", required = false },
}

function M.run_check()
  local lines = {}

  if vim.pack then
    table.insert(lines, "  ✓ vim.pack disponible")
  else
    table.insert(lines, "  ✗ vim.pack NO disponible (requiere Neovim 0.12+)")
  end

  local ver = vim.version()
  local ver_str = string.format("%s.%s.%s", ver.major, ver.minor, ver.patch)
  table.insert(lines, string.format("  Neovim version: %s", ver_str))

  local ok_date = pcall(require, "date")
  if ok_date then
    table.insert(lines, "  ✓ luarocks: date")
  else
    table.insert(lines, "  ✗ luarocks: date (run: luarocks --local install date)")
  end

  table.insert(lines, "")
  table.insert(lines, "=== Herramientas del Sistema ===")

  local missing_required = {}
  for _, tool in ipairs(M.system_tools) do
    local available = utils.executable(tool.cmd)
    local status = available and "✓" or "✗"
    local req_marker = tool.required and " (requerido)" or ""
    table.insert(lines, string.format("  %s %s - %s%s", status, tool.cmd, tool.desc, req_marker))
    if not available and tool.required then
      table.insert(missing_required, tool)
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)

  if #missing_required > 0 then
    local warning = "Herramientas requeridas faltantes:"
    for _, tool in ipairs(missing_required) do
      warning = warning .. string.format("\n  - %s: %s", tool.cmd, tool.desc)
    end
    vim.notify(warning, vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command("HealthcheckSystem", function()
  M.run_check()
end, { desc = "Verificar herramientas del sistema" })

return M
