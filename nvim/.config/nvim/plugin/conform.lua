-- =============================================================================
-- Formateo con conform.nvim
-- =============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
  })

  -- ===========================================================================
  -- Formateadores por tipo de archivo
  -- ===========================================================================
  local utils = require("utils")
  local formatters_by_ft = {}

  utils.set_if_executable(formatters_by_ft, "python", "ruff", { "ruff_format", "ruff_organize_imports" })
  utils.set_if_executable(formatters_by_ft, "json",   "prettier")
  utils.set_if_executable(formatters_by_ft, "yaml",   "prettier")
  utils.set_if_executable(formatters_by_ft, "markdown", "prettier")
  utils.set_if_executable(formatters_by_ft, "zk",     "prettier")
  utils.set_if_executable(formatters_by_ft, "html",   "prettier")
  utils.set_if_executable(formatters_by_ft, "css",    "prettier")
  utils.set_if_executable(formatters_by_ft, "scss",   "prettier")
  utils.set_if_executable(formatters_by_ft, "less",   "prettier")
  utils.set_if_executable(formatters_by_ft, "bash",   "shfmt")
  utils.set_if_executable(formatters_by_ft, "sh",     "shfmt")
  utils.set_if_executable(formatters_by_ft, "lua",    "stylua")
  utils.set_if_executable(formatters_by_ft, "zig",    "zig", { "zigfmt" })

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
