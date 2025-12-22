return {
  "nvim-neorg/neorg",
  lazy = true,
  version = "*",
  ft = "norg",
  cmd = "Neorg",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    load = {
      -- ========================================================================
      -- Core modules
      -- ========================================================================
      ["core.defaults"] = {},
      -- Deshabilitar integración de treesitter (incompatible con nvim-treesitter main)
      ["core.integrations.treesitter"] = { enabled = false },
      ["core.concealer"] = {
        config = {
          icon_preset = "diamond", -- Iconos: basic, diamond, varied
          icons = {
            heading = {
              icons = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫" },
            },
            todo = {
              done = { icon = "✓" },
              pending = { icon = "○" },
              undone = { icon = "✗" },
              uncertain = { icon = "?" },
              urgent = { icon = "⚠" },
              recurring = { icon = "↻" },
              on_hold = { icon = "⏸" },
              cancelled = { icon = "⊘" },
            },
          },
        },
      },
      ["core.esupports.metagen"] = { author = "Cristian Correa", type = "auto" },

      -- ========================================================================
      -- Directorios y workspace
      -- ========================================================================
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Documents/notes", -- Workspace principal
            reviews = "~/Documents/notes/0-reviews",
            projects = "~/Documents/notes/1-projects",
            areas = "~/Documents/notes/3-areas",
            resources = "~/Documents/notes/4-resources",
          },
          default_workspace = "notes",
          index = "index.norg",
        },
      },

      -- ========================================================================
      -- Completion
      -- ========================================================================
      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },

      -- ========================================================================
      -- Export y conversión
      -- ========================================================================
      ["core.export"] = { export_dir = "~/Downloads/" },
      ["core.export.markdown"] = {
        config = {
          extensions = "all",
        },
      },

      -- ========================================================================
      -- Journal y fecha
      -- ========================================================================
      ["core.journal"] = {
        config = {
          workspace = "reviews",
          journal_folder = "4-daily",
          strategy = "flat",
          use_template = false,
        },
      },

      -- ========================================================================
      -- UI y presentación
      -- ========================================================================
      ["core.ui"] = {},
      ["core.ui.calendar"] = {},

      -- ========================================================================
      -- Keybinds
      -- ========================================================================
      ["core.keybinds"] = {
        config = {
          default_keybinds = true,
        },
      },

      -- ========================================================================
      -- Esums (resúmenes/sumarios)
      -- ========================================================================
      ["core.summary"] = {},

      -- ========================================================================
      -- Qol (Quality of Life)
      -- ========================================================================
      ["core.qol.toc"] = {}, -- Tabla de contenidos
      ["core.qol.todo_items"] = {}, -- Mejoras para TODOs
      ["core.todo-introspector"] = {}, -- virtual text fot TODOs
    },
  },
  config = function(_, opts)
    require("neorg").setup(opts)
    -- Autocommand para configurar opciones específicas en buffers .norg
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "norg",
      callback = function()
        vim.opt_local.conceallevel = 2 -- Ocultar sintaxis para renderizado limpio
        vim.opt_local.concealcursor = "nc" -- Ocultar en normal y command mode
        vim.opt_local.wrap = true -- Wrap lines para mejor lectura
        vim.opt_local.linebreak = true -- Romper líneas en palabras completas
        vim.opt_local.spell = true -- Spell checking
      end,
    })
  end,
}
