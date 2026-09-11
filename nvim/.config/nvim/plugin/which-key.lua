-- ============================================================================
-- Configuracion Which Key (Ayuda contextual de atajos)
-- ============================================================================
vim.pack.add({
  "https://github.com/folke/which-key.nvim",
})

local wk = require("which-key")

wk.setup({
  preset = "modern",
  delay = 300,
  win = {
    border = "rounded",
  },
  icons = {
    mappings = false,
  },
  spec = {
    { "<leader>b", group = "buffers" },
    { "<leader>d", group = "debug" },
    { "<leader>f", group = "buscar" },
    { "<leader>g", group = "git" },
    { "<leader>l", group = "linea/diagnosticos" },
    { "<leader>q", group = "sesiones" },
    { "<leader>r", group = "tests" },
    { "<leader>s", group = "slime/repl" },
    { "<leader>t", group = "tabs" },
    { "<leader>w", group = "ventanas" },
    { "<leader>z", group = "ortografia" },
  },
})
