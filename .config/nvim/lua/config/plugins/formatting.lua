return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Python - usando ruff para formatting e import sorting
        python = { 'ruff_format', 'ruff_organize_imports' },

        -- SQL - optimizado para Athena/Presto
        sql = { 'sql_formatter' },

        -- Jinja2 templates (solo archivos .jinja, .jinja2)
        jinja = { 'djlint' },
        jinja2 = { 'djlint' },

        -- JSON/YAML/Markdown
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },

        -- Bash
        bash = { 'shfmt' },
        sh = { 'shfmt' },
      },
      format_on_save = {
        timeout_ms = 500,
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
        sql_formatter = {
          command = 'sql-formatter',
          args = {
            '--language', 'trino',
            '--uppercase', 'true',
            '--lines-between-queries', '2'
          },
          stdin = true,
        },
        djlint = {
          command = 'djlint',
          args = { '--reformat', '-' },
          stdin = true,
        },
      },
    },
  },
}
