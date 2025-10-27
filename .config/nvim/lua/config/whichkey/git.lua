local wk = require('which-key')
local gs = require('gitsigns')

wk.add({
    { '<leader>h', group = 'Git Hunks', icon = '' },
    { '<leader>hp', gs.preview_hunk, desc = '[P]review hunk', icon = '󰙤' },
    { '<leader>hb', function() gs.blame_line { full = true } end, desc = '[B]lame hunk', icon = '' },
    {
        ']c',
        function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end,
        desc = 'Next hunk',
        expr = true,
        icon = '󰙢'
    },
    {
        '[c',
        function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end,
        desc = 'Previous hunk',
        expr = true,
        icon = '󰙤'
    },
})
