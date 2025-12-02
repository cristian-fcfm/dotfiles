return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- ============================================================================
    -- UI/Visual
    -- ============================================================================
    dashboard = {
      enabled = true,
      preset = {
        header = [[
        ⠀⠀⠀⢀⣀⣤⣤⣤⣤⣄⡀⠀⠀⠀⠀            
        ⠀⢀⣤⣾⣿⣾⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀           
        ⢠⣾⣿⢛⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀           
        ⣾⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧           
        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿           
        ⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⡵           
        ⢸⡇⠀⠀⠉⠛⠛⣿⣿⠛⠛⠉⠀⠀⣿⡇           
        ⢸⣿⣀⠀⢀⣠⣴⡇⠹⣦⣄⡀⠀⣠⣿⡇           
        ⠈⠻⠿⠿⣟⣿⣿⣦⣤⣼⣿⣿⠿⠿⠟⠀           
        ⠀⠀⠀⠀⠸⡿⣿⣿⢿⡿⢿⠇⠀⠀⠀⠀           
        ⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀⠀           ⠀
                       _           
 _ __   ___  _____   _(_)_ __ ___  
| '_ \ / _ \/ _ \ \ / / | '_ ` _ \ 
| | | |  __/ (_) \ V /| | | | | | |
|_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
    indent = {
      enabled = true,
      priority = 1,
      animate = {
        enabled = false,
      },
      hl = {
        "SnacksIndent1",
        "SnacksIndent2",
        "SnacksIndent3",
        "SnacksIndent4",
        "SnacksIndent5",
        "SnacksIndent6",
        "SnacksIndent7",
        "SnacksIndent8",
      },
    },
    notifier = {
      enabled = true,
    },
    statuscolumn = {
      enabled = true,
    },
    zen = {
      enabled = true,
    },

    -- ============================================================================
    -- Navigation/File Management
    -- ============================================================================
    explorer = {
      enabled = true,
    },
    picker = {
      enabled = true,
    },

    -- ============================================================================
    -- Git
    -- ============================================================================
    lazygit = {
      enabled = true,
    },

    -- ============================================================================
    -- Media
    -- ============================================================================
    image = {
      enabled = true,
    },

    -- ============================================================================
    -- Performance/Utility
    -- ============================================================================
    bigfile = {
      enabled = true,
    },
    input = {
      enabled = true,
    },
    quickfile = {
      enabled = true,
    },
    words = {
      enabled = true,
    },

    -- ============================================================================
    -- Styling
    -- ============================================================================
    styles = {},
  },
}
