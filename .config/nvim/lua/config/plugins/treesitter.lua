-- Plugin para resaltado de sintaxis avanzado y otras mejoras de edición
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Actualiza los parsers automáticamente
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true }, -- Habilita el resaltado de sintaxis
      indent = { enable = true },    -- Habilita indentación inteligente
      incremental_selection = {      -- Habilita selección
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    })
  end,
}
