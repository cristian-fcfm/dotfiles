return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Python
        python = { 'isort', 'black' },

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
          prepend_args = { '-i', '2' }, },
      },
    },
  },
}
