return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = { "<leader>", "<localleader>", '"', "'", "`", "c", "v", "g" },
  opts = {
    preset = "modern",
    plugins = {
      spelling = true,
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      spacing = 3,
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Cargar los archivos de configuración
    require("config.whichkey.windows")
    require("config.whichkey.tabs")
    require("config.whichkey.slime")
    require("config.whichkey.fzflua")
    require("config.whichkey.todocomments")
    require("config.whichkey.buffers")
    require("config.whichkey.explorer")
    require("config.whichkey.git")
    require("config.whichkey.lsp")
    require("config.whichkey.trouble")
    require("config.whichkey.typst")
    require("config.whichkey.snacks")
    require("config.whichkey.neorg")
    require("config.whichkey.yanky")
  end,
}
