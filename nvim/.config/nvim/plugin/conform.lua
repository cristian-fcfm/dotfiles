-- ============================================================================
-- Formateo con conform.nvim
-- ============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
  })

  -- ===========================================================================
  -- Formateadores por tipo de archivo
  -- ===========================================================================
  local formatters_by_ft = {
    python   = { "ruff_format", "ruff_organize_imports" },
    json     = { "prettier" },
    yaml     = { "prettier" },
    markdown = { "prettier" },
    zk       = { "prettier" },
    html     = { "prettier" },
    css      = { "prettier" },
    scss     = { "prettier" },
    less     = { "prettier" },
    bash     = { "shfmt" },
    sh       = { "shfmt" },
    lua      = { "stylua" },
    zig      = { "zigfmt" },
    rust     = { "rustfmt" },
    typst    = { "lsp_format" },
  }

  -- ===========================================================================
  -- Configuracion de conform
  -- ===========================================================================
  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    notify_no_formatters = false,
    format_on_save = {
      timeout_ms = 2000,
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      prettier = {
        prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
      },
    },
  })
end)
