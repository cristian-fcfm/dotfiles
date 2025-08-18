local wk = require('which-key')
local fzf = require('fzf-lua')

wk.add({
    { '<leader>f', group = 'FZF', icon = '' },
    { '<leader>ff', function() fzf.files() end, desc = '[F]ind files in directory', icon = '' },
    { '<leader>fg', function() fzf.live_grep() end, desc = '[F]ind grepping in project', icon = '' },
    { '<leader>fc', function() fzf.files({ cwd = vim.fn.stdpath('config') }) end, desc = '[F]ind in configurations', icon = '' },
    { '<leader>fh', function() fzf.helptags() end, desc = '[F]ind [H]elp', icon = '󰋖' },
    { '<leader>fk', function() fzf.keymaps() end, desc = '[F]ind [K]eymaps', icon = '' },
    { '<leader>fb', function() fzf.builtin() end, desc = '[F]ind [B]uiltin FZF', icon = '' },
    { '<leader>fw', function() fzf.grep_cword() end, desc = '[F]ind current [W]ord', icon = '' },
    { '<leader>fW', function() fzf.grep_cWORD() end, desc = '[F]ind current [W]ORD', icon = '' },
    { '<leader>fd', function() fzf.diagnostics_document() end, desc = '[F]ind [D]iagnostics', icon = '' },
    { '<leader>fr', function() fzf.resume() end, desc = '[F]ind [R]esume', icon = '' },
    { '<leader>fo', function() fzf.oldfiles() end, desc = '[F]ind [O]ld Files', icon = '' },
    { '<leader>f<leader>', function() fzf.buffers() end, desc = '[ ] Find existing buffers', icon = '' },
    { '<leader>f/', function() fzf.lgrep_curbuf() end, desc = '[/] Live grep the current buffer', icon = '' },
})
