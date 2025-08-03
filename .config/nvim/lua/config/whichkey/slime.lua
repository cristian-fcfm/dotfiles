local wk = require('which-key')

wk.add({
  { '<leader>s', group = 'Slime REPL', icon = '󰞷' },
  { '<leader>sc', '<Plug>SlimeSendCell', desc = 'Send cell', icon = '󱐪' },
  { '<leader>ss', '<Plug>SlimeParagraphSend', desc = 'Send paragraph', icon = '󰈔' },
  { '<leader>sl', '<Plug>SlimeLineSend', desc = 'Send line', icon = '󰘤' },
  { '<leader>sr', ':SlimeSend1 %reset -f<CR>', desc = 'Reset IPython', icon = '󰑓' },
  { '<leader>si', ':SlimeSend1 whos<CR>', desc = 'Show variables', icon = '󰋽' },
  { '<leader>sn', desc = 'Send cell & next', icon = '󰒭' },
  { '<leader>s:', ':SlimeSend1 ', desc = 'Send command...', icon = '󰞷' },
  { '<leader>sv', '<Plug>SlimeConfig', desc = 'Configure Slime', icon = '' },

  -- Navegación de celdas
  { ']c', desc = 'Next cell', icon = '󰒭' },
  { '[c', desc = 'Previous cell', icon = '󰒮' },

})
