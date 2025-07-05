-- Este archivo configura lazy.nvim y carga los plugins definidos en archivos separados

-- Instala lazy.nvim automáticamente si no está presente
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Usa la última versión estable
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Carga los plugins desde los archivos en config/plugins/
require("lazy").setup({
  { import = "config.plugins.colorscheme" }, -- Tema de colores
  { import = "config.plugins.treesitter" },  -- Resaltado de sintaxis avanzado
  { import = "config.plugins.telescope" },   -- Buscador tipo fuzzy
  { import = "config.plugins.nvimtree" },    -- Explorador de archivos
  { import = "config.plugins.lualine" },     -- Barra de estado
})
