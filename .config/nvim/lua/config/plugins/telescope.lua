-- Plugin para búsqueda rápida de archivos, texto, buffers, etc.
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Dependencia necesaria para Telescope
  config = function()
    require("telescope").setup({})
  end,
}
