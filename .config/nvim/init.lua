-- Carga las opciones básicas y los atajos de teclado personalizados
require('config.options')
require('config.keymaps')
require('config.autocmd')

-- Carga la configuración de plugins (usando lazy.nvim)
require('plugins')
