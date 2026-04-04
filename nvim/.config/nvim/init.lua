-- Habilita caché de módulos Lua para mejorar velocidad de inicio
vim.loader.enable()

-- Utilidades del sistema
local utils = require("utils")

-- Verifica version minima requerida de Neovim (0.12 para vim.pack)
utils.is_compatible_version("0.12.0")

-- Variables globales y desactivar providers/plugins innecesarios
require("globals")

-- Verifica si estamos en un repositorio git (para lazy-loading de gitsigns)
vim.defer_fn(function()
  utils.inside_git_repo()
end, 100)

-- Configuracion core
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("config.commands")

-- Colorscheme (00-kanagawa.lua ya lo instalo via plugin/)
vim.cmd.colorscheme("kanagawa-dragon")
