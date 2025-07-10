return {
  {
    "<leader>e",
    group = "explorer",
    {
      "<leader>eo",
      function()
        local api = require("nvim-tree.api")
        api.tree.open()
      end,
      desc = "Open NvimTree",
    },
    {
      "<leader>et",
      function()
        local api = require("nvim-tree.api")
        api.tree.toggle()
      end,
      desc = "Toggle NvimTree",
    },
    {
      "<leader>ef",
      function()
        local api = require("nvim-tree.api")
        
        -- Verificar si estamos en NvimTree
        if vim.bo.filetype == "NvimTree" then
          -- Si estamos en el árbol, ir a la ventana anterior (último archivo)
          vim.cmd("wincmd p")
        else
          -- Si estamos en un archivo, enfocar NvimTree
          -- Primero asegurarse de que esté abierto
          if not api.tree.is_visible() then
            api.tree.open()
          end
          -- Luego enfocar la ventana de NvimTree
          api.tree.focus()
        end
      end,
      desc = "Toggle focus between NvimTree and last file",
    },
    {
      "<leader>e+",
      function()
        local api = require("nvim-tree.api")
        if api.tree.is_visible() then
          -- Aumentar el ancho de NvimTree usando la API
          api.tree.resize({ relative = 5 })
        end
      end,
      desc = "Increase NvimTree width",
    },
    {
      "<leader>e-",
      function()
        local api = require("nvim-tree.api")
        if api.tree.is_visible() then
          -- Disminuir el ancho de NvimTree usando la API
          api.tree.resize({ relative = -5 })
        end
      end,
      desc = "Decrease NvimTree width",
    },
  },
}
