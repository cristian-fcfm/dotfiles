-- Define la tecla leader como espacio
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Atajos de teclado personalizados
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- save file
map("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
map("n", "<C-S-s>", "<cmd>noautocmd w <CR>", opts)

-- quit file
map("n", "<C-q>", "<cmd> q <CR>", opts)

-- Vertical scroll and center
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Fast line navigation
map({ "n", "v" }, "H", "^", opts)
map({ "n", "v" }, "L", "$", opts)

-- Navigate between splits
map("n", "<C-k>", ":wincmd k<CR>", opts)
map("n", "<C-j>", ":wincmd j<CR>", opts)
map("n", "<C-h>", ":wincmd h<CR>", opts)
map("n", "<C-l>", ":wincmd l<CR>", opts)

-- Toggle line wrapping
map("n", "lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yanked when pasting
map("v", "p", '"_dP', opts)

-- Turn the word under cursor to upper case (Insert mode)
map("i", "<A-u>", "<Esc>viwUea", opts)

-- Turn the current word into title case (Insert mode)
map("i", "<A-t>", "<Esc>b~lea", opts)
