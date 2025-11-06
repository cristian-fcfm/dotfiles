return {
  -- Mason para instalar LSPs
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "single",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 4,
    },
  },

  -- Configuración de Mason LSP + mason-tool-installer
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local servers = {
        basedpyright = {},
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
      require("mason-tool-installer").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
    end,
  },

  -- Configuración LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "j-hui/fidget.nvim", opts = {} },
      { "b0o/schemastore.nvim", lazy = true },
      { "ibhagwan/fzf-lua" },
    },
    config = function()
      local fzf = require("fzf-lua")

      -- Capabilities compartidas por todos los LSPs
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. (desc or "") })
        end

        -- Saltar a la definición de la palabra bajo el cursor.
        -- Aquí es donde una variable fue declarada por primera vez, o donde se define una función, etc.
        -- Para volver atrás, presiona <C-t>.
        map("gd", fzf.lsp_definitions, "[I]r a [D]efinición")

        -- Encontrar referencias para la palabra bajo el cursor.
        map("gr", fzf.lsp_references, "[I]r a [R]eferencias")

        -- Saltar a la implementación de la palabra bajo el cursor.
        -- Útil cuando tu lenguaje tiene formas de declarar tipos sin una implementación real.
        map("gI", fzf.lsp_implementations, "[I]r a [I]mplementación")

        -- Saltar al tipo de la palabra bajo el cursor.
        -- Útil cuando no estás seguro de qué tipo es una variable y quieres ver
        -- la definición de su *tipo*, no donde fue *definida*.
        map("gy", fzf.lsp_typedefs, "[D]efinición de Tipo")

        -- Búsqueda difusa de todos los símbolos en tu documento actual.
        -- Los símbolos son cosas como variables, funciones, tipos, etc.
        map("gs", fzf.lsp_document_symbols, "[S]ímbolos del [D]ocumento")

        -- Búsqueda difusa de todos los símbolos en tu espacio de trabajo actual.
        -- Similar a los símbolos del documento, excepto que busca en todo tu proyecto.
        map("gS", fzf.lsp_live_workspace_symbols, "[S]ímbolos del [E]spacio de trabajo")

        -- Renombrar la variable bajo el cursor.
        -- La mayoría de los Language Servers soportan renombrado entre archivos, etc.
        map("gn", vim.lsp.buf.rename, "[R]enombrar")

        -- Ejecutar una acción de código, usualmente tu cursor necesita estar encima de un error
        -- o una sugerencia de tu LSP para que esto se active.
        map("ga", vim.lsp.buf.code_action, "[A]cción de [C]ódigo", { "n", "x" })

        -- ADVERTENCIA: Esto no es Ir a Definición, esto es Ir a Declaración.
        -- Por ejemplo, en C esto te llevaría al header.
        map("gD", vim.lsp.buf.declaration, "[I]r a [D]eclaración")

        -- Formatear documento
        map("gf", function()
          vim.lsp.buf.format({ async = true })
        end, "Formatear")

        -- Hover mejorado con configuración personalizada
        map("K", function()
          vim.lsp.buf.hover({
            border = "single",
            max_height = 20,
            max_width = 130,
          })
        end, "Mostrar documentación")

        -- Signature help
        map("<C-k>", vim.lsp.buf.signature_help, "Mostrar firma de función")

        -- Navegación de diagnósticos mejorada
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("[e", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, "Previous error")
        map("]e", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, "Next error")

        -- Desactivar hover y formatting de ruff para evitar duplicados con pyright
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.documentFormattingProvider = false
        end

        -- Resaltado de referencias
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Alternar inlay hints
        if client.server_capabilities.inlayHintProvider then
          map("gh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, "[A]lternar Inlay [H]ints")
        end
      end

      -- Configuración de diagnóstico personalizada
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = "single",
          source = "if_many",
          header = "",
          prefix = "",
          focusable = false,
        },
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

      -- Handlers personalizados para ventanas flotantes
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
        max_width = 130,
        max_height = 20,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        focusable = false,
      })

      -- Configuración de cada LSP usando vim.lsp.config
      local python_capabilities = vim.tbl_deep_extend("force", capabilities, {
        textDocument = {
          publishDiagnostics = {
            tagSupport = { valueSet = { 2 } },
          },
        },
      })

      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json" },
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            disableTaggedHints = false,
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              diagnosticMode = "workspace",
              diagnosticSeverityOverrides = {
                deprecateTypingAliases = false,
              },
            },
          },
        },
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
        root_markers = { ".git", ".marksman.toml" },
      }

      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim", "require" },
              disable = { "missing-fields" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            format = { enable = false },
          },
        },
      }

      -- Habilitar los servidores con on_attach y capabilities
      vim.lsp.enable({ "basedpyright", "bashls", "jsonls", "yamlls", "dockerls", "marksman", "lua_ls" })

      -- Configurar on_attach para todos los servidores
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client then
            -- Aplicar capabilities personalizados para Python
            if client.name == "basedpyright" then
              client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities or {}, python_capabilities)
            else
              client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities or {}, capabilities)
            end

            on_attach(client, bufnr)
          end
        end,
      })

      -- Comandos para toggle de diagnósticos
      vim.api.nvim_create_user_command("DiagnosticsToggle", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end, { desc = "Toggle diagnostics on/off" })

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
    end,
  },
}
