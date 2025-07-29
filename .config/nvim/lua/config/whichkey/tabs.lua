local wk = require('which-key')

wk.add({
  { '<leader>t', group = 'Tabs', icon = '󰓩' },
  { '<leader>to', ':tabnew<CR>', desc = 'Abrir nueva tab', icon = '' },
  { '<leader>tx', ':tabclose<CR>', desc = 'Cerrar tab actual', icon = '󰅖' },
  { '<leader>tn', ':tabn<CR>', desc = 'Siguiente tab', icon = '' },
  { '<leader>tp', ':tabp<CR>', desc = 'Tab anterior', icon = '' },
})
