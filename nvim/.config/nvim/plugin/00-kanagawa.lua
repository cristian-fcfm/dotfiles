vim.pack.add({
  { src = "https://github.com/rebelot/kanagawa.nvim", version = vim.version.range("*") },
})

require("kanagawa").setup({})
