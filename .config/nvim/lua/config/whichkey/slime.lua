local wk = require('which-key')

wk.add({
  { '<leader>s', group = 'Slime REPL', icon = '󰞷' },
  -- Envío de código
  { '<leader>sc', '<Plug>SlimeSendCell', desc = 'Send cell', icon = '󱐪' },
  { '<leader>ss', '<Plug>SlimeParagraphSend', desc = 'Send paragraph', icon = '󰈔', mode = 'n' },
  { '<leader>ss', '<Plug>SlimeRegionSend', desc = 'Send selection', icon = '󰈔', mode = 'x' },
  { '<leader>sl', '<Plug>SlimeLineSend', desc = 'Send line', icon = '󰘤' },
  { '<leader>sf', 'ggVG<Plug>SlimeRegionSend', desc = 'Send entire file', icon = '󰈙' },

  -- Comandos IPython básicos
  { '<leader>sr', ':SlimeSend1 %reset -f<CR>', desc = 'Reset IPython', icon = '󰑓' },
  { '<leader>si', ':SlimeSend1 whos<CR>', desc = 'Show variables', icon = '󰋽' },
  { '<leader>sm', ':SlimeSend1 %matplotlib inline<CR>', desc = 'Enable matplotlib', icon = '󰃃' },
  { '<leader>sp', ':SlimeSend1 %pwd<CR>', desc = 'Show current dir', icon = '󰉋' },

  -- Navegación y control
  {
    '<leader>sn',
    function()
      vim.cmd('SlimeSendCell')
      vim.cmd('normal! /# %%<CR>:nohlsearch<CR>')
    end,
    desc = 'Send cell & next',
    icon = '󰒭'
  },
  { '<leader>s:', ':SlimeSend1 ', desc = 'Send command...', icon = '󰞷' },
  { '<leader>sv', '<Plug>SlimeConfig', desc = 'Configure target', icon = '' },

})
