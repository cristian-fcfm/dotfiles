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

  -- Mini.ai: Text objects mejorados (a/i con custom patterns)
  {
    "echasnovski/mini.ai",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500, -- Buscar text objects hasta 500 líneas adelante/atrás
        custom_textobjects = {
          -- Función completa
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          -- Clase
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          -- Condicional
          o = ai.gen_spec.treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
          -- Argumento/parámetro
          a = ai.gen_spec.argument({ separator = "," }),
          -- Bloque de código
          b = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
          -- Llamada a función
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

  -- Mini.move: Mover líneas y bloques de código
  {
    "echasnovski/mini.move",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
