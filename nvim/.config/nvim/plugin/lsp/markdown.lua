-- ============================================================================
-- LSP: Markdown (markdown-oxide)
-- ============================================================================
-- Requiere el binario en PATH: ver health.lua
vim.lsp.config.markdown_oxide = {
  cmd = { "markdown-oxide" },
  filetypes = { "markdown" },
  root_markers = { ".zk", ".git" },
}
