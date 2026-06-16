-- ============================================================================
-- Configuracion Snacks
-- ============================================================================
vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

-- ============================================================================
-- Setup
-- ============================================================================
require("snacks").setup({
  dashboard = {
    enabled = true,
    preset = {
      header = [[
 ⠀⠀⠀⢀⣀⣤⣤⣤⣤⣤⣤⣄⡀⠀⠀⠀
 ⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀
 ⢠⣾⣿⢛⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
 ⣾⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
 ⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⡵
 ⢸⡇⠀⠀⠉⠛⠛⣿⣿⠛⠛⠉⠀⠀⣿⡇
 ⢸⣿⣀⠀⢀⣠⣴⡇⠹⣦⣄⡀⠀⣠⣿⡇
 ⠈⠻⠿⠿⣟⣿⣿⣦⣤⣼⣿⣿⠿⠿⠟⠀
 ⠀⠀⠀⠀⠸⡿⣿⣿⢿⡿⢿⠇⠀⠀⠀⠀
 ⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀
              _
 _ __   ___  _____   _(_)_ __ ___
 | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
 | | | |  __/ (_) \ V /| | | | | | |
 |_| |_|\___|\___/ \_/ |_|_| |_| |_|
]],
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "recent_files", icon = "󱋡", title = "Recent Files", indent = 2, padding = 1 },
    },
  },
  indent = {
    enabled = true,
    animate = { enabled = false },
  },
  notifier = { enabled = true },
  statuscolumn = { enabled = true },

  picker = {
    enabled = true,
    matcher = { frecency = true, history_bonus = true },
  },

  lazygit = { enabled = true },

  image = { enabled = true },

  bigfile = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  terminal = { enabled = true },
  words = { enabled = true },

  styles = {},
})

-- ============================================================================
-- Atajos de teclado
-- ============================================================================
local map = vim.keymap.set

map("n", "<leader>ff", function()
  Snacks.picker.files({ hidden = true, layout = "ivy" })
end, { desc = "Buscar archivos en proyecto" })
map("n", "<leader>fg", function()
  Snacks.picker.grep({ hidden = true })
end, { desc = "Grep en proyecto" })
map("n", "<leader>fF", function()
  Snacks.picker.files({ cwd = "~/Documents/development/", hidden = true, layout = "ivy" })
end, { desc = "Buscar archivos en todos los proyectos" })
map("n", "<leader>fG", function()
  Snacks.picker.grep({ cwd = "~/Documents/development/", hidden = true })
end, { desc = "Grep en todos los proyectos" })
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Buscar en config" })
map("n", "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Buscar palabra actual" })
map("n", "<leader>f/", function()
  Snacks.picker.lines({ layout = "ivy" })
end, { desc = "Buscar en buffer actual" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Buscar ayuda" })
map("n", "<leader>fk", function()
  Snacks.picker.keymaps({ layout = "ivy" })
end, { desc = "Buscar atajos" })
map("n", "<leader>fd", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Diagnosticos del buffer" })
map("n", "<leader>fD", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnosticos del proyecto" })
map("n", "<leader>fi", function()
  Snacks.picker.icons()
end, { desc = "Buscar iconos" })
map("n", "<leader>fn", function()
  Snacks.picker.notifications()
end, { desc = "Buscar notificaciones" })
map("n", "<leader>fu", function()
  Snacks.picker.undo()
end, { desc = "Historial de undo" })
map("n", "<leader>fr", function()
  Snacks.picker.resume()
end, { desc = "Reanudar ultimo picker" })
map("n", "<C-t>", function() Snacks.terminal() end, { desc = "Terminal flotante" })
map("t", "<C-t>", function() Snacks.terminal() end, { desc = "Cerrar terminal flotante" })
