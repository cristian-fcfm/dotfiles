-- ============================================================================
-- LSP: Python (ty)
-- ============================================================================
vim.lsp.config.ty = {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
  settings = { ty = {} },
}
