-- Plugin para resaltado de sintaxis avanzado y otras mejoras de edición
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Actualiza los parsers automáticamente
    config = function()
        require('nvim-treesitter.configs').setup({
            -- Parsers específicos para tus necesidades
            ensure_installed = {
                'python', 'lua', 'sql', 'json', 'yaml', 'markdown',
                'bash', 'vim', 'vimdoc'
            },

            highlight = {
                enable = true,
                -- Deshabilitar treesitter para archivos grandes
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },

            indent = {
                enable = true,
                disable = { 'sql' }
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<Enter>',
                    node_incremental = '<Enter>',
                    scope_incremental = false,
                    node_decremental = '<Backspace>',
                },
            },
        })
    end,
}
