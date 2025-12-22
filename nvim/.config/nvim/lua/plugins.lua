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
  { import = "config.plugins.oil" }, -- Explorador de archivos
  { import = "config.plugins.lualine" }, -- Barra de estado
  { import = "config.plugins.lsp" }, -- LSP
  { import = "config.plugins.completion" }, -- Completado de codigo
  { import = "config.plugins.yanky" }, -- Gestión avanzada del clipboard
  { import = "config.plugins.autopairs" }, -- Auto-pairing inteligente
  { import = "config.plugins.formatting" }, -- Formateo de codigo
  { import = "config.plugins.linting" }, -- Linting de codigo
  { import = "config.plugins.slime" }, -- REPL
  { import = "config.plugins.todocomments" }, -- TODO comments con fzf-lua
  { import = "config.plugins.mini" }, -- Mini plugins (move, surround, comment, etc)
  { import = "config.plugins.gitsigns" }, -- Muestra cambios de git
  { import = "config.plugins.markdown-render" }, -- Renderizado Markdown
  -- { import = "config.plugins.neorg" }, -- Organización y notas con Neorg (deshabilitado temporalmente - incompatible con nvim-treesitter main)
  { import = "config.plugins.markdown-preview" }, -- Live preview para Markdown
  { import = "config.plugins.typst" }, -- Typst para composición tipográfica
  { import = "config.plugins.trouble" }, -- Diagnósticos LSP y navegación
  { import = "config.plugins.snacks" }, -- Snacks: QoL plugins (image, bigfile, notifier, etc.)
})
