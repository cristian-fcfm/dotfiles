local wk = require('which-key')

wk.add({
    { '<leader>W', group = 'LSP Workspace', icon = '' },
    {
        '<leader>Wa',
        function()
            vim.lsp.buf.add_workspace_folder()
        end,
        desc = 'Add workspace folder',
        icon = ''
    },
    {
        '<leader>Wr',
        function()
            vim.lsp.buf.remove_workspace_folder()
        end,
        desc = 'Remove workspace folder',
        icon = ''
    },
    {
        '<leader>Wl',
        function()
            vim.print(vim.lsp.buf.list_workspace_folders())
        end,
        desc = 'List workspace folders',
        icon = ''
    },
})
