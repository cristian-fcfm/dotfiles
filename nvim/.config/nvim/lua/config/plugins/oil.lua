return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  cmd = "Oil",
  keys = {
    { ".", "<cmd>Oil<cr>", desc = "Open Oil (normal)" },
    { "--", "<cmd>Oil --float<cr>", desc = "Open Oil (float)" },
  },
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    -- Opciones de performance
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
    -- Keymaps
    keymaps = {
      ["yp"] = {
        desc = "Copiar path absoluto",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if entry and dir then
            local path = dir .. entry.name
            vim.fn.setreg("+", path)
          end
        end,
      },
      ["yr"] = {
        desc = "Copiar path relativo",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if entry and dir then
            local path = dir .. entry.name
            local relative = vim.fn.fnamemodify(path, ":.")
            vim.fn.setreg("+", relative)
          end
        end,
      },
    },
  },
}
