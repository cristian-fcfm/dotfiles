-- =============================================================================
-- Configuracion Smart Splits (navegacion Neovim <-> Kitty)
-- =============================================================================

vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

-- Instalar kittens si no existen
local plugin_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/smart-splits.nvim"
local kittens_script = plugin_path .. "/kitty/install-kittens.bash"
if vim.fn.filereadable(kittens_script) == 1 then
  vim.fn.system("cd " .. vim.fn.shellescape(plugin_path) .. " && bash ./kitty/install-kittens.bash")
end

local ss = require("smart-splits")

ss.setup({
  multiplexer_integration = "kitty",
  at_edge = "stop",
  disable_multiplexer_nav_when_zoomed = true,
})

-- Keymaps: navegacion entre splits (Ctrl+HJKL, seamless con Kitty)
vim.keymap.set("n", "<C-h>", ss.move_cursor_left, { desc = "Ir al split izquierdo" })
vim.keymap.set("n", "<C-j>", ss.move_cursor_down, { desc = "Ir al split inferior" })
vim.keymap.set("n", "<C-k>", ss.move_cursor_up, { desc = "Ir al split superior" })
vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Ir al split derecho" })

-- Keymaps: swap de buffers entre splits (Ctrl+Shift+HJKL)
vim.keymap.set("n", "<C-S-h>", ss.swap_buf_left, { desc = "Swap buffer izquierda" })
vim.keymap.set("n", "<C-S-j>", ss.swap_buf_down, { desc = "Swap buffer abajo" })
vim.keymap.set("n", "<C-S-k>", ss.swap_buf_up, { desc = "Swap buffer arriba" })
vim.keymap.set("n", "<C-S-l>", ss.swap_buf_right, { desc = "Swap buffer derecha" })
