-- Opciones básicas de Neovim

-- Performance y velocidad
vim.opt.timeoutlen = 500 -- Tiempo en ms para esperar secuencias de teclas mapeadas
vim.opt.updatetime = 500 -- Tiempo en ms para CursorHold (diagnósticos, gitsigns)
vim.opt.synmaxcol = 250 -- No resaltar sintaxis después de esta columna (mejora performance)
vim.opt.lazyredraw = true -- No redibujar pantalla durante macros y comandos

-- UI y apariencia
vim.opt.number = true -- Mostrar números de línea
vim.opt.relativenumber = true -- Números relativos (útil para movimientos)
vim.opt.cursorline = true -- Resaltar línea actual
vim.opt.cursorcolumn = true -- Resaltar columna actual
vim.opt.termguicolors = true -- Habilitar colores true color (24-bit)
vim.opt.colorcolumn = "+1" -- Columna de guía en textwidth + 1
vim.opt.title = true -- Actualizar título de la terminal
vim.opt.ruler = false -- Desactivado (lualine ya muestra info de posición)
vim.opt.showcmd = true -- Mostrar comando incompleto en la barra inferior
vim.opt.showmatch = true -- Resaltar paréntesis/corchetes coincidentes
vim.opt.showmode = false -- Ocultar modo (lualine lo muestra)
vim.opt.signcolumn = "yes:1" -- Columna de signos siempre visible (para git, diagnósticos)

-- Caracteres especiales para mejor visualización
vim.opt.fillchars = {
  fold = " ",
  foldsep = " ",
  vert = "│",
  eob = " ", -- Oculta ~ en líneas vacías
  msgsep = "‾",
  diff = "╱",
}

vim.opt.showbreak = "↪" -- Carácter para líneas envueltas

-- Indentación y formato
vim.opt.tabstop = 2 -- Número de espacios que representa un tab
vim.opt.shiftwidth = 2 -- Número de espacios para auto-indentado
vim.opt.expandtab = true -- Convertir tabs a espacios
vim.opt.breakindent = true -- Mantener indentación en líneas envueltas
vim.opt.linebreak = true -- Romper líneas en caracteres de palabra
vim.opt.wrap = true -- Envolver líneas largas
vim.opt.shiftround = true -- Redondear indent al múltiplo más cercano de shiftwidth
vim.cmd("set formatoptions-=t") -- No auto-envolver texto usando textwidth

-- Guías de indentación
vim.opt.list = true -- Mostrar caracteres invisibles
vim.opt.listchars = "leadmultispace:󰇙   ,tab:󰇙 ,trail:¤,nbsp:·,extends:⟩,precedes:⟨,eol:↲"

-- Búsqueda
vim.opt.incsearch = true -- Búsqueda incremental (mostrar matches mientras escribes)
vim.opt.ignorecase = true -- Ignorar mayúsculas/minúsculas en búsqueda
vim.opt.smartcase = true -- Sensible a mayúsculas si la búsqueda contiene mayúsculas

-- Spell checking (corrector ortográfico)
vim.opt.spell = false -- Desactivado por defecto (activar con :set spell)
vim.opt.spelllang = { "en", "es" } -- Idiomas: inglés y español
vim.opt.spellsuggest = "best,9" -- Mostrar las 9 mejores sugerencias

-- Configurar ripgrep como programa de búsqueda
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Mouse y clipboard
vim.opt.mouse = "a" -- Habilitar mouse en todos los modos
vim.opt.clipboard = "unnamedplus" -- Usar clipboard del sistema (+/unnamedplus)

-- Completado
vim.opt.completeopt = { "menuone", "noselect" } -- Mostrar menú siempre, no seleccionar automáticamente
vim.opt.pumheight = 10 -- Máximo 10 items en menú de completado
vim.opt.pumblend = 5 -- Pseudo-transparencia en menú de completado (0-100)
vim.opt.wildmenu = true -- Menú de completado mejorado en línea de comandos
vim.opt.wildignorecase = true -- Ignorar mayúsculas en completado de comandos
vim.opt.wildmode = "list:longest" -- Listar matches y completar hasta string común más largo
vim.opt.showfulltag = true -- Mostrar información completa de tags en completado

-- Ignorar ciertos archivos y carpetas en búsquedas
vim.opt.wildignore:append({
  "*.o",
  "*.obj",
  "*.dylib",
  "*.bin",
  "*.dll",
  "*.exe",
  "*/.git/*",
  "*/.svn/*",
  "*/__pycache__/*",
  "*/build/**",
  "*.jpg",
  "*.png",
  "*.jpeg",
  "*.bmp",
  "*.gif",
  "*.tiff",
  "*.svg",
  "*.ico",
  "*.pyc",
  "*.pkl",
  "*.DS_Store",
})

-- Mensajes más limpios
vim.opt.shortmess:append("c") -- No mostrar "match xx of xx" en completado
vim.opt.shortmess:append("S") -- No mostrar contador de búsquedas
vim.opt.shortmess:append("I") -- No mostrar intro message

-- Historial y archivos
vim.opt.undofile = true -- Undo persistente (mantener historial después de cerrar)
vim.opt.modeline = true -- Leer modelines en archivos (ej: # vim: set ft=python)
vim.opt.autoread = true -- Recargar archivo si cambió externamente
vim.opt.autowrite = true -- Auto-guardar al cambiar de buffer o ejecutar comandos
vim.opt.confirm = true -- Pedir confirmación antes de salir con cambios sin guardar

-- Sistema de backups
vim.opt.swapfile = false -- No crear archivos swap
vim.opt.backup = true -- Crear backups
vim.opt.backupcopy = "yes" -- Copiar archivo original al hacer backup
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"

-- Crear directorio de backups si no existe
local utils = require("utils")
utils.may_create_dir(vim.fn.stdpath("data") .. "/backup")

-- Ventanas y scroll
vim.opt.tw = 80 -- Text width (ancho de texto para formateo)
vim.opt.winwidth = 88 -- Ancho mínimo de ventana
vim.opt.scrolloff = 10 -- Mantener 10 líneas visibles arriba/abajo del cursor
vim.opt.splitbelow = true -- Splits horizontales abren abajo
vim.opt.splitright = true -- Splits verticales abren a la derecha
vim.opt.splitkeep = "screen" -- Mantener texto en pantalla al hacer split (evita flickering)

-- Diff mejorado
vim.opt.diffopt = {
  "vertical", -- Mostrar diffs en split vertical
  "filler", -- Mostrar líneas de relleno para líneas borradas
  "closeoff", -- Cerrar diff cuando se cierra una ventana
  "context:3", -- Mostrar 3 líneas de contexto alrededor de cambios
  "internal", -- Usar diff interno de Neovim
  "indent-heuristic", -- Mejorar detección de cambios usando indentación
  "algorithm:histogram", -- Algoritmo de diff más preciso
  "linematch:60", -- Alinear líneas similares dentro de bloques de cambios
}

-- Folds
vim.g.ip_skipfold = true -- Configuración personalizada de folds
