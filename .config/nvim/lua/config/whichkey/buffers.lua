local wk = require("which-key")

wk.add({
  { "<leader>b", group = "Buffers", icon = "󰓩" },
  { "<leader>bn", "<cmd>enew<CR>", desc = "New buffer", icon = "󰝜" },
  { "<leader>bd", "<cmd>bprevious | bdelete! #<CR>", desc = "Delete buffer", icon = "󰭌" },
  { "<leader>bD", "<cmd>bdelete!<CR>", desc = "Force delete buffer", icon = "󰭌" },
  { "<leader>bo", "<cmd>%bd|e#|bd#<CR>", desc = "Close other buffers", icon = "󰈴" },
  -- Buffer navigation
  { "<Tab>", "<cmd>bnext<CR>", desc = "Next buffer", icon = "󰒭" },
  { "<S-Tab>", "<cmd>bprevious<CR>", desc = "Previous buffer", icon = "󰒮" },
})
