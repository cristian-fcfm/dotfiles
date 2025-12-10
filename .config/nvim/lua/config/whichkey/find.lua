local wk = require("which-key")

wk.add({
  { "<leader>f", group = "Find", icon = "" },
  {
    "<leader>ff",
    function()
      Snacks.picker.files({
        hidden = true,
        layout = "ivy",
      })
    end,
    desc = "[F]ind [F]iles in current project",
    icon = "󰈞",
  },
  {
    "<leader>fg",
    function()
      Snacks.picker.grep({
        hidden = true,
      })
    end,
    desc = "[F]ind [G]repping in current project",
    icon = "󰨭",
  },
  {
    "<leader>fF",
    function()
      Snacks.picker.files({
        cwd = "~/Documents/development/",
        hidden = true,
        layout = "ivy",
      })
    end,
    desc = "[F]ind [F]iles in all projects",
    icon = "󰈞",
  },
  {
    "<leader>fG",
    function()
      Snacks.picker.grep({
        cwd = "~/Documents/development/",
        hidden = true,
      })
    end,
    desc = "[F]ind [G]repping in all projects",
    icon = "󰨭",
  },
  {
    "<leader>fc",
    function()
      Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
    end,
    desc = "[F]ind in [C]onfigurations",
    icon = "",
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
    "<leader>f/",
    function()
      Snacks.picker.lines({
        layout = "ivy",
      })
    end,
    desc = "[/] Live grep the current buffer",
    icon = "󱦂",
  },
})
