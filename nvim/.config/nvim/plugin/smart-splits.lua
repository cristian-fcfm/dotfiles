-- =============================================================================
-- Configuracion Smart Splits (navegacion Neovim <-> Kitty)
-- =============================================================================

-- ===========================================================================
-- Build hook (instalar kittens al descargar)
-- ===========================================================================
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "smart-splits.nvim" and ev.data.kind == "install" then
      if not ev.data.active then
        vim.cmd.packadd("smart-splits.nvim")
      end
      vim.fn.system({
        "bash",
        vim.fn.stdpath("data") .. "/site/pack/core/opt/smart-splits.nvim/kitty/install-kittens.bash",
      })
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

-- ===========================================================================
-- Setup
-- ===========================================================================
local ss = require("smart-splits")

ss.setup({
  multiplexer_integration = "kitty",
  at_edge = "stop",
  disable_multiplexer_nav_when_zoomed = true,
})

-- ===========================================================================
-- Keymaps
-- ===========================================================================
local map = vim.keymap.set

-- Navegacion entre splits (Ctrl+HJKL, seamless con Kitty)
map("n", "<C-h>", ss.move_cursor_left, { desc = "Move to left split" })
map("n", "<C-j>", ss.move_cursor_down, { desc = "Move to below split" })
map("n", "<C-k>", ss.move_cursor_up, { desc = "Move to above split" })
map("n", "<C-l>", ss.move_cursor_right, { desc = "Move to right split" })

-- TODO: definir keybind para swap buffers entre splits
-- map("n", "??h", ss.swap_buf_left, { desc = "Swap buffer left" })
-- map("n", "??j", ss.swap_buf_down, { desc = "Swap buffer down" })
-- map("n", "??k", ss.swap_buf_up, { desc = "Swap buffer up" })
-- map("n", "??l", ss.swap_buf_right, { desc = "Swap buffer right" })
