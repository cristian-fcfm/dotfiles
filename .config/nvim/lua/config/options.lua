-- Opciones básicas de Neovim

-- UI y apariencia
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.termguicolors = true
vim.opt.colorcolumn = '+1'
vim.opt.title = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmatch = true

-- Indentación y formato
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.wrap = true
vim.cmd "set formatoptions-=t"

-- Guías de indentación
vim.opt.list = true
vim.opt.listchars = 'leadmultispace:󰇙   ,tab:󰇙 ,trail:¤,nbsp:·,extends:⟩,precedes:⟨,eol:↲'

-- Búsqueda
vim.opt.incsearch = true

-- Mouse y clipboard
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

-- Completado
vim.opt.completeopt = 'menuone,noselect'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.showfulltag = true

-- Historial y archivos
vim.opt.undofile = true
vim.opt.modeline = true
vim.opt.autoread = true

-- Ventanas y scroll
vim.opt.tw = 80
vim.opt.winwidth = 88
vim.opt.scrolloff = 10
vim.opt.lazyredraw = true

-- Folds
vim.g.ip_skipfold = true
