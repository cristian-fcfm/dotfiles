return {
    'lewis6991/gitsigns.nvim',
    config = function()
        local gs = require("gitsigns")

        gs.setup {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "│" },
            },
            word_diff = false,
        }

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                vim.cmd([[
                    hi GitSignsChangeInline gui=reverse
                    hi GitSignsAddInline gui=reverse
                    hi GitSignsDeleteInline gui=reverse
                ]])
            end,
        })
    end,
}
