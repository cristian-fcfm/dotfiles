local wk = require("which-key")

wk.add({
  { "<leader>t", group = "Tabs", icon = "󰓩" },
  { "<leader>tn", ":tabnew<CR>", desc = "New tab", icon = "󰝜" },
  { "<leader>tc", ":tabclose<CR>", desc = "Close tab", icon = "󰭌" },
  { "<leader>t]", ":tabn<CR>", desc = "Next tab", icon = "󰒭" },
  { "<leader>t[", ":tabp<CR>", desc = "Previous tab", icon = "󰒮" },
  { "<leader>to", ":tabonly<CR>", desc = "Close other tabs", icon = "󰈴" },
})
