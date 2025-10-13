local wk = require('which-key')

wk.add({
    { '<leader>c', group = 'Comments', icon = '󰆉' },
    { '<leader>cc', 'gcc', desc = 'Toggle comment line', remap = true, icon = '󰆉' },
    { '<leader>cb', 'gbc', desc = 'Toggle block comment', remap = true, icon = '󰆉' },
    { '<leader>cc', 'gc', desc = 'Toggle comment', mode = 'v', remap = true, icon = '󰆉' },
    { '<leader>cb', 'gb', desc = 'Toggle block comment', mode = 'v', remap = true, icon = '󰆉' },
})
