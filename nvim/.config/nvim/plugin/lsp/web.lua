-- =============================================================================
-- LSP: Web (jsonls, yamlls, html, cssls)
-- =============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/b0o/schemastore.nvim", name = "schemastore.nvim" },
  })

  vim.lsp.config.jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  }

  vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    root_markers = { ".git" },
    settings = {
      yaml = {
        schemas = require("schemastore").yaml.schemas(),
        validate = true,
        completion = true,
        hover = true,
        format = { enable = true },
      },
    },
  }

  vim.lsp.config.html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "htmldjango" },
    root_markers = { ".git" },
    settings = { html = { format = { enable = false } } },
  }

  vim.lsp.config.cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { ".git" },
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  }
end)
