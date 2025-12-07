return {
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")

      -- Cargar snippets de friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Cargar tus snippets personalizados
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })

      -- Keymaps para navegar entre placeholders
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { silent = true, desc = "LuaSnip: Expand or jump forward" })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { silent = true, desc = "LuaSnip: Jump backward" })

      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { silent = true, desc = "LuaSnip: Change choice" })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
      "saghen/blink.compat",
      { "chrisgrieser/cmp-nerdfont", lazy = true },
      { "SergioRibera/cmp-dotenv", lazy = true },
      { "hrsh7th/cmp-emoji", lazy = true },
      { "chrisgrieser/cmp-yanky", lazy = true },
    },
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },

      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = false,
      },

      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },

      signature = {
        enabled = true,
        window = { border = "single" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji", "nerdfont", "dotenv", "yanky" },
        providers = {
          buffer = {
            max_items = 4,
            min_keyword_length = 4,
          },
          emoji = {
            module = "blink.compat.source",
            name = "emoji",
            score_offset = 15,
            opts = {},
          },
          nerdfont = {
            module = "blink.compat.source",
            name = "nerdfont",
            score_offset = 10,
            opts = {},
          },
          dotenv = {
            module = "blink.compat.source",
            name = "dotenv",
            score_offset = 5,
          },
          yanky = {
            module = "blink.compat.source",
            name = "cmp_yanky",
            score_offset = 8,
          },
        },
      },

      snippets = {
        preset = "luasnip",
      },

      cmdline = {
        enabled = true,
      },

      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = {
          download = true,
          force_version = nil,
        },
      },
    },
    opts_extend = { "sources.default" },
  },
}
