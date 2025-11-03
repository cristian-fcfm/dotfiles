return {
  -- Mini.icons: Icon provider (reemplazo ligero de nvim-web-devicons)
  {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
    -- Optimización: Cargar icons solo cuando otro plugin lo requiera
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

  -- Mini.pairs: Auto-pairing de brackets, comillas, etc.
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    -- Optimización: Usar opts en lugar de config para evitar función anónima
    opts = {},
  },

  -- Mini.move: Mover líneas y bloques de texto
  {
    "echasnovski/mini.move",
    version = false,
    -- Optimización: Cargar solo al usar los keymaps
    keys = {
      { "<M-h>", mode = { "n", "v" } },
      { "<M-j>", mode = { "n", "v" } },
      { "<M-k>", mode = { "n", "v" } },
      { "<M-l>", mode = { "n", "v" } },
    },
    opts = {},
  },

  -- Mini.indentscope: Indicador visual de scope por indentación
  {
    "echasnovski/mini.indentscope",
    version = false,
    -- Optimización: Cargar solo después de leer archivos
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      symbol = "󰇙",
      options = { try_as_border = true },
      draw = {
        delay = 100,
        -- Optimización: Sin animación para mejor performance
        animation = function()
          return 0
        end,
      },
    },
    init = function()
      -- Optimización: Desactivar en filetypes que no lo necesitan
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "fzf",
          "oil",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Mini.surround: Encerrar texto en paréntesis, comillas, etc.
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
        add = "sa",            -- Add surrounding in Normal and Visual modes
        delete = "sd",         -- Delete surrounding
        find = "sf",           -- Find surrounding (to the right)
        find_left = "sF",      -- Find surrounding (to the left)
        highlight = "sh",      -- Highlight surrounding
        replace = "sr",        -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },

  -- Mini.comment: Comentar código de forma inteligente
  {
    "echasnovski/mini.comment",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      options = {
        -- Usar comentarios treesitter para mejor detección
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
      mappings = {
        comment = "gc",      -- Toggle comment en Normal y Visual
        comment_line = "gcc", -- Toggle comment de línea actual
        comment_visual = "gc", -- Toggle comment en Visual mode
        textobject = "gc",   -- Text object de comentario
      },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  },

  -- Mini.splitjoin: Dividir y unir argumentos/listas
  {
    "echasnovski/mini.splitjoin",
    version = false,
    keys = {
      { "gS", mode = { "n", "v" }, desc = "Toggle split/join" },
    },
    opts = {
      mappings = {
        toggle = "gS", -- Toggle split/join
      },
    },
  },
}
