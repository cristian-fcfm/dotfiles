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
        pyrefly = {},
        bashls = {},
        jsonls = {},
        yamlls = {},
        marksman = {},
        dockerls = {},
        lua_ls = {},
        tinymist = {},
        rust_analyzer = {},
      }

      -- Linters
      local linters = {
        "ruff", -- Python
        "shellcheck", -- Bash
        "yamllint", -- YAML
        "markdownlint", -- Markdown
        "hadolint", -- Docker
        "selene", -- Lua
      }

      -- Formatters (adicionales a los configurados en conform)
      local formatters = {
        "stylua", -- Lua
        "shfmt", -- Bash
        "prettier", -- JSON, YAML, Markdown
      }

      -- Combinar todas las herramientas para mason-tool-installer
      local tools = vim.tbl_keys(servers)
      vim.list_extend(tools, linters)
      vim.list_extend(tools, formatters)

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = tools,
        auto_update = false,
        run_on_start = true,
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

      -- ========================================================================
      -- CAPABILITIES
      -- ========================================================================
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      -- ========================================================================
      -- ON_ATTACH - KEYMAPS Y CONFIGURACIÓN POR CLIENTE
      -- ========================================================================
      local on_attach = function(client, bufnr)
        -- Desactivar formateo LSP para todos los servidores (usa conform.nvim)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- Helper para mapear teclas
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end

        -- ===== Keymaps generales para todos los LSP =====
        -- Navegación
        map("gd", fzf.lsp_definitions, "Ir a definición")
        map("gr", fzf.lsp_references, "Ir a referencias")
        map("gI", fzf.lsp_implementations, "Ir a implementación")
        map("gy", fzf.lsp_typedefs, "Definición de tipo")
        map("gD", vim.lsp.buf.declaration, "Ir a declaración")

        -- Símbolos
        map("gs", fzf.lsp_document_symbols, "Símbolos del documento")
        map("gS", fzf.lsp_live_workspace_symbols, "Símbolos del workspace")

        -- Acciones
        map("gn", vim.lsp.buf.rename, "Renombrar")
        map("ga", vim.lsp.buf.code_action, "Code actions", { "n", "x" })
        map("gf", function()
          require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
            if err then
              vim.notify("Error al formatear: " .. tostring(err), vim.log.levels.ERROR)
            else
              vim.notify("✓ Formateado exitosamente", vim.log.levels.INFO)
            end
          end)
        end, "Formatear")

        -- Documentación
        map("K", function()
          vim.lsp.buf.hover({ border = "single", max_height = 20, max_width = 130 })
        end, "Mostrar documentación")
        map("<C-K>", vim.lsp.buf.signature_help, "Mostrar firma de función")

        -- Diagnósticos
        map("[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
        map("]d", vim.diagnostic.goto_next, "Diagnóstico siguiente")
        map("[e", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, "Error anterior")
        map("]e", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, "Error siguiente")

        -- ===== Resaltado de referencias =====
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

        -- ===== Inlay hints =====
        if client.server_capabilities.inlayHintProvider then
          map("gh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, "Alternar Inlay Hints")
        end
      end

      -- ========================================================================
      -- CONFIGURACIÓN DE DIAGNÓSTICOS
      -- ========================================================================
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

      -- Configurar highlight para código obsoleto/innecesario (strikethrough)
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { strikethrough = true, sp = "gray" })

      -- ========================================================================
      -- CONFIGURACIÓN GLOBAL DE CAPABILITIES
      -- ========================================================================
      -- Aplicar capabilities base a todos los servidores LSP
      vim.lsp.config["*"] = {
        capabilities = capabilities,
      }

      -- ========================================================================
      -- HANDLERS PERSONALIZADOS
      -- ========================================================================
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
        max_width = 130,
        max_height = 20,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        focusable = false,
      })

      -- ========================================================================
      -- CONFIGURACIÓN DE SERVIDORES LSP
      -- ========================================================================

      -- Python
      vim.lsp.config.pyrefly = {
        cmd = { "uvx", "pyrefly", "lsp" },
        filetypes = { "python" },
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
        },
        settings = {},
      }

      -- Bash
      vim.lsp.config.bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh", "bash" },
        root_markers = { ".git" },
      }

      -- JSON
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

      -- YAML
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

      -- Docker
      vim.lsp.config.dockerls = {
        cmd = { "docker-langserver", "--stdio" },
        filetypes = { "dockerfile" },
        root_markers = { ".git" },
      }

      -- Markdown
      vim.lsp.config.marksman = {
        cmd = { "marksman", "server" },
        filetypes = { "markdown", "markdown.mdx" },
        root_markers = { ".marksman.toml" },
      }

      -- Zk (Zettelkasten)
      vim.lsp.config.zk = {
        cmd = { "zk", "lsp" },
        filetypes = { "zk" },
        root_markers = { ".zk" },
        settings = {},
      }

      -- Lua (configuración específica en .luarc.json)
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
          Lua = {
            telemetry = { enable = false },
            format = { enable = false },
          },
        },
      }

      -- Typst
      vim.lsp.config.tinymist = {
        cmd = { "tinymist" },
        filetypes = { "typst" },
        root_markers = { ".git" },
        settings = {
          exportPdf = "never",
          formatterMode = "typstyle",
        },
      }

      -- Rust
      vim.lsp.config.rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", "rust-project.json" },
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            procMacro = {
              enable = true,
            },
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
          },
        },
      }

      -- ========================================================================
      -- HABILITAR SERVIDORES
      -- ========================================================================
      vim.lsp.enable({
        "pyrefly",
        "bashls",
        "jsonls",
        "yamlls",
        "dockerls",
        "marksman",
        "zk",
        "lua_ls",
        "tinymist",
        "rust_analyzer",
      })

      -- ========================================================================
      -- AUTOCOMMAND LSPATTACH
      -- ========================================================================
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf
          if client then
            on_attach(client, bufnr)
          end
        end,
      })

      -- ========================================================================
      -- COMANDOS DE USUARIO
      -- ========================================================================
      vim.api.nvim_create_user_command("DiagnosticsToggle", function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      end, { desc = "Alternar diagnósticos" })

      vim.api.nvim_create_user_command("DiagnosticsDisable", function()
        vim.diagnostic.enable(false)
      end, { desc = "Deshabilitar diagnósticos" })

      vim.api.nvim_create_user_command("DiagnosticsEnable", function()
        vim.diagnostic.enable(true)
      end, { desc = "Habilitar diagnósticos" })

      vim.api.nvim_create_user_command("DiagnosticsDisableBuffer", function()
        vim.diagnostic.enable(false, { bufnr = 0 })
      end, { desc = "Deshabilitar diagnósticos para el buffer actual" })

      vim.api.nvim_create_user_command("DiagnosticsEnableBuffer", function()
        vim.diagnostic.enable(true, { bufnr = 0 })
      end, { desc = "Habilitar diagnósticos para el buffer actual" })
    end,
  },
}
