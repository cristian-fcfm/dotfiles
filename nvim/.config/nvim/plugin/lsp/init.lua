-- ============================================================================
-- LSP: configuracion central (on_attach, diagnosticos, enable)
-- ============================================================================
vim.schedule(function()
  local on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("gd", function() Snacks.picker.lsp_definitions() end, "Ir a definicion")
    map("gr", function() Snacks.picker.lsp_references() end, "Ir a referencias")
    map("gI", function() Snacks.picker.lsp_implementations() end, "Ir a implementacion")
    map("gy", function() Snacks.picker.lsp_type_definitions() end, "Definicion de tipo")
    map("gD", vim.lsp.buf.declaration, "Ir a declaracion")
    map("gs", function() Snacks.picker.lsp_symbols() end, "Simbolos del documento")
    map("gS", function() Snacks.picker.lsp_workspace_symbols() end, "Simbolos del workspace")
    map("gn", vim.lsp.buf.rename, "Renombrar")
    map("ga", vim.lsp.buf.code_action, "Acciones de codigo", { "n", "x" })
    map("K", vim.lsp.buf.hover, "Documentacion flotante")
    map("gk", vim.lsp.buf.signature_help, "Ayuda de firma")

    if client.server_capabilities.inlayHintProvider then
      map("gh", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
          { bufnr = bufnr }
        )
      end, "Alternar inlay hints")
    end
  end

  vim.diagnostic.config({
    severity_sort = true,
    float = { border = "single", source = "if_many", header = "", prefix = "", focusable = false },
    underline = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.INFO] = "I",
        [vim.diagnostic.severity.HINT] = "H",
      },
    },
    virtual_text = false,
    update_in_insert = false,
  })

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
    "rust_analyzer",
  })

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
