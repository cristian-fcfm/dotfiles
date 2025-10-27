local wk = require('which-key')

wk.add({
    { '<leader>b', group = 'Buffers', icon = '󰓩' },
    { '<leader>bb', '<cmd>enew<CR>', desc = 'Nuevo buffer', icon = '󰓩' },
    { '<leader>bx', '<cmd>bdelete!<CR>', desc = 'Cerrar buffer', icon = '󰅖' },
    { '<leader>bp', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer', icon = '󰒅' },
    { '<leader>bc', '<cmd>BufferLinePickClose<CR>', desc = 'Pick & close buffer', icon = '󰅙' },
    { '<leader>bh', '<cmd>BufferLineCloseLeft<CR>', desc = 'Cerrar buffers izquierda', icon = '󰍺' },
    { '<leader>bl', '<cmd>BufferLineCloseRight<CR>', desc = 'Cerrar buffers derecha', icon = '󰍻' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Cerrar otros buffers', icon = '󰝌' },
    { '<Tab>', '<cmd>BufferLineCycleNext<CR>', desc = 'Siguiente buffer', icon = '󰒭' },
    { '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Buffer anterior', icon = '󰒮' },
})
