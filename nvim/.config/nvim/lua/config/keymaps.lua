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
-- NOTE: <C-S-s> is intercepted by Kitty, so use leader instead
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

-- ─── Split Navigation ──────────────────────────────────────────────────────
-- Handled by smart-splits.nvim: seamless Ctrl+HJKL across Neovim <-> Kitty
-- See lua/config/plugins/smart-splits.lua

-- ─── Line Wrapping Toggle ──────────────────────────────────────────────────
map("n", "lw", "<cmd>set wrap!<CR>", opts)

-- ─── Visual Mode ────────────────────────────────────────────────────────────
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Keep last yank when pasting over selection
map("v", "p", '"_dP', opts)

-- ─── Text Case Conversion ───────────────────────────────────────────────────
-- NOTE: Moved from Alt+u/t (conflicts with GACS HRM ring finger = Alt)
-- Works in normal mode: converts word under cursor
map("n", "<leader>U", "viwU", { noremap = true, silent = true, desc = "UPPERCASE word" })
map("n", "<leader>u", "viwu", { noremap = true, silent = true, desc = "lowercase word" })
map("n", "<leader>~", "viw~", { noremap = true, silent = true, desc = "Toggle case word" })

-- ─── Data Science / REPL ────────────────────────────────────────────────────
-- Quick cell send with Ctrl+Enter (works in normal and visual mode)
map("n", "<C-CR>", "<Plug>SlimeSendCell", { desc = "Send cell to REPL" })
map("x", "<C-CR>", "<Plug>SlimeRegionSend", { desc = "Send selection to REPL" })
-- Send line with Shift+Enter
map("n", "<S-CR>", "<Plug>SlimeLineSend", { desc = "Send line to REPL" })
