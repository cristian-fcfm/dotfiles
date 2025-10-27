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
        require('config.whichkey.slime')
        require('config.whichkey.fzflua')
        require('config.whichkey.todocomments')
        require('config.whichkey.buffers')
        require('config.whichkey.comment')
        require('config.whichkey.gitsigns')
        require('config.whichkey.lsp')
    end,
}
