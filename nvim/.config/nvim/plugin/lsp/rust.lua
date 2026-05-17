-- =============================================================================
-- LSP: Rust (rust-analyzer)
-- =============================================================================
vim.lsp.config.rust_analyzer = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
      inlayHints = { enable = true },
    },
  },
}
