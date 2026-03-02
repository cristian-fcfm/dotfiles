return {
  -- Mini.icons: Icon provider (lightweight nvim-web-devicons replacement)
  {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
    -- Optimization: only load when another plugin requires it
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    config = function()
      require("mini.icons").setup()
      require("mini.icons").tweak_lsp_kind()
    end,
  },

  -- Mini.surround: Wrap text in parentheses, quotes, etc.
  {
    "echasnovski/mini.surround",
    version = false,
    keys = {
      { "sa", mode = { "n", "v" }, desc = "Add surrounding" },
      { "sd", mode = "n", desc = "Delete surrounding" },
      { "sr", mode = "n", desc = "Replace surrounding" },
      { "sf", mode = "n", desc = "Find surrounding" },
      { "sh", mode = "n", desc = "Highlight surrounding" },
    },
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },

  -- Mini.comment: Smart code commenting
  {
    "echasnovski/mini.comment",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        comment = "gc", -- Toggle comment in Normal and Visual
        comment_line = "gcc", -- Toggle comment on current line
        comment_visual = "gc", -- Toggle comment in Visual mode
        textobject = "gc", -- Comment text object
      },
    },
  },

  -- Mini.splitjoin: Split and join arguments/lists
  -- NOTE: Remapped from gS to gJ to avoid conflict with LSP workspace symbols (gS)
  {
    "echasnovski/mini.splitjoin",
    version = false,
    keys = {
      { "gJ", mode = { "n", "v" }, desc = "Toggle split/join" },
    },
    opts = {
      mappings = {
        toggle = "gJ", -- Toggle split/join (gS is used by LSP workspace symbols)
      },
    },
  },

  -- Mini.ai: Enhanced text objects (a/i with custom patterns)
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500, -- Search text objects up to 500 lines forward/backward
        custom_textobjects = {
          -- Function (outer/inner)
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          -- Class
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          -- Conditional/loop
          o = ai.gen_spec.treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
          -- Argument/parameter
          a = ai.gen_spec.argument({ separator = "," }),
          -- Code block
          b = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
          -- Function call
          F = ai.gen_spec.function_call(),
          -- TODO/FIXME/NOTE/HACK/WARNING
          g = function(mode)
            local comment_patterns = {
              "TODO", "FIXME", "NOTE", "HACK", "WARNING", "XXX", "BUG", "PERF", "TEST"
            }
            local pattern = table.concat(comment_patterns, "|")
            return ai.gen_spec.pair("(%s*" .. pattern .. ")", "$", { type = "line" })(mode)
          end,
        },
      }
    end,
  },

  -- Mini.move: Move lines and blocks of code
  -- NOTE: Remapped from Alt+HJKL to Ctrl+Shift+HJKL because:
  --   1. Alt conflicts with GACS HRM (ring finger = Alt on S/L)
  --   2. Ctrl+Shift+HJKL was freed up: Kitty split nav moved to Ctrl+HJKL (smart-splits)
  --   3. Kitty passes Ctrl+Shift+HJKL through to Neovim (--when-focus-on var:IS_NVIM)
  {
    "echasnovski/mini.move",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Visual mode: move selection
        left = "<C-S-h>",
        right = "<C-S-l>",
        down = "<C-S-j>",
        up = "<C-S-k>",
        -- Normal mode: move current line
        line_left = "<C-S-h>",
        line_right = "<C-S-l>",
        line_down = "<C-S-j>",
        line_up = "<C-S-k>",
      },
    },
  },
}
