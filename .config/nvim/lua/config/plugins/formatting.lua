return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local none_ls = require("null-ls")

      none_ls.setup({
        sources = {
          -- Python
          none_ls.builtins.formatting.black,
          none_ls.builtins.formatting.isort,
          none_ls.builtins.diagnostics.flake8,

          -- JSON/YAML
          none_ls.builtins.formatting.prettier.with({
            filetypes = { "json", "yaml", "markdown" },
          }),
          none_ls.builtins.diagnostics.yamllint,

          -- Bash
          none_ls.builtins.diagnostics.shellcheck,
          none_ls.builtins.formatting.shfmt,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end, { buffer = bufnr, desc = "[lsp] format" })
          end
        end,
      })
    end,
  },
}
