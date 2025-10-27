-- Habilita caché de módulos Lua para mejorar velocidad de inicio
vim.loader.enable()

-- Verifica dependencias ejecutables al inicio
local utils = require("utils")

-- Verifica versión mínima requerida de Neovim
local expected_version = "0.11.3"
utils.is_compatible_version(expected_version)

-- Cargar variables globales y desactivar providers/plugins innecesarios
require("globals")

-- Verifica si estamos en un repositorio git (para lazy-loading)
vim.defer_fn(function()
  utils.inside_git_repo()
end, 100)

-- Carga las opciones básicas y los atajos de teclado personalizados
require("config.options")
require("config.keymaps")
require("config.autocmd")

-- Carga la configuración de plugins (usando lazy.nvim)
require("plugins")

-- Verifica dependencias opcionales después de cargar plugins
vim.defer_fn(function()
  require("config.healthcheck").check_optional_deps()
end, 1000)
