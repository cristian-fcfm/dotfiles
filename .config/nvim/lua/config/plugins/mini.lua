return {
    {
        'echasnovski/mini.icons',
        version = false,
        lazy = true,
        config = function()
            -- Compatibilidad con plugins que solo soportan nvim-web-devicons
            require('mini.icons').mock_nvim_web_devicons()
            require('mini.icons').tweak_lsp_kind()
        end,
    },
    {
        'echasnovski/mini.pairs',
        version = false,
        event = 'InsertEnter',
        config = function()
            require('mini.pairs').setup()
        end,
    },
    {
        'echasnovski/mini.move',
        version = false,
        event = 'VeryLazy',
        config = function()
            require('mini.move').setup()
        end,
    },
    {
        'echasnovski/mini.indentscope',
        version = false,
        event = 'VeryLazy',
        config = function()
            require('mini.indentscope').setup({
                symbol = '󰇙',
            })
        end,
    },
}
