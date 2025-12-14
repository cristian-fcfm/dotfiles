-- Detectar archivos .typ como Typst
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.typ",
  callback = function()
    vim.bo.filetype = "typst"
  end,
})
