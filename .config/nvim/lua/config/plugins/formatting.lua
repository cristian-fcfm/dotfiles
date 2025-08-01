return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Python - usando ruff para formatting e import sorting
        python = { 'ruff_format', 'ruff_organize_imports' },

        -- SQL - optimizado para Athena/Presto
        sql = { 'sqlfluff' },

        -- Jinja2 templates (solo archivos .jinja, .jinja2)
        jinja = { 'sqlfluff' },
        jinja2 = { 'sqlfluff' },

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
        sqlfluff = {
          command = 'sqlfluff',
          args = {
            'format',
            '--dialect=trino', -- Usar trino para Athena/Presto
            '--stdin-filename', '$FILENAME',
            '-'
          },
          stdin = true,
          timeout_ms = 8000, -- SQLFluff necesita tiempo para procesar
          condition = function(self, ctx)
            -- Solo procesar archivos no muy grandes
            local max_size = 100 * 1024 -- 100KB
            local stat = vim.loop.fs_stat(ctx.filename)
            return stat and stat.size < max_size
          end,
        },
      },
    },
  },
}
