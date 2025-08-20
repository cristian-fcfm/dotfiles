local wk = require('which-key')

wk.add({
    { '<leader>n', group = 'Notes', icon = '' },

    -- Neorg workspace commands
    { '<leader>nw', group = 'Workspace', icon = '󰬱' },
    { '<leader>nws', ':Neorg workspace notes<CR>', desc = 'Switch to notes workspace', icon = '' },

    -- Neorg hop-link commands
    { '<leader>nh', group = 'Hop Links', icon = '󱅷' },
    { '<leader>nhf', '<Plug>(neorg.esupports.hop.hop-link)', desc = 'Follow link under cursor', icon = '' },
    { '<leader>nhv', '<Plug>(neorg.esupports.hop.hop-link.vsplit)', desc = 'Follow link in vertical split', icon = '󰲔' },
    { '<leader>nht', '<Plug>(neorg.esupports.hop.hop-link.tab-drop)', desc = 'Follow link in new tab', icon = '󰴛' },
    { '<leader>nhd', '<Plug>(neorg.esupports.hop.hop-link.drop)', desc = 'Follow link in existing buffer', icon = '󱄁' },
})
