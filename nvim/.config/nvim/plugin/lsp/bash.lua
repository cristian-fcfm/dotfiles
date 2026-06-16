-- ============================================================================
-- LSP: Bash (bash-language-server)
-- ============================================================================
vim.lsp.config.bashls = {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
}
