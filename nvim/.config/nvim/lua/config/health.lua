local utils = require("utils")

local M = {}

local system_tools = {
  { cmd = "git", desc = "Control de versiones", required = true },
  { cmd = "rg", desc = "Ripgrep - busqueda rapida", required = true },

  { cmd = "lua-language-server", desc = "LSP: Lua" },
  { cmd = "bash-language-server", desc = "LSP: Bash" },
  { cmd = "vscode-json-language-server", desc = "LSP: JSON" },
  { cmd = "yaml-language-server", desc = "LSP: YAML" },
  { cmd = "docker-langserver", desc = "LSP: Docker" },
  { cmd = "marksman", desc = "LSP: Markdown" },
  { cmd = "tinymist", desc = "LSP: Typst" },
  { cmd = "vscode-html-language-server", desc = "LSP: HTML" },
  { cmd = "vscode-css-language-server", desc = "LSP: CSS" },
  { cmd = "ty", desc = "LSP: Python (ty)" },

  { cmd = "ruff", desc = "Linter: Python" },
  { cmd = "shellcheck", desc = "Linter: Bash" },
  { cmd = "yamllint", desc = "Linter: YAML" },
  { cmd = "markdownlint", desc = "Linter: Markdown" },
  { cmd = "hadolint", desc = "Linter: Docker" },
  { cmd = "selene", desc = "Linter: Lua" },
  { cmd = "stylelint", desc = "Linter: CSS" },

  { cmd = "stylua", desc = "Formatter: Lua" },
  { cmd = "shfmt", desc = "Formatter: Bash" },
  { cmd = "prettier", desc = "Formatter: JSON/YAML/MD/HTML/CSS" },

  { cmd = "lazygit", desc = "Git TUI" },
  { cmd = "pandoc", desc = "Document converter" },
  { cmd = "typst", desc = "Typst compiler" },
  { cmd = "zathura", desc = "PDF viewer" },
}

function M.check()
  vim.health.start("Entorno del sistema")

  -- Neovim version
  local ver = vim.version()
  vim.health.ok(string.format("Neovim %s.%s.%s", ver.major, ver.minor, ver.patch))

  -- vim.pack
  if vim.pack then
    vim.health.ok("vim.pack disponible")
  else
    vim.health.error("vim.pack NO disponible (requiere Neovim 0.12+)")
  end

  vim.health.start("Herramientas del sistema")

  -- debugpy no es un ejecutable sino un modulo de python (lo usa nvim-dap-python).
  -- Se comprueba contra el python del sistema: si el proyecto usa venv,
  -- instalalo tambien ahi (pip install debugpy)
  if utils.executable("python3") then
    vim.fn.system({ "python3", "-c", "import debugpy" })
    if vim.v.shell_error == 0 then
      vim.health.ok("debugpy - DAP Python")
    else
      vim.health.warn("debugpy - DAP Python (pip install debugpy)")
    end
  end

  for _, tool in ipairs(system_tools) do
    if utils.executable(tool.cmd) then
      vim.health.ok(string.format("%s - %s", tool.cmd, tool.desc))
    elseif tool.required then
      vim.health.error(string.format("%s - %s (requerido)", tool.cmd, tool.desc))
    else
      vim.health.warn(string.format("%s - %s", tool.cmd, tool.desc))
    end
  end
end

return M
