return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Usa una versión estable para evitar breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    ft = { "python", "julia", "r", "markdown", "quarto" }, -- Ajusta según tus lenguajes
    init = function()
      -- Configuración global para molten
      vim.g.molten_image_provider = "image.nvim" -- Usa image.nvim para mostrar imágenes
      vim.g.molten_output_win_max_height = 20    -- Altura máxima de la ventana de output
      vim.g.molten_auto_open_output = true       -- Abre automáticamente el output al ejecutar
    end,
    config = function()
      -- Keymaps útiles para trabajar con molten
      vim.keymap.set("n", "<leader>mi", "<cmd>MoltenInit<cr>", { desc = "Molten: Init kernel" })
      vim.keymap.set("n", "<leader>mr", "<cmd>MoltenEvaluateOperator<cr>", { desc = "Molten: Eval operator" })
      vim.keymap.set("n", "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", { desc = "Molten: Eval line" })
      vim.keymap.set("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>", { desc = "Molten: Eval visual" })
      vim.keymap.set("n", "<leader>mo", "<cmd>MoltenShowOutput<cr>", { desc = "Molten: Show output" })
      vim.keymap.set("n", "<leader>mx", "<cmd>MoltenRestart<cr>", { desc = "Molten: Restart kernel" })
    end,
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Cambia según tu terminal: kitty, ueberzug, viu, etc.
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- Oculta imágenes si hay ventanas superpuestas
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
    config = function(_, opts)
      require("image").setup(opts)
    end,
  },
}
