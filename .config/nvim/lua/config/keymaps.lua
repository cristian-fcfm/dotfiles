-- Atajos de teclado personalizados

local map = vim.keymap.set

-- Abre/cierra el explorador de archivos (nvim-tree)
map('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Atajos para Telescope (buscador de archivos, texto, buffers, ayuda)
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })
