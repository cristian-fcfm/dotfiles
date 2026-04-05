local function load_yanky()
  vim.pack.add({
    "https://github.com/kkharji/sqlite.lua",
    { src = "https://github.com/gbprod/yanky.nvim", version = vim.version.range("*") },
  })

  require("yanky").setup({
    ring = {
      history_length = 100,
      storage = "sqlite",
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
    },
    system_clipboard = { sync_with_ring = true, clipboard_register = "+" },
    highlight = { on_put = true, on_yank = true, timer = 150 },
    preserve_cursor_position = { enabled = true },
    textobj = { enabled = true },
  })

  local wk = require("which-key")
  wk.add({
    { "<leader>y", group = "Yanky", icon = "󰆏" },
    { "<leader>yy", function() Snacks.picker.yanky({ layout = "ivy" }) end, desc = "[Y]ank history", icon = "󰋚" },
    { "<leader>yc", "<cmd>YankyClearHistory<CR>", desc = "[C]lear history", icon = "󰃨" },
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle yank forward", icon = "󰜱" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle yank backward", icon = "󰜴" },
    { "p", "<Plug>(YankyPutAfter)", desc = "Put after", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", desc = "Put before", mode = { "n", "x" } },
    { "gp", "<Plug>(YankyGPutAfter)", desc = "Put after and move cursor", mode = { "n", "x" } },
    { "gP", "<Plug>(YankyGPutBefore)", desc = "Put before and move cursor", mode = { "n", "x" } },
    { ">p", "<Plug>(YankyPutAfterLinewise)", desc = "Put after linewise", mode = { "n", "x" } },
    { ">P", "<Plug>(YankyPutBeforeLinewise)", desc = "Put before linewise", mode = { "n", "x" } },
    { "<p", "<Plug>(YankyPutAfterLinewise)", desc = "Put after linewise (open below)", mode = { "n", "x" } },
    { "<P", "<Plug>(YankyPutBeforeLinewise)", desc = "Put before linewise (open above)", mode = { "n", "x" } },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after with filter", mode = { "n", "x" } },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before with filter", mode = { "n", "x" } },
  })
end

load_yanky()
