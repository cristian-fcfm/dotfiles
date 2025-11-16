return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "echasnovski/mini.icons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header ASCII
    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
    }

    -- Botones mejorados con iconos consistentes
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find File", ":FzfLua files<CR>"),
      dashboard.button("r", "󱋡  Recent Files", ":FzfLua oldfiles<CR>"),
      dashboard.button("g", "󰷊  Find Text", ":FzfLua live_grep<CR>"),
      dashboard.button("c", "  Configuration", ":FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
      dashboard.button("n", "󰓩  New File", ":enew<CR>"),
      dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
    }

    -- Footer dinámico con estadísticas de lazy.nvim
    dashboard.section.footer.opts.hl = "Comment"

    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local version = vim.version()
      local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch

      return "⚡ Neovim "
        .. nvim_version
        .. " loaded "
        .. stats.loaded
        .. "/"
        .. stats.count
        .. " plugins in "
        .. ms
        .. "ms"
    end

    -- Actualizar footer dinámicamente
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        dashboard.section.footer.val = footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })

    -- Configuración de layout
    dashboard.opts.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)

    -- Keymaps y configuración adicional para alpha
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "alpha",
      callback = function()
        vim.keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
        vim.keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
        -- Ocultar bufferline en alpha
        vim.opt_local.showtabline = 0
      end,
    })

    -- Restaurar bufferline al salir de alpha
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = "*",
      callback = function()
        if vim.bo.filetype == "alpha" then
          vim.opt.showtabline = 2
        end
      end,
    })
  end,
}
