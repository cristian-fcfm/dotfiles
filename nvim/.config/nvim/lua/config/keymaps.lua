-- ============================================================================
-- Atajos de teclado
-- ============================================================================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set

-- Desactivar comportamiento por defecto de espacio
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ─── Archivos ───────────────────────────────────────────────────────────────
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Guardar archivo" })
map("n", "<leader>S", "<cmd>noautocmd w<CR>", { desc = "Guardar sin autocmds" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Cerrar ventana" })

-- ─── Scroll ─────────────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll abajo centrado" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll arriba centrado" })

-- ─── Navegacion de linea ────────────────────────────────────────────────────
map({ "n", "v" }, "H", "^", { desc = "Inicio de linea" })
map({ "n", "v" }, "L", "$", { desc = "Fin de linea" })

-- ─── Line wrap ──────────────────────────────────────────────────────────────
map("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Alternar ajuste de linea" })

-- ─── Modo visual ────────────────────────────────────────────────────────────
map("v", "<", "<gv", { desc = "Indentar izquierda y reseleccionar" })
map("v", ">", ">gv", { desc = "Indentar derecha y reseleccionar" })
map("v", "p", '"_dP', { desc = "Pegar sin sobreescribir registro" })

-- ─── Conversion de texto ────────────────────────────────────────────────────
map("n", "<leader>U", "viwU", { desc = "MAYUSCULAS palabra" })
map("n", "<leader>u", "viwu", { desc = "minusculas palabra" })
map("n", "<leader>~", "viw~", { desc = "Alternar mayusculas/minusculas" })

-- ─── Comentar ───────────────────────────────────────────────────────────────
map("n", "<leader>/", "gcc", { remap = true, desc = "Comentar/descomentar linea" })
map("v", "<leader>/", "gc", { remap = true, desc = "Comentar/descomentar seleccion" })

-- ─── Buffers ────────────────────────────────────────────────────────────────
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Nuevo buffer" })
map("n", "<leader>bd", "<cmd>bdelete!<CR>", { desc = "Eliminar buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Cerrar otros buffers" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bf", function()
  Snacks.picker.buffers({ layout = "ivy" })
end, { desc = "Buscar buffers" })

-- ─── Tabs ───────────────────────────────────────────────────────────────────
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Nueva tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Cerrar tab" })
map("n", "<leader>t]", "<cmd>tabn<CR>", { desc = "Tab siguiente" })
map("n", "<leader>t[", "<cmd>tabp<CR>", { desc = "Tab anterior" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Cerrar otras tabs" })

-- ─── Ventanas ───────────────────────────────────────────────────────────────
map("n", "<leader>wv", "<C-w>v", { desc = "Division vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Division horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Igualar tamaño" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Cerrar ventana" })
map("n", "<leader>wo", "<C-w>o", { desc = "Cerrar otras ventanas" })

-- ─── Ortografia ─────────────────────────────────────────────────────────────
map("n", "<leader>zp", "<cmd>set spell!<CR>", { desc = "Alternar correccion ortografica" })
map("n", "<leader>zs", "z=", { desc = "Ver sugerencias" })
map("n", "<leader>za", "zg", { desc = "Agregar al diccionario" })

-- ─── Git ─────────────────────────────────────────────────────────────────────
map("n", "]g", function() MiniDiff.goto_hunk("next") end, { desc = "Siguiente hunk" })
map("n", "[g", function() MiniDiff.goto_hunk("prev") end, { desc = "Anterior hunk" })
map("n", "<leader>go", function() MiniDiff.toggle_overlay() end, { desc = "Alternar diff en linea" })
map("n", "<leader>gh", function() MiniDiff.do_hunks(0, "reset") end, { desc = "Resetear hunk" })
map("n", "<leader>ga", function() MiniDiff.do_hunks(0, "apply") end, { desc = "Aplicar hunk" })
map("n", "<leader>gy", function() MiniDiff.do_hunks(0, "yank") end, { desc = "Copiar hunk" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Log de git" })
map("n", "<leader>gL", function() Snacks.picker.git_log_file() end, { desc = "Log de git (archivo)" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Estado de git" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Diff de git" })
map("n", "<leader>gb", function() Snacks.git_blame_line() end, { desc = "Blame de linea" })

-- ─── Quickfix / Loclist ─────────────────────────────────────────────────────
local function toggle_win(type)
  for _, win in ipairs(vim.fn.getwininfo()) do
    if type == "c" and win.quickfix == 1 and win.loclist == 0 then
      vim.cmd("cclose")
      return
    elseif type == "l" and win.loclist == 1 then
      vim.cmd("lclose")
      return
    end
  end
  vim.cmd(type == "c" and "copen" or "lopen")
end

map("n", "<leader>ll", function() vim.diagnostic.setloclist() end,  { desc = "Diagnosticos buffer -> loclist" })
map("n", "<leader>lq", function() vim.diagnostic.setqflist() end,   { desc = "Diagnosticos proyecto -> quickfix" })
map("n", "<leader>lc", function() toggle_win("c") end,              { desc = "Alternar quickfix" })
map("n", "<leader>lL", function() toggle_win("l") end,              { desc = "Alternar loclist" })

-- ─── Diagnósticos ────────────────────────────────────────────────────────────
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Diagnostico anterior" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,  { desc = "Diagnostico siguiente" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true }) end, { desc = "Error anterior" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true }) end,  { desc = "Error siguiente" })
