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
}
