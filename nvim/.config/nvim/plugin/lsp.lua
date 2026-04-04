vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/b0o/schemastore.nvim", name = "schemastore.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig", version = vim.version.range("*") },
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink then
    capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
  end

  local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
    map("gr", function() Snacks.picker.lsp_references({ includeDeclaration = false }) end, "Go to references")
    map("gI", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
    map("gy", function() Snacks.picker.lsp_type_definitions() end, "Type definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")

    map("gs", function() Snacks.picker.lsp_symbols() end, "Document symbols")
    map("gS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")

    map("gn", vim.lsp.buf.rename, "Rename")
    map("ga", vim.lsp.buf.code_action, "Code actions", { "n", "x" })
    map("gf", function()
      require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
        if err then
          vim.notify("Format error: " .. tostring(err), vim.log.levels.ERROR)
        else
          vim.notify("Formatted successfully", vim.log.levels.INFO)
        end
      end)
    end, "Format")

    map("K", function()
      vim.lsp.buf.hover({ border = "single", max_height = 20, max_width = 130 })
    end, "Show hover documentation")
    map("gk", vim.lsp.buf.signature_help, "Show signature help")

    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Previous error")
    map("]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next error")

    if client.server_capabilities.inlayHintProvider then
      map("gh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, "Toggle Inlay Hints")
    end
  end

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "single", source = "if_many", header = "", prefix = "", focusable = false },
    underline = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    virtual_text = false,
    update_in_insert = false,
  })

  vim.lsp.config["*"] = {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single", max_width = 130, max_height = 20,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single", focusable = false,
  })

  vim.lsp.config.ty = {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
    settings = { ty = {} },
  }

  vim.lsp.config.bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    root_markers = { ".git" },
  }

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
        validate = true, completion = true, hover = true,
        format = { enable = true },
      },
    },
  }

  vim.lsp.config.dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { ".git" },
  }

  vim.lsp.config.marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml" },
  }

  vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    settings = {
      Lua = { telemetry = { enable = false }, format = { enable = false } },
    },
  }

  vim.lsp.config.tinymist = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { ".git" },
    settings = { exportPdf = "never", formatterMode = "typstyle" },
  }

  vim.lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json" },
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = false, loadOutDirsFromCheck = false, buildScripts = { enable = false } },
        checkOnSave = { enable = false },
        procMacro = { enable = false },
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

  vim.lsp.enable({
    "ty", "bashls", "jsonls", "yamlls", "dockerls", "marksman",
    "lua_ls", "tinymist", "rust_analyzer", "html", "cssls",
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then on_attach(client, args.buf) end
    end,
  })

  local wk = require("which-key")
  wk.add({
    { "<leader>W", group = "LSP Workspace", icon = "󰉌" },
    { "<leader>Wa", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace folder", icon = "󱂵" },
    { "<leader>Wr", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace folder", icon = "󰉘" },
    { "<leader>Wl", function() vim.print(vim.lsp.buf.list_workspace_folders()) end, desc = "List workspace folders", icon = "" },
  })

  vim.api.nvim_create_user_command("DiagnosticsToggle", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Toggle diagnostics" })

  vim.api.nvim_create_user_command("DiagnosticsDisable", function()
    vim.diagnostic.enable(false)
  end, { desc = "Disable diagnostics" })

  vim.api.nvim_create_user_command("DiagnosticsEnable", function()
    vim.diagnostic.enable(true)
  end, { desc = "Enable diagnostics" })

  vim.api.nvim_create_user_command("DiagnosticsDisableBuffer", function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end, { desc = "Disable diagnostics for current buffer" })

  vim.api.nvim_create_user_command("DiagnosticsEnableBuffer", function()
    vim.diagnostic.enable(true, { bufnr = 0 })
  end, { desc = "Enable diagnostics for current buffer" })
end)
