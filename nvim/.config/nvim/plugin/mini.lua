-- ============================================================================
-- Configuracion Mini
-- ============================================================================
vim.pack.add({
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
})

local map = vim.keymap.set

package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end
require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()

-- ============================================================================
-- Mini AI - Objetos de texto extendidos
-- ============================================================================
local ai = require("mini.ai")

ai.setup({
  n_lines = 500,
  custom_textobjects = {
    -- `a` (argumento) y `b` (alias de `)]}`) se dejan con el spec por defecto
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    }),
    F = ai.gen_spec.function_call(),
  },
})

-- ============================================================================
-- Mini Git - Rama y estado de git del buffer (alimenta section_git)
-- ============================================================================
require("mini.git").setup({})

-- ============================================================================
-- Mini Diff - Signs y resumen de cambios
-- ============================================================================
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "_" },
  },
})

-- ============================================================================
-- Mini Move - Mover lineas y selecciones
-- ============================================================================
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

-- ============================================================================
-- Mini Pairs - Auto-cierre de parentesis y comillas
-- ============================================================================
require("mini.pairs").setup()

-- ============================================================================
-- Mini Surround - Rodear texto con delimitadores
-- ============================================================================
require("mini.surround").setup()

-- ============================================================================
-- Mini Bracketed - Navegacion con corchetes
-- ============================================================================
require("mini.bracketed").setup()

-- ============================================================================
-- Mini Hipatterns - Resaltar patrones (colores hex)
-- ============================================================================
require("mini.hipatterns").setup({
  highlighters = {
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})

-- ============================================================================
-- Mini Snippets - Motor de snippets
-- ============================================================================
require("mini.snippets").setup({
  snippets = {
    require("mini.snippets").gen_loader.from_lang(),
  },
})

-- ============================================================================
-- Mini Sessions - Guardar/restaurar sesiones de trabajo por proyecto
-- ============================================================================
require("mini.sessions").setup({})

-- Sesiones globales nombradas con el basename del cwd
local function session_name()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

map("n", "<leader>qs", function() MiniSessions.write(session_name()) end, { desc = "Sesión: guardar" })
map("n", "<leader>ql", function() MiniSessions.read(session_name()) end, { desc = "Sesión: restaurar proyecto" })
map("n", "<leader>qS", function() MiniSessions.select() end, { desc = "Sesión: elegir entre guardadas" })

-- ============================================================================
-- Mini Statusline - Barra de estado
-- ============================================================================
local Ministatus = require("mini.statusline")

local function statusline_spell()
  if vim.wo.spell then
    return "󰓆 " .. vim.bo.spelllang:upper()
  end
  return ""
end

local function statusline_recording()
  local reg = vim.fn.reg_recording()
  if reg ~= "" then
    return "⏺ " .. reg
  end
  return ""
end

Ministatus.setup({
  content = {
    active = function()
      local mode, mode_hl = Ministatus.section_mode({ trunc_width = 120 })
      local git = Ministatus.section_git({ trunc_width = 40 })
      local diff = Ministatus.section_diff({ trunc_width = 75 })
      local diagnostics = Ministatus.section_diagnostics({ trunc_width = 75 })
      local lsp = Ministatus.section_lsp({ trunc_width = 75 })
      local filename = (function()
        local name = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
        if name == "" then return "[Sin nombre]" end
        if vim.bo.readonly then name = name .. " 󰈡" end
        if vim.bo.modified then name = name .. " ●" end
        return name
      end)()
      local fileinfo = Ministatus.section_fileinfo({ trunc_width = 120 })
      local location = Ministatus.section_location({ trunc_width = 75 })
      local search = Ministatus.section_searchcount({ trunc_width = 75 })

      return Ministatus.combine_groups({
        { hl = mode_hl,                 strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
        "%<",
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=",
        { hl = "MiniStatuslineFileinfo", strings = { statusline_spell(), fileinfo } },
        { hl = mode_hl,                 strings = { search, statusline_recording(), location } },
      })
    end,
  },
  use_icons = true,
  set_vim_settings = true,
})
