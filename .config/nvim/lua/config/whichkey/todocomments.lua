local wk = require('which-key')

wk.add({
    { '<leader>a', group = 'TODO', icon = '' },

    -- Búsqueda de TODOs
    { '<leader>aa', '<cmd>TodoFzfLua<cr>', desc = 'Search TODOs', icon = '' },
    { '<leader>al', '<cmd>TodoLocList<cr>', desc = 'TODOs in location list', icon = '' },
    { '<leader>aq', '<cmd>TodoQuickFix<cr>', desc = 'TODOs in quickfix', icon = '' },

    -- Insertar TODOs rápidamente
    { '<leader>ai', group = 'Insert TODO', icon = '' },
    { '<leader>ait', '<cmd>InsertTodo<cr>', desc = 'Insert TODO', icon = '󰄱' },
    { '<leader>aif', '<cmd>InsertFixme<cr>', desc = 'Insert FIXME', icon = '󰁨' },
    { '<leader>ain', '<cmd>InsertNote<cr>', desc = 'Insert NOTE', icon = '' },
    { '<leader>aih', '<cmd>InsertHack<cr>', desc = 'Insert HACK', icon = '' },

    -- Navegación
    { '<leader>aj', function() require('todo-comments').jump_next() end, desc = 'Next TODO', icon = '󰙢' },
    { '<leader>ak', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO', icon = '󰙤' },

    -- Navegación rápida con atajos cortos
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next TODO' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous TODO' },
    { ']b', function() require('todo-comments').jump_next({ keywords = { "FIX", "FIXME", "BUG" } }) end, desc = 'Next FIXME' },
    { '[b', function() require('todo-comments').jump_prev({ keywords = { "FIX", "FIXME", "BUG" } }) end, desc = 'Previous FIXME' },
})
