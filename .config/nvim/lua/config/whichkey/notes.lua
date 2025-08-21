local wk = require('which-key')

wk.add({
    { '<leader>n', group = 'Notes', icon = '' },

    -- Neorg workspace commands
    { '<leader>nw', group = 'Workspace', icon = '󰬱' },
    { '<leader>nws', ':Neorg workspace notes<CR>', desc = 'Switch to notes workspace', icon = '' },
    { '<leader>nwp', ':Neorg workspace projects<CR>', desc = 'Switch to projects workspace', icon = '' },
    { '<leader>nwa', ':Neorg workspace areas<CR>', desc = 'Switch to areas workspace', icon = '' },
    { '<leader>nwr', ':Neorg workspace resources<CR>', desc = 'Switch to resources workspace', icon = '' },

    -- Neorg hop-link commands
    { '<leader>nh', group = 'Hop Links', icon = '󱅷' },
    { '<leader>nhf', '<Plug>(neorg.esupports.hop.hop-link)', desc = 'Follow link under cursor', icon = '' },
    { '<leader>nhv', '<Plug>(neorg.esupports.hop.hop-link.vsplit)', desc = 'Follow link in vertical split', icon = '󰲔' },
    { '<leader>nht', '<Plug>(neorg.esupports.hop.hop-link.tab-drop)', desc = 'Follow link in new tab', icon = '󰴛' },
    { '<leader>nhd', '<Plug>(neorg.esupports.hop.hop-link.drop)', desc = 'Follow link in existing buffer', icon = '󱄁' },

    -- Neorg Journal
    { '<leader>nj', group = 'Journal', icon = '' },
    { '<leader>njt', ':Neorg journal today<CR>', desc = 'generar nota para hoy', icon = '' },
    { '<leader>njy', ':Neorg journal yesterday<CR>', desc = 'generar nota para ayer', icon = '' },
    { '<leader>njm', ':Neorg journal tomorrow<CR>', desc = 'generar nota para manana', icon = '' },
})
