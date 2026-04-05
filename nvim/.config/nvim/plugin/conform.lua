-- =============================================================================
-- Formateo con conform.nvim
-- =============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim"},
  })

  -- ===========================================================================
  -- Formateadores por tipo de archivo
  -- ===========================================================================
  local utils = require("utils")
  local formatters_by_ft = {}

  if utils.executable("ruff") then
    formatters_by_ft.python = { "ruff_format", "ruff_organize_imports" }
  end

  if utils.executable("prettier") then
    formatters_by_ft.json = { "prettier" }
    formatters_by_ft.yaml = { "prettier" }
    formatters_by_ft.markdown = { "prettier" }
    formatters_by_ft.zk = { "prettier" }
    formatters_by_ft.html = { "prettier" }
    formatters_by_ft.css = { "prettier" }
    formatters_by_ft.scss = { "prettier" }
    formatters_by_ft.less = { "prettier" }
  end

  if utils.executable("shfmt") then
    formatters_by_ft.bash = { "shfmt" }
    formatters_by_ft.sh = { "shfmt" }
  end

  if utils.executable("stylua") then
    formatters_by_ft.lua = { "stylua" }
  end

  if utils.executable("zig") then
    formatters_by_ft.zig = { "zigfmt" }
  end

  formatters_by_ft.typst = { "lsp_format" }

  -- ===========================================================================
  -- Configuracion de conform
  -- ===========================================================================
  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = {
      timeout_ms = 2000,
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      ruff_format = {
        command = "ruff",
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
      ruff_organize_imports = {
        command = "ruff",
        args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
    },
  })
end)
