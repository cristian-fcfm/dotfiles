local wk = require("which-key")

wk.add({
  { "<leader>x", group = "Trouble", icon = "󱏒" },
  {
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    desc = "Diagnostics in the project",
    icon = "󰩂",
  },
  {
    "<leader>xX",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    desc = "Buffer Diagnostics",
    icon = "󰩂",
  },
  {
    "<leader>xs",
    "<cmd>Trouble symbols toggle focus=false pinned=true win.relative=win win.position=right<cr>",
    desc = "Symbols",
    icon = "",
  },
  {
    "<leader>xl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    desc = "LSP Definitions / References",
    icon = "󰊕",
  },
  {
    "<leader>xL",
    "<cmd>Trouble loclist toggle<cr>",
    desc = "Location List",
    icon = "󰕲",
  },
  {
    "<leader>xQ",
    "<cmd>Trouble qflist toggle<cr>",
    desc = "Quickfix List",
    icon = "󰕲",
  },
  {
    "<leader>xt",
    "<cmd>Trouble todo toggle focus=false pinned=true win.relative=win win.position=right<cr>",
    desc = "Todo Comments",
    icon = "",
  },
})
