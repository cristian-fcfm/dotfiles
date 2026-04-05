vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({
  dashboard = {
    enabled = true,
    preset = {
      header = [[
        ⠀⠀⠀⢀⣀⣤⣤⣤⣤⣄⡀⠀⠀⠀⠀
        ⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀
        ⢠⣾⣿⢛⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
        ⣾⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
        ⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⡵
        ⢸⡇⠀⠀⠉⠛⠛⣿⣿⠛⠛⠉⠀⠀⣿⡇
        ⢸⣿⣀⠀⢀⣠⣴⡇⠹⣦⣄⡀⠀⣠⣿⡇
        ⠈⠻⠿⠿⣟⣿⣿⣦⣤⣼⣿⣿⠿⠿⠟⠀
        ⠀⠀⠀⠀⠸⡿⣿⣿⢿⡿⢿⠇⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀⠀⠀
                       _
 _ __   ___  _____   _(_)_ __ ___
| '_ \ / _ \/ _ \ \ / / | '_ ` _ \
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },
  },
  indent = {
    enabled = true,
    priority = 1,
    animate = { enabled = false },
    hl = {
      "SnacksIndent1", "SnacksIndent2", "SnacksIndent3", "SnacksIndent4",
      "SnacksIndent5", "SnacksIndent6", "SnacksIndent7", "SnacksIndent8",
    },
  },
  notifier = { enabled = true },
  statuscolumn = { enabled = true },

  explorer = { enabled = true },
  picker = {
    enabled = true,
    matcher = { frecency = true, history_bonus = true },
    actions = {
      yank_put_after = function(...) return require("yanky.picker").actions.put("p")(...) end,
      yank_put_before = function(...) return require("yanky.picker").actions.put("P")(...) end,
      yank_put_after_cursor = function(...) return require("yanky.picker").actions.put("gp")(...) end,
      yank_put_before_cursor = function(...) return require("yanky.picker").actions.put("gP")(...) end,
      yank_delete = function(...) return require("yanky.picker").actions.delete()(...) end,
    },
    win = {
      input = {
        keys = {
          ["<C-y><C-p>"] = { "yank_put_after", mode = { "n", "i" } },
          ["<C-y><C-o>"] = { "yank_put_before", mode = { "n", "i" } },
          ["<C-y><C-a>"] = { "yank_put_after_cursor", mode = { "n", "i" } },
          ["<C-y><C-b>"] = { "yank_put_before_cursor", mode = { "n", "i" } },
          ["<C-y><C-d>"] = { "yank_delete", mode = { "n", "i" } },
        },
      },
    },
  },

  lazygit = { enabled = true },

  image = { enabled = true },

  bigfile = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  words = { enabled = true },

  styles = {},
})

vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Snacks Explorer" })

-- local wk = require("which-key")
-- wk.add({
--   { "<leader>f", group = "Find", icon = "" },
--   {
--     "<leader>ff",
--     function() Snacks.picker.files({ hidden = true, layout = "ivy" }) end,
--     desc = "[F]ind [F]iles in current project",
--     icon = "󰈞",
--   },
--   {
--     "<leader>fg",
--     function() Snacks.picker.grep({ hidden = true }) end,
--     desc = "[F]ind [G]repping in current project",
--     icon = "󰨭",
--   },
--   {
--     "<leader>fF",
--     function() Snacks.picker.files({ cwd = "~/Documents/development/", hidden = true, layout = "ivy" }) end,
--     desc = "[F]ind [F]iles in all projects",
--     icon = "󰈞",
--   },
--   {
--     "<leader>fG",
--     function() Snacks.picker.grep({ cwd = "~/Documents/development/", hidden = true }) end,
--     desc = "[F]ind [G]repping in all projects",
--     icon = "󰨭",
--   },
--   {
--     "<leader>fc",
--     function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
--     desc = "[F]ind in [C]onfigurations",
--     icon = "",
--   },
--   {
--     "<leader>fw",
--     function() Snacks.picker.grep_word() end,
--     desc = "[F]ind current [W]ord",
--     icon = "󱎸",
--   },
--   {
--     "<leader>f/",
--     function() Snacks.picker.lines({ layout = "ivy" }) end,
--     desc = "[/] Live grep the current buffer",
--     icon = "󱦂",
--   },
--   {
--     "<leader>fh",
--     function() Snacks.picker.help() end,
--     desc = "[F]ind [H]elp",
--     icon = "󰋖",
--   },
--   {
--     "<leader>fk",
--     function() Snacks.picker.keymaps({ layout = "ivy" }) end,
--     desc = "[F]ind [K]eymaps",
--     icon = "",
--   },
--   {
--     "<leader>fd",
--     function() Snacks.picker.diagnostics_buffer() end,
--     desc = "[F]ind [D]iagnostics in buffers",
--     icon = "󰩂",
--   },
--   {
--     "<leader>fD",
--     function() Snacks.picker.diagnostics() end,
--     desc = "[F]ind [D]iagnostics in project",
--     icon = "󰩂",
--   },
--   {
--     "<leader>fi",
--     function() Snacks.picker.icons() end,
--     desc = "[F]ind [I]cons",
--     icon = "󰀻",
--   },
--   {
--     "<leader>fn",
--     function() Snacks.picker.notifications() end,
--     desc = "[F]ind [N]otifications",
--     icon = "󰵅",
--   },
-- })
