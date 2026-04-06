-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable default space behavior in Normal and Visual
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ─── File Operations ────────────────────────────────────────────────────────
map("n", "<C-s>", "<cmd> w <CR>", opts)
-- Save without autocommands (e.g. skip formatters on save)
map("n", "<leader>S", "<cmd>noautocmd w <CR>", { noremap = true, silent = true, desc = "Save without autocmds" })
map("n", "<C-q>", "<cmd> q <CR>", opts)

-- ─── Scrolling ──────────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- ─── Line Navigation ───────────────────────────────────────────────────────
-- H/L jump to start/end of line
-- With GACS HRM, H and L are plain keys (no mod-tap), so these work cleanly
map({ "n", "v" }, "H", "^", opts)
map({ "n", "v" }, "L", "$", opts)

-- ─── Line Wrapping Toggle ──────────────────────────────────────────────────
map("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- ─── Visual Mode ────────────────────────────────────────────────────────────
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yank when pasting over selection
map("v", "p", '"_dP', opts)

-- ─── Text Case Conversion ───────────────────────────────────────────────────
-- Works in normal mode: converts word under cursor
map("n", "<leader>U", "viwU", { noremap = true, silent = true, desc = "UPPERCASE word" })
map("n", "<leader>u", "viwu", { noremap = true, silent = true, desc = "lowercase word" })
map("n", "<leader>~", "viw~", { noremap = true, silent = true, desc = "Toggle case word" })

-- ─── Comentar ───────────────────────────────────────────────────────────────
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- ─── Buffers ────────────────────────────────────────────────────────────────
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<CR>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Close other buffers" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bf", function()
  Snacks.picker.buffers({ layout = "ivy" })
end, { desc = "Find buffers" })

-- ─── Tabs ───────────────────────────────────────────────────────────────────
map("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>t]", ":tabn<CR>", { desc = "Next tab" })
map("n", "<leader>t[", ":tabp<CR>", { desc = "Previous tab" })
map("n", "<leader>to", ":tabonly<CR>", { desc = "Close other tabs" })

-- ─── Windows ────────────────────────────────────────────────────────────────
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal size" })
map("n", "<leader>wc", ":close<CR>", { desc = "Close window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close others" })
