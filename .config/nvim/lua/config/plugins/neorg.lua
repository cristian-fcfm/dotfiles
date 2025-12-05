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
      ["core.defaults"] = {}, -- Carga módulos esenciales por defecto
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
          engine = "nvim-cmp", -- Compatible con blink.cmp vía blink.compat
        },
      },

      -- ========================================================================
      -- Export y conversión
      -- ========================================================================
      ["core.export"] = {},
      ["core.export.markdown"] = {
        config = {
          extensions = "all",
        },
      },

      -- ========================================================================
      -- Integración con external tools
      -- ========================================================================
      ["core.integrations.treesitter"] = {},

      -- ========================================================================
      -- Journal y fecha
      -- ========================================================================
      ["core.journal"] = {
        config = {
          workspace = "notes",
          journal_folder = "0-reviews/4-daily",
          strategy = "flat", -- flat | nested
          template_name = "daily.norg",
        },
      },

      -- ========================================================================
      -- Templates
      -- ========================================================================
      ["core.templates"] = {
        config = {
          templates_dir = "~/Documents/notes/.neorg/templates",
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
          -- Hooks personalizados (opcional)
          hook = function(keybinds)
            -- ========================================================================
            -- NAVIGATION
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>nn", "<cmd>Neorg index<CR>", { desc = "Abrir índice del workspace" })
            keybinds.map("norg", "n", "<LocalLeader>nw", "<cmd>Neorg workspace<CR>", { desc = "Cambiar workspace" })

            -- Búsqueda con Snacks picker
            keybinds.map("norg", "n", "<LocalLeader>nf", function()
              Snacks.picker.files({ cwd = "~/Documents/notes" })
            end, { desc = "Buscar notas (archivos)" })

            keybinds.map("norg", "n", "<LocalLeader>ng", function()
              Snacks.picker.grep({ cwd = "~/Documents/notes" })
            end, { desc = "Buscar en contenido (grep)" })

            keybinds.map("norg", "n", "<LocalLeader>nr", function()
              Snacks.picker.recent({ cwd = "~/Documents/notes" })
            end, { desc = "Notas recientes" })

            -- ========================================================================
            -- JOURNAL - DÍA
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>jd", "<cmd>Neorg journal today<CR>", { desc = "Journal: Hoy" })
            keybinds.map(
              "norg",
              "n",
              "<LocalLeader>jD",
              "<cmd>Neorg journal yesterday<CR>",
              { desc = "Journal: Ayer" }
            )
            keybinds.map(
              "norg",
              "n",
              "<LocalLeader>j<C-d>",
              "<cmd>Neorg journal tomorrow<CR>",
              { desc = "Journal: Mañana" }
            )

            -- ========================================================================
            -- JOURNAL - SEMANA
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>jw", function()
              local year = os.date("%Y")
              local week = os.date("%V")
              local path = string.format("~/Documents/notes/0-reviews/3-weekly/%s-W%s.norg", year, week)
              _G.create_note_with_template(path, "weekly.norg")
            end, { desc = "Journal: Semana actual" })

            keybinds.map("norg", "n", "<LocalLeader>jW", function()
              local date = os.time() - (7 * 24 * 60 * 60) -- Restar 7 días
              local year = os.date("%Y", date)
              local week = os.date("%V", date)
              local path = string.format("~/Documents/notes/0-reviews/3-weekly/%s-W%s.norg", year, week)
              _G.create_note_with_template(path, "weekly.norg")
            end, { desc = "Journal: Semana anterior" })

            keybinds.map("norg", "n", "<LocalLeader>j<C-w>", function()
              local date = os.time() + (7 * 24 * 60 * 60) -- Sumar 7 días
              local year = os.date("%Y", date)
              local week = os.date("%V", date)
              local path = string.format("~/Documents/notes/0-reviews/3-weekly/%s-W%s.norg", year, week)
              _G.create_note_with_template(path, "weekly.norg")
            end, { desc = "Journal: Semana siguiente" })

            -- ========================================================================
            -- JOURNAL - MES
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>jm", function()
              local year = os.date("%Y")
              local month = os.date("%m")
              local path = string.format("~/Documents/notes/0-reviews/2-monthly/%s-M%s.norg", year, month)
              _G.create_note_with_template(path, "monthly.norg")
            end, { desc = "Journal: Mes actual" })

            keybinds.map("norg", "n", "<LocalLeader>jM", function()
              local current_month = tonumber(os.date("%m"))
              local current_year = tonumber(os.date("%Y"))

              if current_month == 1 then
                current_year = current_year - 1
                current_month = 12
              else
                current_month = current_month - 1
              end

              local path = string.format(
                "~/Documents/notes/0-reviews/2-monthly/%04d-M%02d.norg",
                current_year,
                current_month
              )
              _G.create_note_with_template(path, "monthly.norg")
            end, { desc = "Journal: Mes anterior" })

            keybinds.map("norg", "n", "<LocalLeader>j<C-m>", function()
              local current_month = tonumber(os.date("%m"))
              local current_year = tonumber(os.date("%Y"))

              if current_month == 12 then
                current_year = current_year + 1
                current_month = 1
              else
                current_month = current_month + 1
              end

              local path = string.format(
                "~/Documents/notes/0-reviews/2-monthly/%04d-M%02d.norg",
                current_year,
                current_month
              )
              _G.create_note_with_template(path, "monthly.norg")
            end, { desc = "Journal: Mes siguiente" })

            -- ========================================================================
            -- JOURNAL - AÑO
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>jy", function()
              local year = os.date("%Y")
              local path = string.format("~/Documents/notes/0-reviews/1-yearly/%s.norg", year)
              _G.create_note_with_template(path, "yearly.norg")
            end, { desc = "Journal: Año actual" })

            keybinds.map("norg", "n", "<LocalLeader>jY", function()
              local year = tonumber(os.date("%Y")) - 1
              local path = string.format("~/Documents/notes/0-reviews/1-yearly/%04d.norg", year)
              _G.create_note_with_template(path, "yearly.norg")
            end, { desc = "Journal: Año anterior" })

            keybinds.map("norg", "n", "<LocalLeader>j<C-y>", function()
              local year = tonumber(os.date("%Y")) + 1
              local path = string.format("~/Documents/notes/0-reviews/1-yearly/%04d.norg", year)
              _G.create_note_with_template(path, "yearly.norg")
            end, { desc = "Journal: Año siguiente" })

            -- ========================================================================
            -- TEMPLATES
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>tp", function()
              vim.cmd("Neorg templates load project.norg")
            end, { desc = "Template: Project" })

            keybinds.map("norg", "n", "<LocalLeader>ta", function()
              vim.cmd("Neorg templates load area.norg")
            end, { desc = "Template: Area" })

            keybinds.map("norg", "n", "<LocalLeader>tr", function()
              vim.cmd("Neorg templates load resource.norg")
            end, { desc = "Template: Resource" })

            keybinds.map("norg", "n", "<LocalLeader>tm", function()
              vim.cmd("Neorg templates load meeting.norg")
            end, { desc = "Template: Meeting" })

            keybinds.map("norg", "n", "<LocalLeader>tz", function()
              vim.cmd("Neorg templates load zettel.norg")
            end, { desc = "Template: Zettel" })

            -- ========================================================================
            -- TASKS
            -- ========================================================================
            keybinds.map("norg", "n", "<LocalLeader>td", "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_done<CR>", {
              desc = "Marcar tarea como completada",
            })
            keybinds.map(
              "norg",
              "n",
              "<LocalLeader>tu",
              "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_undone<CR>",
              { desc = "Marcar tarea como pendiente" }
            )
            keybinds.map(
              "norg",
              "n",
              "<LocalLeader>tP",
              "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_pending<CR>",
              { desc = "Marcar tarea como en progreso" }
            )
          end,
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
    },
  },
  config = function(_, opts)
    require("neorg").setup(opts)

    -- Función helper para crear nota con template
    local function create_note_with_template(path, template_name)
      local expanded_path = vim.fn.expand(path)
      local file_exists = vim.fn.filereadable(expanded_path) == 1

      -- Abrir el archivo
      vim.cmd("edit " .. path)

      -- Si no existe, cargar el template
      if not file_exists then
        vim.cmd("Neorg templates load " .. template_name)
      end
    end

    -- Hacer la función global para usar en keymaps
    _G.create_note_with_template = create_note_with_template

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
