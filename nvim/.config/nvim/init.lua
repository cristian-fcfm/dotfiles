-- Habilita caché de módulos Lua para mejorar velocidad de inicio
vim.loader.enable()

-- Variables globales y desactivar providers/plugins innecesarios
require("globals")

-- Configuracion core
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("config.commands")
