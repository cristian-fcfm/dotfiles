-- Plugin para el explorador de archivos tipo árbol
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Íconos para archivos y carpetas
  config = function()
    require("nvim-tree").setup({})
  end,
}
