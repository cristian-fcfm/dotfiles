-- Detectar archivos .d2 como D2
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.d2",
  callback = function()
    vim.bo.filetype = "d2"
  end,
})
