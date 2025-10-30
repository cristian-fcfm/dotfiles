-- Plugin para la barra de estado lualine
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    -- Función para mostrar entorno virtual de Python (uv/venv)
    local function virtual_env()
      if vim.bo.filetype ~= "python" then
        return ""
      end

      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        local venv_name = vim.fn.fnamemodify(venv_path, ":t")
        return string.format(" %s", venv_name)
      end

      return ""
    end

    -- Función para mostrar LSP activo
    local function get_active_lsp()
      local buf_ft = vim.bo.filetype
      local clients = vim.lsp.get_clients({ bufnr = 0 })

      if next(clients) == nil then
        return ""
      end

      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return "󰒋 " .. client.name -- Icono LSP
        end
      end

      return ""
    end

    -- Función para indicador de spell checking
    local function spell()
      if vim.o.spell then
        return "[SPELL]"
      end
      return ""
    end

    -- Cache para git ahead/behind (actualizar solo cada 5 min)
    local git_status_cache = {}
    local last_fetch_time = 0
    local FETCH_INTERVAL = 300000 -- 5 minutos

    local function get_git_ahead_behind()
      local now = vim.loop.now()

      -- Solo actualizar si pasaron 5 minutos
      if now - last_fetch_time > FETCH_INTERVAL then
        vim.system({ "git", "rev-list", "--count", "HEAD..@{upstream}" }, { text = true }, function(result)
          if result.code == 0 then
            git_status_cache.behind = tonumber(result.stdout:match("(%d+)")) or 0
          end
        end)

        vim.system({ "git", "rev-list", "--count", "@{upstream}..HEAD" }, { text = true }, function(result)
          if result.code == 0 then
            git_status_cache.ahead = tonumber(result.stdout:match("(%d+)")) or 0
          end
        end)

        last_fetch_time = now
      end

      local msg = ""
      if type(git_status_cache.ahead) == "number" and git_status_cache.ahead > 0 then
        msg = msg .. string.format("↑%d ", git_status_cache.ahead)
      end
      if type(git_status_cache.behind) == "number" and git_status_cache.behind > 0 then
        msg = msg .. string.format("↓%d ", git_status_cache.behind)
      end

      return msg
    end

    require('lualine').setup({
      options = {
        theme = 'auto',
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        icons_enabled = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
        },
      },
      sections = {
        lualine_a = {
          'mode',
        },
        lualine_b = {
          {
            'branch',
            icon = '󰊢',
            fmt = function(name)
              return string.sub(name, 1, 20) -- Truncar nombres largos
            end,
          },
          {
            get_git_ahead_behind,
            color = { fg = '#E0C479' },
          },
          {
            'diff',
            symbols = { added = ' ', modified = ' ', removed = ' ' },
          },
        },
        lualine_c = {
          {
            'filename',
            symbols = {
              readonly = '󰈡',
            },
          },
          {
            virtual_env,
            color = { bg = '#F1CA81' },
          },
          {
            spell,
            color = { fg = 'black', bg = '#a7c080' },
          },
        },
        lualine_x = {
          {
            get_active_lsp,
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
          },
        },
        lualine_y = {
          { 'encoding', fmt = string.upper },
          {
            'fileformat',
            symbols = {
              unix = 'unix',
              dos = 'win',
              mac = 'mac',
            },
          },
          'filetype',
        },
        lualine_z = {
          'location',
          'progress',
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'quickfix', 'oil' },
    })
  end,
}
