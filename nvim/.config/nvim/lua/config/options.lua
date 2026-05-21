-- =============================================================================
-- Opciones de Neovim
-- =============================================================================

-- Performance
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.synmaxcol = 250
vim.opt.redrawtime = 1500

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "+1"
vim.opt.title = true
vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.signcolumn = "yes:1"

vim.opt.fillchars = {
  fold = " ",
  foldsep = " ",
  vert = "│",
  eob = " ",
  msgsep = "‾",
  diff = "╱",
}
vim.opt.showbreak = "↪"

-- Indentación
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.shiftround = true

vim.opt.list = true
vim.opt.listchars = "leadmultispace:󰇙   ,tab:󰇙 ,trail:¤,nbsp:·,extends:⟩,precedes:⟨,eol:↲"

-- Búsqueda
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Clipboard del sistema
vim.opt.clipboard = "unnamedplus"

-- Spell
vim.opt.spelllang = { "en", "es" }
vim.opt.spellsuggest = "best,9"



-- Ripgrep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Completado
vim.opt.pumheight = 10
vim.opt.pumblend = 5
vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:longest"

vim.opt.wildignore:append({
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**",
  "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.tiff",
  "*.svg", "*.ico", "*.pyc", "*.pkl", "*.DS_Store",
})

vim.opt.shortmess:append("c")
vim.opt.shortmess:append("S")
vim.opt.shortmess:append("I")

-- Archivos
vim.opt.autoread = true
vim.opt.undofile = true
vim.opt.autowrite = true
vim.opt.confirm = true

vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupcopy = "yes"
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"

local utils = require("utils")
utils.may_create_dir(vim.fn.stdpath("data") .. "/backup")

-- Ventanas
vim.opt.textwidth = 80
vim.opt.winwidth = 88
vim.opt.scrolloff = 15
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"

-- Diff
vim.opt.diffopt = {
  "vertical", "filler", "closeoff", "context:3",
  "internal", "indent-heuristic", "algorithm:histogram", "linematch:60",
}
