-- =============================================================================
-- LSP: Typst (tinymist)
-- =============================================================================
vim.lsp.config.tinymist = {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { ".git" },
  settings = { exportPdf = "never", formatterMode = "typstyle" },
}
