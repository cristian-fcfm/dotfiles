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

  -- Mini.surround: Encerrar texto en paréntesis, comillas, etc.
  {
    "echasnovski/mini.surround",
    version = false,
    keys = {
      { "sa", mode = { "n", "v" }, desc = "Agregar surrounding" },
      { "sd", mode = "n", desc = "Eliminar surrounding" },
      { "sr", mode = "n", desc = "Reemplazar surrounding" },
      { "sf", mode = "n", desc = "Buscar surrounding" },
      { "sh", mode = "n", desc = "Resaltar surrounding" },
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

  -- Mini.comment: Comentar código de forma inteligente
  {
    "echasnovski/mini.comment",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = {
        comment = "gc", -- Toggle comment en Normal y Visual
        comment_line = "gcc", -- Toggle comment de línea actual
        comment_visual = "gc", -- Toggle comment en Visual mode
        textobject = "gc", -- Text object de comentario
      },
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
