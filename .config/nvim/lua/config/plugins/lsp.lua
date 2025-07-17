return {
  -- Mason para instalar LSPs
  {
    'williamboman/mason.nvim',
    opts = {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗'
        }
      }
    }
  },

  -- Configuración de Mason LSP + mason-tool-installer
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
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
      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
      }
    end,
  },

  -- Configuración LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason-lspconfig.nvim' },
      { 'j-hui/fidget.nvim', opts = {} },
      { 'b0o/schemastore.nvim', lazy = true },
      { 'ibhagwan/fzf-lua' },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local fzf = require('fzf-lua')

      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. (desc or '') })
        end

        -- Saltar a la definición de la palabra bajo el cursor.
        -- Aquí es donde una variable fue declarada por primera vez, o donde se define una función, etc.
        -- Para volver atrás, presiona <C-t>.
        map('gd', fzf.lsp_definitions, '[I]r a [D]efinición')

        -- Encontrar referencias para la palabra bajo el cursor.
        map('gr', fzf.lsp_references, '[I]r a [R]eferencias')

        -- Saltar a la implementación de la palabra bajo el cursor.
        -- Útil cuando tu lenguaje tiene formas de declarar tipos sin una implementación real.
        map('gI', fzf.lsp_implementations, '[I]r a [I]mplementación')

        -- Saltar al tipo de la palabra bajo el cursor.
        -- Útil cuando no estás seguro de qué tipo es una variable y quieres ver
        -- la definición de su *tipo*, no donde fue *definida*.
        map('<leader>D', fzf.lsp_typedefs, '[D]efinición de Tipo')

        -- Búsqueda difusa de todos los símbolos en tu documento actual.
        -- Los símbolos son cosas como variables, funciones, tipos, etc.
        map('<leader>ds', fzf.lsp_document_symbols, '[S]ímbolos del [D]ocumento')

        -- Búsqueda difusa de todos los símbolos en tu espacio de trabajo actual.
        -- Similar a los símbolos del documento, excepto que busca en todo tu proyecto.
        map('<leader>ws', fzf.lsp_live_workspace_symbols, '[S]ímbolos del [E]spacio de trabajo')

        -- Renombrar la variable bajo el cursor.
        -- La mayoría de los Language Servers soportan renombrado entre archivos, etc.
        map('<leader>cr', vim.lsp.buf.rename, '[R]enombrar')

        -- Ejecutar una acción de código, usualmente tu cursor necesita estar encima de un error
        -- o una sugerencia de tu LSP para que esto se active.
        map('<leader>ca', vim.lsp.buf.code_action, '[A]cción de [C]ódigo', { 'n', 'x' })

        -- ADVERTENCIA: Esto no es Ir a Definición, esto es Ir a Declaración.
        -- Por ejemplo, en C esto te llevaría al header.
        map('gD', vim.lsp.buf.declaration, '[I]r a [D]eclaración')

        -- Formatear documento
        map('cf', function() vim.lsp.buf.format({ async = true }) end, 'Formatear')

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

        -- Alternar inlay hints
        if client.server_capabilities.inlayHintProvider then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
          end, '[A]lternar Inlay [H]ints')
        end
      end

      -- Configuración de diagnóstico personalizada
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
              typeCheckingMode = 'basic',
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
            workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          },
        },
      })
    end,
  },
}
