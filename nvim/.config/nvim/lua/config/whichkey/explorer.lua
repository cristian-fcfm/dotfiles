local wk = require("which-key")

wk.add({
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
