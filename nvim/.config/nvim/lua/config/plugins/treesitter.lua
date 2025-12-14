-- Plugin para resaltado de sintaxis avanzado y otras mejoras de edición
return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- Cargar al inicio si se abre con archivo
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<Enter>", desc = "Increment Selection" },
      { "<Backspace>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
      -- Parsers específicos para tus necesidades
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "norg",
        "python",
        "query",
        "regex",
        "sql",
        "toml",
        "typst",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },

      -- Instalación automática de parsers al abrir archivos
      auto_install = true,

      highlight = {
        enable = true,
        -- Deshabilitar treesitter para archivos grandes
        disable = function(lang, buf)
          local max_filesize = 250 * 1024 -- 250 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        -- Mejora de performance
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
        disable = { "sql", "yaml" },
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Parser de D2 para treesitter
  {
    "ravsii/tree-sitter-d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*", -- usa el último tag en lugar de main
    build = "make nvim-install",
    ft = { "d2" },
  },

  -- Treesitter textobjects para movimiento y selección avanzada
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Saltar automáticamente al siguiente objeto
            keymaps = {
              -- Funciones
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              -- Clases
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- Condicionales
              ["ak"] = "@conditional.outer",
              ["ik"] = "@conditional.inner",
              -- Loops
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              -- Parámetros
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              -- Bloques
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              -- Comentarios
              ["a/"] = "@comment.outer",
            },
            selection_modes = {
              ["@function.outer"] = "V",
              ["@class.outer"] = "V",
              ["@block.outer"] = "V",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Agregar a jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              [">a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<a"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}
