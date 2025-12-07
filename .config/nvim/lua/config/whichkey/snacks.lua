local wk = require("which-key")

wk.add({
  { "<leader>z", group = "Zen", icon = "󰚀" },
  {
    "<leader>zz",
    function()
      Snacks.zen()
    end,
    desc = "Toggle Zen Mode",
    icon = "󰚀",
  },
  {
    "<leader>zZ",
    function()
      Snacks.zen.zoom()
    end,
    desc = "Toggle Zoom",
    icon = "",
  },
  {
    "<leader>e",
    function()
      Snacks.explorer()
    end,
    desc = "Toggle Explorer",
    icon = "󰙅",
  },
  {
    "<leader>.",
    function()
      Snacks.dashboard()
    end,
    desc = "Dashboard",
    icon = "",
  },
  { "<leader>u", group = "UI", icon = "󰙵" },
  {
    "<leader>ut",
    function()
      Snacks.picker.colorschemes()
    end,
    desc = "Theme Picker",
    icon = "󰏘",
  },
})
