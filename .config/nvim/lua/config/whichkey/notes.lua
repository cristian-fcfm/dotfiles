local wk = require('which-key')

wk.add({
    { '<leader>n', group = 'Notes', icon = '' },

    -- Neorg workspace
    { '<leader>nw', group = 'Workspace', icon = '󰬱' },
    { '<leader>nws', ':Neorg workspace notes<CR>', desc = 'Switch to notes workspace', icon = '' },
    { '<leader>nwp', ':Neorg workspace projects<CR>', desc = 'Switch to projects workspace', icon = '' },
    { '<leader>nwa', ':Neorg workspace areas<CR>', desc = 'Switch to areas workspace', icon = '' },
    { '<leader>nwr', ':Neorg workspace resources<CR>', desc = 'Switch to resources workspace', icon = '' },

    -- Neorg hop-link
    { '<leader>nh', group = 'Links', icon = '󱅷' },
    { '<leader>nhf', '<Plug>(neorg.esupports.hop.hop-link)', desc = 'Follow link under cursor', icon = '' },
    { '<leader>nhv', '<Plug>(neorg.esupports.hop.hop-link.vsplit)', desc = 'Follow link in vertical split', icon = '󰲔' },
    { '<leader>nht', '<Plug>(neorg.esupports.hop.hop-link.tab-drop)', desc = 'Follow link in new tab', icon = '󰴛' },
    { '<leader>nhd', '<Plug>(neorg.esupports.hop.hop-link.drop)', desc = 'Follow link in existing buffer', icon = '󱄁' },

    -- Neorg Journal
    { '<leader>nj', group = 'Journal', icon = '' },
    { '<leader>njt', ':Neorg journal today<CR>', desc = 'generar nota para hoy', icon = '' },
    { '<leader>njy', ':Neorg journal yesterday<CR>', desc = 'generar nota para ayer', icon = '' },
    { '<leader>njm', ':Neorg journal tomorrow<CR>', desc = 'generar nota para manana', icon = '' },

    -- Neorg pivot
    { '<leader>np', group = 'Pivot', icon = '' },
    { '<leader>npt', '<Plug>(neorg.pivot.list.toggle)', desc = 'List toggle', icon = '' },
    { '<leader>npi', '<Plug>(neorg.pivot.list.invert)', desc = 'List invert', icon = '' },

    -- Neorg promo
    { '<leader>nr', group = 'Promote/Demote', icon = '' },
    { '<leader>nrp', '<Plug>(neorg.promo.promote)', desc = 'Promote item on current line', icon = '' },
    { '<leader>nrP', '<Plug>(neorg.promo.promote.nested)', desc = 'Promote current line and nested items', icon = '' },
    { '<leader>nrr', '<Plug>(neorg.promo.promote.range)', desc = 'Promote all items in range', icon = '' },
    { '<leader>nrd', '<Plug>(neorg.promo.demote)', desc = 'Demote item on current line', icon = '' },
    { '<leader>nrD', '<Plug>(neorg.promo.demote.nested)', desc = 'Demote current line and nested items', icon = '' },
    { '<leader>nrR', '<Plug>(neorg.promo.demote.range)', desc = 'Demote all items in range', icon = '' },

    -- Neorg TOC
    { '<leader>nt', group = 'Table of Contents', icon = '' },
    { '<leader>ntl', ':Neorg toc left<CR>', desc = 'Open TOC on left side', icon = '' },
    { '<leader>ntr', ':Neorg toc right<CR>', desc = 'Open TOC on right side', icon = '' },
    { '<leader>ntq', ':Neorg toc qflist<CR>', desc = 'Send TOC to quickfix list', icon = '' },
    { '<leader>ntt', ':Neorg toc<CR>', desc = 'Open TOC', icon = '' },

    -- Neorg TODO items
    { '<leader>nd', group = 'TODO Items', icon = '☑' },
    { '<leader>ndd', '<Plug>(neorg.qol.todo-items.todo.task-done)', desc = 'Mark task as done', icon = '✓' },
    { '<leader>ndu', '<Plug>(neorg.qol.todo-items.todo.task-undone)', desc = 'Mark task as undone', icon = '☐' },
    { '<leader>ndp', '<Plug>(neorg.qol.todo-items.todo.task-pending)', desc = 'Mark task as pending', icon = '⧖' },
    { '<leader>ndh', '<Plug>(neorg.qol.todo-items.todo.task-on_hold)', desc = 'Mark task as on hold', icon = '⏸' },
    { '<leader>ndc', '<Plug>(neorg.qol.todo-items.todo.task-cancelled)', desc = 'Mark task as cancelled', icon = '✗' },
    { '<leader>ndr', '<Plug>(neorg.qol.todo-items.todo.task-recurring)', desc = 'Mark task as recurring', icon = '⟲' },
    { '<leader>ndi', '<Plug>(neorg.qol.todo-items.todo.task-important)', desc = 'Mark task as important', icon = '!' },
    { '<leader>nds', '<Plug>(neorg.qol.todo-items.todo.task-cycle)', desc = 'Cycle task state', icon = '🔄' },
    { '<leader>ndS', '<Plug>(neorg.qol.todo-items.todo.task-cycle-reverse)', desc = 'Cycle task state reverse', icon = '🔄' },



})
