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
  { import = "config.plugins.whichkey" }, -- Mostrar atajos de teclado
  { import = "config.plugins.treesitter" }, -- Resaltado de sintaxis avanzado
  { import = "config.plugins.fzflua" }, -- Buscador tipo fuzzy
  { import = "config.plugins.oil" }, -- Explorador de archivos
  { import = "config.plugins.lualine" }, -- Barra de estado
  { import = "config.plugins.alpha" }, -- Dashboard nvim
  { import = "config.plugins.lsp" }, -- LSP
  { import = "config.plugins.completion" }, -- Completado de codigo
  { import = "config.plugins.autopairs" }, -- Auto-pairing inteligente
  { import = "config.plugins.formatting" }, -- Formateo de codigo
  { import = "config.plugins.linting" }, -- Linting de codigo
  { import = "config.plugins.slime" }, -- REPL
  { import = "config.plugins.todocomments" }, -- TODO comments con fzf-lua
  { import = "config.plugins.mini" }, -- Mini plugins (move, surround, comment, etc)
  { import = "config.plugins.tmux" }, -- Integración Tmux-Neovim
  { import = "config.plugins.gitsigns" }, -- Muestra cambios de git
  { import = "config.plugins.bufferline" }, -- Buffer line mejorada
  { import = "config.plugins.hlslens" }, -- Mejora visual de búsquedas
  { import = "config.plugins.notify" }, -- Sistema de notificaciones mejorado
  { import = "config.plugins.zk" }, -- Zettelkasten y renderizado Markdown
})
