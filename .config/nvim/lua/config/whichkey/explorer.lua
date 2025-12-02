local wk = require("which-key")

wk.add({
  -- Oil.nvim (buffer-style file manager)
  {
    ".",
    "<cmd>Oil<cr>",
    desc = "Oil (normal)",
    icon = "󰏇",
  },
  {
    "--",
    "<cmd>Oil --float<cr>",
    desc = "Oil (float)",
    icon = "󰏇",
  },

  -- Snacks Explorer (tree-style file manager)
  {
    "<leader>e",
    function()
      Snacks.explorer()
    end,
    desc = "Snacks Explorer",
    icon = "󰙅",
  },
})
