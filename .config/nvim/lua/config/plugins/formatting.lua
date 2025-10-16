return {
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                -- Python - usando ruff para formatting e import sorting
                python = { 'ruff_format', 'ruff_organize_imports' },

                -- JSON/YAML/Markdown
                json = { 'prettier' },
                yaml = { 'prettier' },
                markdown = { 'prettier' },

                -- Bash
                bash = { 'shfmt' },
                sh = { 'shfmt' },
            },
            format_on_save = {
                timeout_ms = 2000,
                lsp_format = 'fallback',
            },
            formatters = {
                shfmt = {
                    prepend_args = { '-i', '2' },
                },
                ruff_format = {
                    command = 'ruff',
                    args = { 'format', '--stdin-filename', '$FILENAME', '-' },
                    stdin = true,
                },
                ruff_organize_imports = {
                    command = 'ruff',
                    args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME', '-' },
                    stdin = true,
                },
            },
        },
    },
}
