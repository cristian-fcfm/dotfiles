local wk = require('which-key')

wk.add({
    { '<leader>w', group = 'Workspace (LSP)', icon = '' },
    {
        '<leader>wa',
        function()
            vim.lsp.buf.add_workspace_folder()
        end,
        desc = 'Agregar carpeta al workspace',
        icon = ''
    },
    {
        '<leader>wr',
        function()
            vim.lsp.buf.remove_workspace_folder()
        end,
        desc = 'Remover carpeta del workspace',
        icon = ''
    },
    {
        '<leader>wl',
        function()
            vim.print(vim.lsp.buf.list_workspace_folders())
        end,
        desc = 'Listar carpetas del workspace',
        icon = ''
    },
})
