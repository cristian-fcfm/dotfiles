local wk = require("which-key")

wk.add({
  -- ========================================================================
  -- NAVIGATION
  -- ========================================================================
  { "<leader>n", group = "Neorg", icon = "" },

  -- ========================================================================
  -- JOURNAL
  -- ========================================================================
  { "<leader>nj", group = "Journal", icon = "󰠮" },

  -- Día
  {
    "<leader>njt",
    "<cmd>Neorg journal today<CR>",
    desc = "Journal Today",
    icon = "󰃰",
  },
  {
    "<leader>njy",
    "<cmd>Neorg journal yesterday<CR>",
    desc = "Journal Yesterday",
    icon = "󰃰",
  },
  {
    "<leader>njm",
    "<cmd>Neorg journal tomorrow<CR>",
    desc = "Journal Tomorrow",
    icon = "󰃰",
  },

  -- ========================================================================
  -- WORKSPACE
  -- ========================================================================
  { "<leader>nw", group = "Workspace", icon = "" },
  {
    "<leader>nwn",
    "<cmd>Neorg workspace notes<CR>",
    desc = "Workspace Notes",
    icon = "",
  },
  {
    "<leader>nwr",
    "<cmd>Neorg workspace reviews<CR>",
    desc = "Workspace Reviews",
    icon = "",
  },
  {
    "<leader>nwp",
    "<cmd>Neorg workspace projects<CR>",
    desc = "Workspace Projects",
    icon = "",
  },
  {
    "<leader>nwa",
    "<cmd>Neorg workspace areas<CR>",
    desc = "Workspace Areas",
    icon = "",
  },
  {
    "<leader>nws",
    "<cmd>Neorg workspace resources<CR>",
    desc = "Workspace Resources",
    icon = "",
  },

  -- ========================================================================
  -- INDEX & TOC
  -- ========================================================================
  {
    "<leader>ni",
    "<cmd>Neorg index<CR>",
    desc = "Open Index",
    icon = "󰈙",
  },
  {
    "<leader>nt",
    "<cmd>Neorg toc<CR>",
    desc = "Table of Contents",
    icon = "",
  },

  -- ========================================================================
  -- EXPORT
  -- ========================================================================
  { "<leader>ne", group = "Export", icon = "󰈝" },
  {
    "<leader>nem",
    "<cmd>Neorg export to-file markdown<CR>",
    desc = "Export to Markdown",
    icon = "",
  },

  -- ========================================================================
  -- RETURN
  -- ========================================================================
  {
    "<leader>nr",
    "<cmd>Neorg return<CR>",
    desc = "Return/Close Neorg",
    icon = "󰩈",
  },
})
