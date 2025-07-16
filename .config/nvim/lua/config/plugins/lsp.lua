return {
  -- Mason para instalar LSPs
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    }
  },

  -- Mason LSP config + mason-tool-installer
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local servers = {
        pyright = {},
        bashls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        dockerls = {},
        lua_ls = {},
      }
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })
      require("mason-tool-installer").setup {
        ensure_installed = vim.tbl_keys(servers),
      }
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "j-hui/fidget.nvim", opts = {} },
      { "b0o/schemastore.nvim", lazy = true },
      { "ibhagwan/fzf-lua" }, 
    },
    config = function()
      local lspconfig = require("lspconfig")
      local fzf = require("fzf-lua")

      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. (desc or "") })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', fzf.lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', fzf.lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', fzf.lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', fzf.lsp_typedefs, 'Type [D]efinition')
        map('<leader>ds', fzf.lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', fzf.lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('K', vim.lsp.buf.hover, 'Hover')
        map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')

        -- Resaltado de referencias
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Inlay hints toggle
        if client.server_capabilities.inlayHintProvider then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
          end, '[T]oggle Inlay [H]ints')
        end
      end

      -- Diagnóstico personalizado
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      -- Configuración de cada LSP
      lspconfig.pyright.setup({
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      })
      lspconfig.bashls.setup({ on_attach = on_attach })
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
            validate = true,
            completion = true,
          },
        },
      })
      lspconfig.dockerls.setup({ on_attach = on_attach })
      lspconfig.marksman.setup({ on_attach = on_attach })
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      })
    end,
  },
}
