local wk = require("which-key")

wk.add({
  { "<leader>w", group = "Windows", icon = "" },
  { "<leader>wv", "<C-w>v", desc = "Split vertical", icon = "" },
  { "<leader>ws", "<C-w>s", desc = "Split horizontal", icon = "" },
  { "<leader>we", "<C-w>=", desc = "Equal size", icon = "󰤼" },
  { "<leader>wc", ":close<CR>", desc = "Close window", icon = "󰅖" },
  { "<leader>wo", "<C-w>o", desc = "Close others", icon = "󰈴" },
})
