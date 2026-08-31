-- ============================================================================
-- Grug Far: buscar y reemplazar en todo el proyecto (requiere rg)
-- ============================================================================
local loaded = false

local function load_grug_far()
  if not loaded then
    vim.pack.add({
      { src = "https://github.com/MagicDuck/grug-far.nvim" },
    })
    require("grug-far").setup({})
    loaded = true
  end
end

local map = vim.keymap.set

map("n", "<leader>fa", function()
  load_grug_far()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Reemplazar en proyecto (palabra actual)" })

map("n", "<leader>fA", function()
  load_grug_far()
  require("grug-far").open()
end, { desc = "Reemplazar en proyecto" })

map("x", "<leader>fa", function()
  load_grug_far()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  local selection = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), vim.fn.visualmode()), "\n")
  require("grug-far").open({ prefills = { search = selection } })
end, { desc = "Reemplazar en proyecto (selección)" })
