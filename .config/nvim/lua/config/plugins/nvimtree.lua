-- Plugin para el explorador de archivos tipo árbol
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 45,
        side = "left",
      },
      actions = {
        open_file = {
          quit_on_open = false,
        },
      },
    })
  end,
}
