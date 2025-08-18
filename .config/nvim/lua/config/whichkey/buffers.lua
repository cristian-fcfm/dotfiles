local wk = require('which-key')

wk.add({
    { '<leader>b', group = 'Buffers', icon = '󰓩' },
    { '<leader>bb', '<cmd>enew<CR>', desc = 'Nuevo buffer', icon = '󰓩' },
    { '<leader>bx', '<cmd>bdelete!<CR>', desc = 'Cerrar buffer', icon = '󰅖' },
    { '<Tab>', '<cmd>bnext<CR>', desc = 'Siguiente buffer', icon = '󰒭' },
    { '<S-Tab>', '<cmd>bprevious<CR>', desc = 'Buffer anterior', icon = '󰒮' },
})
