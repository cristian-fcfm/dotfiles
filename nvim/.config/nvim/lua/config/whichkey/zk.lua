local wk = require("which-key")

wk.add({
  { "<leader>z", group = "Zettelkasten", icon = "󰠮" },

  -- Main note operations
  {
    "<leader>zn",
    function()
      local title = vim.fn.input("Title: ")
      if title ~= "" then
        require("zk").new({ title = title })
      end
    end,
    desc = "[N]ew note",
    icon = "󱘒",
  },
  {
    "<leader>zo",
    function()
      require("zk").edit({ sort = { "modified" } }, { multi_select = false })
    end,
    desc = "[O]pen notes",
    icon = "󰹕",
  },
  {
    "<leader>zt",
    function()
      local zk = require("zk")
      zk.pick_tags(nil, { multi_select = false }, function(tags)
        zk.edit({ tags = tags }, { multi_select = false })
      end)
    end,
    desc = "Search by [T]ags",
    icon = "󱙓",
  },

  -- Search and find
  { "<leader>zf", group = "[F]ind", icon = "󱙓" },
  {
    "<leader>zff",
    function()
      local search = vim.fn.input("Search: ")
      if search ~= "" then
        require("zk").edit({ match = { search } }, { multi_select = false })
      end
    end,
    desc = "[F]ind notes",
    icon = "󱙓",
  },
  {
    "<leader>zfs",
    function()
      require("zk").edit({ matchSelection = true }, { multi_select = false })
    end,
    desc = "[S]election search",
    icon = "󱙓",
    mode = "v",
  },
  {
    "<leader>zfr",
    function()
      require("zk").edit({ sort = { "modified" }, limit = 10 }, { multi_select = false })
    end,
    desc = "[R]ecent notes",
    icon = "󰋚",
  },

  -- Links and backlinks
  { "<leader>zl", group = "[L]inks", icon = "󰹕" },
  {
    "<leader>zll",
    function()
      require("zk").edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { multi_select = false })
    end,
    desc = "Show [L]inks from here",
    icon = "󰹕",
  },
  {
    "<leader>zlb",
    function()
      require("zk").edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { multi_select = false })
    end,
    desc = "Show [B]acklinks",
    icon = "󰹕",
  },
  {
    "<leader>zli",
    function()
      local zk = require("zk")
      zk.pick_notes({ matchSelection = true }, { multi_select = false }, function(notes)
        zk.insert_link(notes)
      end)
    end,
    desc = "[I]nsert link (selection)",
    icon = "󰹕",
    mode = "v",
  },
  {
    "<leader>zln",
    function()
      local zk = require("zk")
      zk.pick_notes(nil, { multi_select = false }, function(notes)
        zk.insert_link(notes)
      end)
    end,
    desc = "Insert [N]ote link",
    icon = "󰹕",
  },

  -- Daily notes
  { "<leader>zd", group = "[D]aily notes", icon = "󱓧" },
  {
    "<leader>zdt",
    function()
      require("zktools.dates").create_daily_note(0)
    end,
    desc = "[T]oday",
    icon = "󰃭",
  },
  {
    "<leader>zdy",
    function()
      require("zktools.dates").create_daily_note(-1)
    end,
    desc = "[Y]esterday",
    icon = "󰃮",
  },
  {
    "<leader>zdm",
    function()
      require("zktools.dates").create_daily_note(1)
    end,
    desc = "To[m]orrow",
    icon = "󰃯",
  },
  {
    "<leader>zdo",
    function()
      require("zk").edit({ hrefs = { "0-reviews/4-daily" } }, { multi_select = false })
    end,
    desc = "[O]pen daily note",
    icon = "󱨋",
  },

  -- Weekly notes
  { "<leader>zw", group = "[W]eekly notes", icon = "󱨳" },
  {
    "<leader>zwn",
    function()
      require("zktools.dates").create_weekly_note()
    end,
    desc = "[N]ew weekly note",
    icon = "󱘒",
  },
  {
    "<leader>zwo",
    function()
      require("zk").edit({ hrefs = { "0-reviews/3-weekly" } }, { multi_select = false })
    end,
    desc = "[O]pen weekly note",
    icon = "󱨋",
  },

  -- Monthly notes
  { "<leader>zm", group = "[M]onthly notes", icon = "󰸗" },
  {
    "<leader>zmn",
    function()
      require("zktools.dates").create_monthly_note()
    end,
    desc = "[N]ew monthly note",
    icon = "󱘒",
  },
  {
    "<leader>zmo",
    function()
      require("zk").edit({ hrefs = { "0-reviews/2-monthly" } }, { multi_select = false })
    end,
    desc = "[O]pen monthly note",
    icon = "󱨋",
  },

  -- Yearly notes
  { "<leader>zy", group = "[Y]early notes", icon = "󰸘" },
  {
    "<leader>zyn",
    function()
      require("zktools.dates").create_yearly_note()
    end,
    desc = "[N]ew yearly note",
    icon = "󱘒",
  },
  {
    "<leader>zyo",
    function()
      require("zk").edit({ hrefs = { "0-reviews/1-yearly" } }, { multi_select = false })
    end,
    desc = "[O]pen yearly note",
    icon = "󱨋",
  },

  -- Projects
  { "<leader>zp", group = "[P]rojects", icon = "󰸕" },
  {
    "<leader>zpn",
    function()
      require("zktools.projects").create_project_interactive()
    end,
    desc = "[N]ew project",
    icon = "󱘒",
  },
  {
    "<leader>zpo",
    function()
      require("zktools.projects").open_projects()
    end,
    desc = "[O]pen project",
    icon = "󱨋",
  },

  -- Areas
  { "<leader>za", group = "[A]reas", icon = "󰹕" },
  {
    "<leader>zan",
    function()
      require("zktools.projects").create_area()
    end,
    desc = "[N]ew area",
    icon = "󱘒",
  },
  {
    "<leader>zao",
    function()
      require("zktools.projects").open_areas()
    end,
    desc = "[O]pen areas",
    icon = "󱨋",
  },

  -- Resources
  { "<leader>zr", group = "[R]esources", icon = "󰠮" },
  {
    "<leader>zrn",
    function()
      require("zktools.projects").create_resource()
    end,
    desc = "[N]ew resource",
    icon = "󱘒",
  },
  {
    "<leader>zro",
    function()
      require("zktools.projects").open_resources()
    end,
    desc = "[O]pen resources",
    icon = "󱨋",
  },
})
