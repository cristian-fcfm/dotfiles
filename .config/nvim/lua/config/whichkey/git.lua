local wk = require("which-key")
local gs = require("gitsigns")

wk.add({
  { "<leader>h", group = "Git Hunks", icon = "" },
  { "<leader>hp", gs.preview_hunk, desc = "[P]review hunk", icon = "󰙤" },
  {
    "<leader>hb",
    function()
      gs.blame_line({ full = true })
    end,
    desc = "[B]lame hunk",
    icon = "",
  },
  {
    "]g",
    function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end,
    desc = "Next git hunk",
    expr = true,
    icon = "󰒭",
  },
  {
    "[g",
    function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end,
    desc = "Previous git hunk",
    expr = true,
    icon = "󰒮",
  },

  -- Navegación de conflictos de merge
  {
    "]m",
    function()
      vim.cmd([[/^<<<<<<< ]])
    end,
    desc = "Next merge conflict",
    icon = "󰒭",
  },
  {
    "[m",
    function()
      vim.cmd([[?^<<<<<<< ]])
    end,
    desc = "Previous merge conflict",
    icon = "󰒮",
  },

  -- Comandos útiles para resolver conflictos
  { "<leader>hm", group = "Merge conflicts", icon = "" },
  { "<leader>hmo", "<cmd>GitConflictChooseOurs<CR>", desc = "Choose ours (current)", icon = "󰒮" },
  { "<leader>hmt", "<cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs (incoming)", icon = "󰒭" },
  { "<leader>hmb", "<cmd>GitConflictChooseBoth<CR>", desc = "Choose both", icon = "" },
  { "<leader>hmn", "<cmd>GitConflictChooseNone<CR>", desc = "Choose none", icon = "󰝾" },
  { "<leader>hml", "<cmd>GitConflictListQf<CR>", desc = "List conflicts", icon = "" },

  -- Lazygit (Snacks)
  { "<leader>g", group = "Git", icon = "" },
  {
    "<leader>gg",
    function()
      Snacks.lazygit()
    end,
    desc = "Lazygit",
    icon = "",
  },
  {
    "<leader>gf",
    function()
      Snacks.lazygit.log_file()
    end,
    desc = "Lazygit File History",
    icon = "󰉛",
  },
  {
    "<leader>gl",
    function()
      Snacks.lazygit.log()
    end,
    desc = "Lazygit Log",
    icon = "󰜘",
  },
})
