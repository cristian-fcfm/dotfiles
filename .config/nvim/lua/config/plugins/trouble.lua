return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = { "<leader>x" },
  opts = {
    auto_close = false,
    win = {
      size = {
        height = 0.3, -- Altura para ventanas en la parte inferior
        width = 0.35, -- Ancho para ventanas a la derecha
      },
    },
    modes = {
      preview_float = {
        mode = "diagnostics",
        preview = {
          type = "float",
          relative = "editor",
          border = "rounded",
          title = "Preview",
          title_pos = "center",
          position = { 0, -2 },
          size = { width = 0.35, height = 0.3 },
          zindex = 200,
        },
      },
    },
  },
}
