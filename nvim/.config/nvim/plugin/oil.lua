-- =============================================================================
-- Configuracion Oil
-- =============================================================================
local oil_loaded = false

local function load_oil(float)
  if not oil_loaded then
    vim.pack.add({
      { src = "https://github.com/stevearc/oil.nvim" },
    })

    require("oil").setup({
      view_options = { show_hidden = true },
      float = {
        padding = 2,
        max_width = 0.9,
        max_height = 0.9,
        border = "rounded",
        win_options = { winblend = 0 },
      },
      skip_confirm_for_simple_edits = true,
      delete_to_trash = true,
      keymaps = {
        ["yp"] = {
          desc = "Copiar path absoluto",
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            local dir = oil.get_current_dir()
            if entry and dir then
              vim.fn.setreg("+", dir .. entry.name)
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
              vim.fn.setreg("+", vim.fn.fnamemodify(path, ":."))
            end
          end,
        },
      },
    })
    oil_loaded = true
  end

  if float then
    require("oil").open_float()
  else
    require("oil").open()
  end
end

-- =============================================================================
-- Atajos de teclado
-- =============================================================================
vim.keymap.set("n", "-", function() load_oil(false) end, { desc = "Abrir Oil" })
vim.keymap.set("n", "--", function() load_oil(true) end, { desc = "Abrir Oil (flotante)" })
