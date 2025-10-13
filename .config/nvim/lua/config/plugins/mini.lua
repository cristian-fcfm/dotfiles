return {
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
