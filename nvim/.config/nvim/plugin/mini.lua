-- =============================================================================
-- Configuracion Mini
-- =============================================================================
vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

-- mini.icons primero: otros módulos pueden necesitar el mock de nvim-web-devicons
package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()

-- =============================================================================
-- Mini Clue - Ayuda contextual de atajos
-- =============================================================================
local miniclue = require("mini.clue")

miniclue.setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "i", keys = "<C-x>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" },
    { mode = "x", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
  },
  clues = {
    { mode = "n", keys = "<Leader>b", desc = "+buffers" },
    { mode = "x", keys = "<Leader>b", desc = "+buffers" },
    { mode = "n", keys = "<Leader>f", desc = "+buscar" },
    { mode = "x", keys = "<Leader>f", desc = "+buscar" },
    { mode = "n", keys = "<Leader>g", desc = "+git" },
    { mode = "x", keys = "<Leader>g", desc = "+git" },
    { mode = "n", keys = "<Leader>l", desc = "+linea/diagnosticos" },
    { mode = "x", keys = "<Leader>l", desc = "+linea/diagnosticos" },
    { mode = "n", keys = "<Leader>s", desc = "+slime" },
    { mode = "x", keys = "<Leader>s", desc = "+slime" },
    { mode = "n", keys = "<Leader>z", desc = "+ortografia" },
    { mode = "x", keys = "<Leader>z", desc = "+ortografia" },
    { mode = "n", keys = "<Leader>t", desc = "+tabs" },
    { mode = "x", keys = "<Leader>t", desc = "+tabs" },
    { mode = "n", keys = "<Leader>p", desc = "+python" },
    { mode = "x", keys = "<Leader>p", desc = "+python" },
    { mode = "n", keys = "<Leader>w", desc = "+ventanas" },
    { mode = "x", keys = "<Leader>w", desc = "+ventanas" },
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 300,
    config = {
      width = "auto",
    },
  },
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
-- Mini Diff - Signs y blame en git
-- =============================================================================
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "_" },
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
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})

-- =============================================================================
-- Mini Snippets - Motor de snippets
-- =============================================================================
require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_lang(),
  },
})

-- =============================================================================
-- Mini Statusline - Barra de estado
-- =============================================================================
local Ministatus = require("mini.statusline")

local function statusline_lsp()
  local n = #vim.lsp.get_clients({ bufnr = 0 })
  if n == 0 then return "" end
  return "󰒋 " .. n
end

local function statusline_spell()
  if vim.o.spell then
    return "󰓆 " .. vim.o.spelllang:upper()
  end
  return ""
end

Ministatus.setup({
  content = {
    active = function()
      local mode, mode_hl = Ministatus.section_mode({ trunc_width = 120 })
      local git = Ministatus.section_git({ trunc_width = 75 })
      local diff = Ministatus.section_diff({ trunc_width = 75 })
      local diagnostics = Ministatus.section_diagnostics({ trunc_width = 75 })
      local filename = (function()
        local name = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
        if name == "" then return "[Sin nombre]" end
        if vim.bo.readonly then name = name .. " 󰈡" end
        if vim.bo.modified then name = name .. " " end
        return name
      end)()
      local fileinfo = Ministatus.section_fileinfo({ trunc_width = 120 })
      local location = Ministatus.section_location({ trunc_width = 75 })

      return Ministatus.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { statusline_spell(), statusline_lsp(), fileinfo } },
        { hl = mode_hl,                 strings = { location } },
      })
    end,
  },
  use_icons = true,
  set_vim_settings = true,
})
