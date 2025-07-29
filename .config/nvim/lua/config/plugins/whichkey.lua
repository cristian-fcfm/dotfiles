return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    plugins = { spelling = true },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)

    -- Cargar los archivos de configuración
    require('config.whichkey.windows')
    require('config.whichkey.tabs')
    require('config.whichkey.hoversplit')
    require('config.whichkey.iron')
    require('config.whichkey.fzflua')
  end,
}
