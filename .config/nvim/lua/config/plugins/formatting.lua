return {
  {
    "nvimtools/none-ls.nvim", 
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("none-ls")
      
      null_ls.setup({
        sources = {
          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.diagnostics.flake8,
          
          -- JSON/YAML
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "json", "yaml", "markdown" },
          }),
          null_ls.builtins.diagnostics.yamllint,
          
          -- Bash
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.shfmt,
          
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
