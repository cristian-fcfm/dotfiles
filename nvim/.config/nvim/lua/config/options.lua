-- Opciones básicas de Neovim

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
vim.cmd("set formatoptions-=t")

vim.opt.list = true
vim.opt.listchars = "leadmultispace:󰇙   ,tab:󰇙 ,trail:¤,nbsp:·,extends:⟩,precedes:⟨,eol:↲"

-- Búsqueda
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Spell
vim.opt.spelllang = { "en", "es" }
vim.opt.spellsuggest = "best,9"

vim.schedule(function()
  local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
  vim.fn.mkdir(spell_dir, "p")
  for _, lang in ipairs({ "en", "es" }) do
    local spell_file = spell_dir .. "/" .. lang .. ".utf-8.spl"
    if vim.fn.filereadable(spell_file) == 0 then
      vim.cmd("silent! mkspell! " .. spell_file .. " " .. spell_dir .. "/" .. lang)
      local url = "https://ftp.nluug.nl/vim/runtime/spell/" .. lang .. ".utf-8.spl"
      vim.fn.system({ "curl", "-fLo", spell_file, "--create-dirs", url })
    end
  end
end)

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
vim.opt.showfulltag = true

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
vim.opt.tw = 80
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
