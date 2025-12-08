local wk = require("which-key")

wk.add({
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
      Snacks.picker.keymaps({ layout = "ivy" })
    end,
    desc = "[F]ind [K]eymaps",
    icon = "",
  },
  {
    "<leader>fd",
    function()
      Snacks.picker.diagnostics_buffer()
    end,
    desc = "[F]ind [D]iagnostics in buffers",
    icon = "󰩂",
  },
  {
    "<leader>fD",
    function()
      Snacks.picker.diagnostics()
    end,
    desc = "[F]ind [D]iagnostics in project",
    icon = "󰩂",
  },
  {
    "<leader>fi",
    function()
      Snacks.picker.icons()
    end,
    desc = "[F]ind [I]cons",
    icon = "󰀻",
  },
  {
    "<leader>fn",
    function()
      Snacks.picker.notifications()
    end,
    desc = "[F]ind [N]otifications",
    icon = "󰵅",
  },
})
