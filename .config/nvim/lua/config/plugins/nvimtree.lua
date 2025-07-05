-- Plugin para el explorador de archivos tipo árbol
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      -- Atajos personalizados dentro de nvim-tree
      local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

      -- Abrir en vertical split
      vim.keymap.set('n', 'v', api.node.open.vertical, opts)
      -- Abrir en horizontal split
      vim.keymap.set('n', 's', api.node.open.horizontal, opts)

    end

    require("nvim-tree").setup({
      view = {
        width = 45,
        side = "left",
      },
      on_attach = my_on_attach,
      actions = {
        open_file = {
          quit_on_open = false,
        },
      },
    })
  end,
}
