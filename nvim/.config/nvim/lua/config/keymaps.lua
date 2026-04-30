-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Disable default space behavior in Normal and Visual
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ─── File Operations ────────────────────────────────────────────────────────
map("n", "<C-s>", "<cmd> w <CR>")
map("n", "<leader>S", "<cmd>noautocmd w <CR>", { desc = "Save without autocmds" })
map("n", "<C-q>", "<cmd> q <CR>")

-- ─── Scrolling ──────────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- ─── Line Navigation ───────────────────────────────────────────────────────
map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "$")

-- ─── Line Wrapping Toggle ──────────────────────────────────────────────────
map("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- ─── Visual Mode ────────────────────────────────────────────────────────────
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "p", '"_dP')

-- ─── Text Case Conversion ───────────────────────────────────────────────────
map("n", "<leader>U", "viwU", { desc = "UPPERCASE word" })
map("n", "<leader>u", "viwu", { desc = "lowercase word" })
map("n", "<leader>~", "viw~", { desc = "Toggle case word" })

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

-- ─── Spell Checking ─────────────────────────────────────────────────────────
map("n", "]s", function() vim.spell.goto_next() end, { desc = "Siguiente error ortográfico" })
map("n", "[s", function() vim.spell.goto_prev() end, { desc = "Anterior error ortográfico" })
map("n", "<leader>sp", "<cmd>set spell!<CR>", { desc = "Activar/desactivar corrección" })
map("n", "<leader>s?", "z=", { desc = "Ver sugerencias" })
map("n", "<leader>sa", "zg", { desc = "Añadir a diccionario" })

-- ─── Git (mini.diff) ────────────────────────────────────────────────────────
map("n", "]g", function() MiniDiff.goto_next() end, { desc = "Next git hunk" })
map("n", "[g", function() MiniDiff.goto_prev() end, { desc = "Previous git hunk" })
map("n", "<leader>hb", function() MiniDiff.toggle_overlay() end, { desc = "Toggle inline diff" })
map("n", "<leader>gh", function() MiniDiff.do_hunks(0, vim.fn.line(".")) end, { desc = "Hunk actions" })
