vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
})

-- =============================================================================
-- Mini AI - Objetos de texto extendidos
-- =============================================================================
require("mini.ai").setup({
  n_lines = 500,
  custom_textobjects = {
    f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    o = require("mini.ai").gen_spec.treesitter({
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    }),
    a = require("mini.ai").gen_spec.argument({ separator = "," }),
    b = require("mini.ai").gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
    F = require("mini.ai").gen_spec.function_call(),
  },
})

-- =============================================================================
-- Mini Move - Mover lineas y selecciones
-- =============================================================================
require("mini.move").setup({
  mappings = {
    left = "<C-S-h>",
    right = "<C-S-l>",
    down = "<C-S-j>",
    up = "<C-S-k>",
    line_left = "<C-S-h>",
    line_right = "<C-S-l>",
    line_down = "<C-S-j>",
    line_up = "<C-S-k>",
  },
})

-- =============================================================================
-- Mini Pairs - Auto-cierre de parentesis y comillas
-- =============================================================================
require("mini.pairs").setup()

-- =============================================================================
-- Mini Surround - Rodear texto con delimitadores
-- =============================================================================
require("mini.surround").setup()

-- =============================================================================
-- Mini Bracketed - Navegacion con corchetes
-- =============================================================================
require("mini.bracketed").setup()

-- =============================================================================
-- Mini Hipatterns - Resaltar patrones (colores hex)
-- =============================================================================
require("mini.hipatterns").setup({
  highlighters = {
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
  },
})

-- =============================================================================
-- Mini Icons - Iconos y mock de nvim-web-devicons
-- =============================================================================
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()
