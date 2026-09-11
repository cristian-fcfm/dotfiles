-- ============================================================================
-- LSP: configuracion central (on_attach, diagnosticos, enable)
-- ============================================================================
vim.schedule(function()
  -- NOTA: no desactivar documentFormattingProvider aquí: conform con
  -- lsp_format="fallback" (y typst con { "lsp_format" }) filtra los clientes
  -- por esa capability, y anularla dejaba el formateo LSP sin efecto.
  local on_attach = function(_, bufnr)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("gd", function() Snacks.picker.lsp_definitions() end, "Ir a definicion")
    map("grr", function() Snacks.picker.lsp_references() end, "Ir a referencias")
    map("gri", function() Snacks.picker.lsp_implementations() end, "Ir a implementacion")
    map("grt", function() Snacks.picker.lsp_type_definitions() end, "Definicion de tipo")
    map("gD", vim.lsp.buf.declaration, "Ir a declaracion")
    map("gO", function() Snacks.picker.lsp_symbols() end, "Simbolos del documento")
    map("gS", function() Snacks.picker.lsp_workspace_symbols() end, "Simbolos del workspace")
    map("grn", vim.lsp.buf.rename, "Renombrar")
    map("gra", vim.lsp.buf.code_action, "Acciones de codigo", { "n", "x" })
    map("K", vim.lsp.buf.hover, "Documentacion flotante")
    map("gK", vim.lsp.buf.signature_help, "Ayuda de firma")
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
      end
    end,
  })
end)
