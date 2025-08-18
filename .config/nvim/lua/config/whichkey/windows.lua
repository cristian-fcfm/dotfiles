local wk = require('which-key')

wk.add({
    { '<leader>w', group = 'Windows', icon = '󰃻' },
    { '<leader>wv', '<C-w>v', desc = 'Split vertical', icon = '' },
    { '<leader>wh', '<C-w>s', desc = 'Split horizontal', icon = '' },
    { '<leader>we', '<C-w>=', desc = 'Igualar tamaño ventanas', icon = '󰤼' },
    { '<leader>wx', ':close<CR>', desc = 'Cerrar ventana actual', icon = '󰅖' },
})
