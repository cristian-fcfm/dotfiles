-- Define la tecla leader como espacio
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Atajos de teclado personalizados
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Deshabilitar comportamiento por defecto de la barra espaciadora en modos Normal y Visual
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Guardar archivo
map("n", "<C-s>", "<cmd> w <CR>", opts)

-- Guardar archivo sin auto-formateo
map("n", "<C-S-s>", "<cmd>noautocmd w <CR>", opts)

-- Salir del archivo
map("n", "<C-q>", "<cmd> q <CR>", opts)

-- Scroll vertical y centrar
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Navegación rápida de línea
map({ "n", "v" }, "H", "^", opts)
map({ "n", "v" }, "L", "$", opts)

-- Navegar entre splits
map("n", "<C-k>", ":wincmd k<CR>", opts)
map("n", "<C-j>", ":wincmd j<CR>", opts)
map("n", "<C-h>", ":wincmd h<CR>", opts)
map("n", "<C-l>", ":wincmd l<CR>", opts)

-- Alternar line wrapping
map("n", "lw", "<cmd>set wrap!<CR>", opts)

-- Permanecer en modo indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Mantener último yank al pegar
map("v", "p", '"_dP', opts)

-- Convertir la palabra bajo el cursor a mayúsculas (modo Insert)
map("i", "<A-u>", "<Esc>viwUea", opts)

-- Convertir la palabra actual a título (modo Insert)
map("i", "<A-t>", "<Esc>b~lea", opts)
