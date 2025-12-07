return {
  -- TokyoNight theme
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      on_highlights = function(hl, c)
        hl.LineNr = { fg = c.purple, bg = c.bg_gutter }
        hl.LineNrAbove = { fg = c.purple, bg = c.bg_gutter }
        hl.LineNrBelow = { fg = c.purple, bg = c.bg_gutter }
        hl.CursorLineNr = { fg = "#ff9e64", bold = true, bg = c.bg_gutter }
      end,
    },
  },

  -- Nightfox theme (carbonfox, duskfox, etc.)
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
  },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha", -- mocha, macchiato, frappe, latte
      transparent_background = false,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
      },
    },
  },

  -- Kanagawa theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      compile = false,
      transparent = false,
      theme = "wave", -- wave, dragon, lotus
    },
  },

  -- Rose Pine theme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "moon", -- moon, main, dawn
      dark_variant = "moon",
      styles = {
        italic = true,
        transparency = false,
      },
    },
  },
}
