local wk = require('which-key')

wk.add({
    { '<leader>b', group = 'Buffers', icon = '󰓩' },
    { '<leader>bn', '<cmd>enew<CR>', desc = 'New buffer', icon = '󰓩' },
    { '<leader>bd', '<cmd>bdelete!<CR>', desc = 'Delete buffer', icon = '󰅖' },
    { '<leader>bp', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer', icon = '󰒅' },
    { '<leader>bc', '<cmd>BufferLinePickClose<CR>', desc = 'Pick & close', icon = '󰅙' },
    { '<leader>bh', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close left buffers', icon = '󰍺' },
    { '<leader>bl', '<cmd>BufferLineCloseRight<CR>', desc = 'Close right buffers', icon = '󰍻' },
    { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers', icon = '󰝌' },
    { '<Tab>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer', icon = '󰒭' },
    { '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer', icon = '󰒮' },
})
