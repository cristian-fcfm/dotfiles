return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    -- Función para mostrar idiomas de spell checking
    local function spell_lang()
      if vim.o.spell then
        local lang = vim.o.spelllang
        return "󰓆 " .. lang:upper()
      end
      return ""
    end

    require("lualine").setup({
      options = {
        theme = "iceberg_dark",
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        icons_enabled = true,
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
        refresh = {
          statusline = 1000,
        },
      },
      sections = {
        lualine_a = {
          "mode",
        },
        lualine_b = {
          {
            function()
              return vim.b.gitsigns_head or ""
            end,
            icon = "󰊢",
            separator = { left = "", right = "" },
            padding = { left = 1, right = 0 },
            -- color = { bg = "#3b4261" },
          },
          {
            "diff",
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
            symbols = { added = " ", modified = " ", removed = " " },
            -- color = { bg = "#3b4261" },
          },
        },
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            separator = { left = "", right = "" },
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            symbols = {
              readonly = "󰈡",
              modified = "",
            },
            padding = { left = 0, right = 1 },
          },
          "searchcount",
        },
        lualine_x = {
          {
            "lsp_status",
            icon = "󰒋",
            symbols = { separator = "   ", done = "", spinner = "" },
          },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_y = {
          {
            spell_lang,
            color = { bg = "#3b4261" },
          },
          {
            "fileformat",
            symbols = {
              unix = "",
              mac = "",
            },
          },
          { "encoding", fmt = string.upper },
          {
            "filesize",
            fmt = string.upper,
          },
        },
        lualine_z = {
          "location",
          "progress",
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "quickfix", "oil", "trouble", "lazy" },
    })
  end,
}
