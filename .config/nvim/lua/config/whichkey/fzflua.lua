local wk = require("which-key")

wk.add({
  { "<leader>f", group = "Find", icon = "" },
  {
    "<leader>ff",
    function()
      Snacks.picker.files()
    end,
    desc = "[F]ind [F]iles in directory",
    icon = "󰈞",
  },
  {
    "<leader>fg",
    function()
      Snacks.picker.grep()
    end,
    desc = "[F]ind [G]repping in project",
    icon = "󰨭",
  },
  {
    "<leader>fc",
    function()
      Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "[F]ind in [C]onfigurations",
    icon = "",
  },
  {
    "<leader>fh",
    function()
      Snacks.picker.help()
    end,
    desc = "[F]ind [H]elp",
    icon = "󰋖",
  },
  {
    "<leader>fk",
    function()
      Snacks.picker.keymaps()
    end,
    desc = "[F]ind [K]eymaps",
    icon = "",
  },
  {
    "<leader>fb",
    function()
      Snacks.picker.pickers()
    end,
    desc = "[F]ind [B]uiltin Pickers",
    icon = "",
  },
  {
    "<leader>fw",
    function()
      Snacks.picker.grep_word()
    end,
    desc = "[F]ind current [W]ord",
    icon = "󱎸",
  },
  {
    "<leader>fd",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "[F]ind [D]iagnostics",
    icon = "",
  },
  {
    "<leader>fr",
    function()
      Snacks.picker.resume()
    end,
    desc = "[F]ind [R]esume",
    icon = "",
  },
  {
    "<leader>fo",
    function()
      Snacks.picker.recent()
    end,
    desc = "[F]ind [O]ld Files",
    icon = "",
  },
  {
    "<leader>f<leader>",
    function()
      Snacks.picker.buffers()
    end,
    desc = "[ ] Find existing buffers",
    icon = "",
  },
  {
    "<leader>f/",
    function()
      Snacks.picker.lines()
    end,
    desc = "[/] Live grep the current buffer",
    icon = "",
  },
})
