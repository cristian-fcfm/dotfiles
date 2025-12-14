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

  -- Lazygit (Snacks)
  { "<leader>g", group = "Git", icon = "" },
  {
    "<leader>gg",
    function()
      Snacks.lazygit()
    end,
    desc = "Lazygit",
    icon = "",
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

  -- Gitsigns toggles
  { "<leader>gt", group = "Toggle Git Signs", icon = "󰨙" },
  {
    "<leader>gtb",
    function()
      gs.toggle_current_line_blame()
    end,
    desc = "Toggle Blame",
  },
  {
    "<leader>gtn",
    function()
      gs.toggle_numhl()
    end,
    desc = "Toggle Number Highlight",
  },
  {
    "<leader>gtl",
    function()
      gs.toggle_linehl()
    end,
    desc = "Toggle Line Highlight",
  },
  {
    "<leader>gts",
    function()
      gs.toggle_signs()
    end,
    desc = "Toggle Signs",
  },
  {
    "<leader>gtd",
    function()
      gs.toggle_deleted()
    end,
    desc = "Toggle Deleted",
  },
})
