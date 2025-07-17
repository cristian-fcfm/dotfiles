-- Define la tecla leader como espacio
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Atajos de teclado personalizados
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- save file
map('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
map('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
map('n', '<C-q>', '<cmd> q <CR>', opts)

-- Vertical scroll and center
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
map('n', 'n', 'nzzzv', opts)
map('n', 'N', 'Nzzzv', opts)

-- Buffers
map('n', '<Tab>', ':bnext<CR>', opts)
map('n', '<S-Tab>', ':bprevious<CR>', opts)
map('n', '<leader>x', ':bdelete!<CR>', opts)   -- close buffer
map('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
map('n', '<leader>v', '<C-w>v', opts)      -- split window vertically
map('n', '<leader>h', '<C-w>s', opts)      -- split window horizontally
map('n', '<leader>se', '<C-w>=', opts)     -- make split windows equal width & height
map('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
map('n', '<C-k>', ':wincmd k<CR>', opts)
map('n', '<C-j>', ':wincmd j<CR>', opts)
map('n', '<C-h>', ':wincmd h<CR>', opts)
map('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
map('n', '<leader>to', ':tabnew<CR>', opts)   -- open new tab
map('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
map('n', '<leader>tn', ':tabn<CR>', opts)     --  go to next tab
map('n', '<leader>tp', ':tabp<CR>', opts)     --  go to previous tab

-- Toggle line wrapping
map('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- Keep last yanked when pasting
map('v', 'p', '"_dP', opts)
