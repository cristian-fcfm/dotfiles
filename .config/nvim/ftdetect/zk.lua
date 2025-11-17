-- Detectar archivos markdown dentro de un notebook zk
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function()
    local path = vim.fn.expand("%:p")
    -- Buscar directorio .zk en el árbol de directorios
    local root = vim.fs.find(".zk", {
      path = path,
      upward = true,
      type = "directory",
    })[1]

    if root then
      vim.bo.filetype = "zk"
    end
  end,
})
