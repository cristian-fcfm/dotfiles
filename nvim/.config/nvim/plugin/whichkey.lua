vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim", version = vim.version.range("*") },
  })

  local wk = require("which-key")
  wk.setup({
    preset = "modern",
    plugins = {
      spelling = true,
      presets = {
        operators = true, motions = true, text_objects = true,
        windows = true, nav = true, z = true, g = true,
      },
    },
    icons = { breadcrumb = "»", separator = "➜", group = "+" },
    win = { border = "rounded", padding = { 1, 2 } },
    layout = { spacing = 3 },
  })

  wk.add({
    { "<leader>b", group = "Buffers", icon = "󰓩" },
    { "<leader>bn", "<cmd>enew<CR>", desc = "New buffer", icon = "󰝜" },
    { "<leader>bd", "<cmd>bdelete!<CR>", desc = "Delete buffer", icon = "󰭌" },
    { "<leader>bo", "<cmd>%bd|e#|bd#<CR>", desc = "Close other buffers", icon = "󰈴" },
    { "<Tab>", "<cmd>bnext<CR>", desc = "Next buffer", icon = "󰒭" },
    { "<S-Tab>", "<cmd>bprevious<CR>", desc = "Previous buffer", icon = "󰒮" },
    {
      "<leader>bf",
      function() Snacks.picker.buffers({ layout = "ivy" }) end,
      desc = "[F]ind existing [B]uffers",
      icon = "󰓩",
    },
  })

  wk.add({
    { "<leader>t", group = "Tabs", icon = "󰓩" },
    { "<leader>tn", ":tabnew<CR>", desc = "New tab", icon = "󰝜" },
    { "<leader>tc", ":tabclose<CR>", desc = "Close tab", icon = "󰭌" },
    { "<leader>t]", ":tabn<CR>", desc = "Next tab", icon = "󰒭" },
    { "<leader>t[", ":tabp<CR>", desc = "Previous tab", icon = "󰒮" },
    { "<leader>to", ":tabonly<CR>", desc = "Close other tabs", icon = "󰈴" },
  })

  wk.add({
    { "<leader>w", group = "Windows", icon = "" },
    { "<leader>wv", "<C-w>v", desc = "Split vertical", icon = "" },
    { "<leader>ws", "<C-w>s", desc = "Split horizontal", icon = "" },
    { "<leader>we", "<C-w>=", desc = "Equal size", icon = "󰤼" },
    { "<leader>wc", ":close<CR>", desc = "Close window", icon = "󰅖" },
    { "<leader>wo", "<C-w>o", desc = "Close others", icon = "󰈴" },
  })
end)
