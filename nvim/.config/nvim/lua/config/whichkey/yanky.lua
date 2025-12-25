local wk = require("which-key")

wk.add({
  { "<leader>y", group = "Yanky", icon = "󰆏" },
  {
    "<leader>yy",
    function()
      Snacks.picker.yanky({ layout = "ivy" })
    end,
    desc = "[Y]ank history",
    icon = "󰋚",
  },
  {
    "<leader>yc",
    "<cmd>YankyClearHistory<CR>",
    desc = "[C]lear history",
    icon = "󰃨",
  },

  -- Cycle through yank history
  {
    "[y",
    "<Plug>(YankyCycleForward)",
    desc = "Cycle yank forward",
    icon = "󰜱",
  },
  {
    "]y",
    "<Plug>(YankyCycleBackward)",
    desc = "Cycle yank backward",
    icon = "󰜴",
  },

  -- Put with indentation
  {
    "p",
    "<Plug>(YankyPutAfter)",
    desc = "Put after",
    mode = { "n", "x" },
  },
  {
    "P",
    "<Plug>(YankyPutBefore)",
    desc = "Put before",
    mode = { "n", "x" },
  },
  {
    "gp",
    "<Plug>(YankyGPutAfter)",
    desc = "Put after and move cursor",
    mode = { "n", "x" },
  },
  {
    "gP",
    "<Plug>(YankyGPutBefore)",
    desc = "Put before and move cursor",
    mode = { "n", "x" },
  },

  -- Put linewise
  {
    ">p",
    "<Plug>(YankyPutAfterLinewise)",
    desc = "Put after linewise",
    mode = { "n", "x" },
  },
  {
    ">P",
    "<Plug>(YankyPutBeforeLinewise)",
    desc = "Put before linewise",
    mode = { "n", "x" },
  },
  {
    "<p",
    "<Plug>(YankyPutAfterLinewise)",
    desc = "Put after linewise (open below)",
    mode = { "n", "x" },
  },
  {
    "<P",
    "<Plug>(YankyPutBeforeLinewise)",
    desc = "Put before linewise (open above)",
    mode = { "n", "x" },
  },
  {
    "=p",
    "<Plug>(YankyPutAfterFilter)",
    desc = "Put after with filter",
    mode = { "n", "x" },
  },
  {
    "=P",
    "<Plug>(YankyPutBeforeFilter)",
    desc = "Put before with filter",
    mode = { "n", "x" },
  },
})
