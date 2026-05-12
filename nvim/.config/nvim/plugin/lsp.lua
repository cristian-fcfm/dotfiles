-- =============================================================================
-- Configuracion LSP
-- =============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/b0o/schemastore.nvim", name = "schemastore.nvim" },
  })

  -- ===========================================================================
  -- Atajos al adjuntar un servidor
  -- ===========================================================================
  local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("gd", function()
      Snacks.picker.lsp_definitions()
    end, "Ir a definicion")
    map("gr", function()
      Snacks.picker.lsp_references()
    end, "Ir a referencias")
    map("gI", function()
      Snacks.picker.lsp_implementations()
    end, "Ir a implementacion")
    map("gy", function()
      Snacks.picker.lsp_type_definitions()
    end, "Definicion de tipo")
    map("gD", vim.lsp.buf.declaration, "Ir a declaracion")

    map("gs", function()
      Snacks.picker.lsp_symbols()
    end, "Simbolos del documento")
    map("gS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "Simbolos del workspace")

    map("gn", vim.lsp.buf.rename, "Renombrar")
    map("ga", vim.lsp.buf.code_action, "Acciones de codigo", { "n", "x" })

    map("K", vim.lsp.buf.hover, "Documentacion flotante")
    map("gk", vim.lsp.buf.signature_help, "Ayuda de firma")

    map("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Diagnostico anterior")
    map("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Diagnostico siguiente")
    map("[e", function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
    end, "Error anterior")
    map("]e", function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
    end, "Error siguiente")

    if client.server_capabilities.inlayHintProvider then
      map("gh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, "Alternar inlay hints")
    end
  end

  -- ===========================================================================
  -- Diagnosticos
  -- ===========================================================================
  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "single", source = "if_many", header = "", prefix = "", focusable = false },
    underline = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    virtual_text = false,
    update_in_insert = false,
  })

  -- ===========================================================================
  -- Servidores LSP
  -- ===========================================================================
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
        validate = true,
        completion = true,
        hover = true,
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
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
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

  vim.lsp.config.zls = {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    root_markers = { "build.zig", "build.zig.zon", ".git" },
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

  -- ===========================================================================
  -- Activar servidores
  -- ===========================================================================
  vim.lsp.enable({
    "ty",
    "bashls",
    "jsonls",
    "yamlls",
    "dockerls",
    "marksman",
    "lua_ls",
    "tinymist",
    "zls",
    "html",
    "cssls",
  })

  -- ===========================================================================
  -- Autocmd y comandos de usuario
  -- ===========================================================================
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, args.buf)
        MiniClue.ensure_buf_triggers(args.buf)
      end
    end,
  })

  vim.api.nvim_create_user_command("DiagnosticsToggle", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  end, { desc = "Alternar diagnosticos globales" })

  vim.api.nvim_create_user_command("DiagnosticsToggleBuffer", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
  end, { desc = "Alternar diagnosticos del buffer" })

  vim.keymap.set("n", "<leader>ld", "<cmd>DiagnosticsToggleBuffer<CR>", { desc = "Alternar diagnosticos (buffer)" })
  vim.keymap.set("n", "<leader>lD", "<cmd>DiagnosticsToggle<CR>", { desc = "Alternar diagnosticos (global)" })
end)
