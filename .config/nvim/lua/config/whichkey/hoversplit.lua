local wk = require('which-key')

wk.add({
  { '<leader>h', group = 'Documentación', icon = '󰈙' },
  { '<leader>hs', function() require('hoversplit').split_remain_focused() end, desc = 'Split horizontal (foco original)', icon = '' },
  { '<leader>hv', function() require('hoversplit').vsplit_remain_focused() end, desc = 'Split vertical (foco original)', icon = '󰤃' },
  { '<leader>hS', function() require('hoversplit').split() end, desc = 'Split horizontal (cambiar foco)', icon = '' },
  { '<leader>hV', function() require('hoversplit').vsplit() end, desc = 'Split vertical (cambiar foco)', icon = '󰤃' },
})
