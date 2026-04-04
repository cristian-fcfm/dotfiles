local function load_oil(float)
  vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim", version = vim.version.range("*") },
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

  if float then
    require("oil").open_float()
  else
    require("oil").open()
  end
end

vim.keymap.set("n", ".", function() load_oil(false) end, { desc = "Open Oil (normal)" })
vim.keymap.set("n", "--", function() load_oil(true) end, { desc = "Open Oil (float)" })
vim.api.nvim_create_user_command("Oil", function(args)
  load_oil(args.args == "--float")
end, { nargs = "?", desc = "Open Oil" })
