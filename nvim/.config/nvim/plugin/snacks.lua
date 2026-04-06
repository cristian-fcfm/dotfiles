-- =============================================================================
-- Configuracion Snacks
-- =============================================================================
vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

-- ===========================================================================
-- Setup
-- ===========================================================================
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
  words = { enabled = true },

  styles = {},
})

-- ===========================================================================
-- Keymaps
-- ===========================================================================
local map = vim.keymap.set

map("n", "<leader>ff", function()
  Snacks.picker.files({ hidden = true, layout = "ivy" })
end, { desc = "Find files in project" })
map("n", "<leader>fg", function()
  Snacks.picker.grep({ hidden = true })
end, { desc = "Grep in project" })
map("n", "<leader>fF", function()
  Snacks.picker.files({ cwd = "~/Documents/development/", hidden = true, layout = "ivy" })
end, { desc = "Find files in all projects" })
map("n", "<leader>fG", function()
  Snacks.picker.grep({ cwd = "~/Documents/development/", hidden = true })
end, { desc = "Grep in all projects" })
map("n", "<leader>fc", function()
  Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find in config" })
map("n", "<leader>fw", function()
  Snacks.picker.grep_word()
end, { desc = "Find current word" })
map("n", "<leader>f/", function()
  Snacks.picker.lines({ layout = "ivy" })
end, { desc = "Live grep current buffer" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Find help" })
map("n", "<leader>fk", function()
  Snacks.picker.keymaps({ layout = "ivy" })
end, { desc = "Find keymaps" })
map("n", "<leader>fd", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Find diagnostics in buffer" })
map("n", "<leader>fD", function()
  Snacks.picker.diagnostics()
end, { desc = "Find diagnostics in project" })
map("n", "<leader>fi", function()
  Snacks.picker.icons()
end, { desc = "Find icons" })
map("n", "<leader>fn", function()
  Snacks.picker.notifications()
end, { desc = "Find notifications" })
