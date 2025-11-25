-- Plugin para soporte de Typst (sistema de composición tipográfica moderno)
return {
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    config = function()
      -- Configuración de compilación automática (desactivada por defecto)
      vim.g.typst_auto_compile = 0

      -- Configurar conceal para mejorar visualización
      vim.g.typst_conceal = 1

      -- PDF viewer (puedes cambiarlo según tu preferencia)
      vim.g.typst_pdf_viewer = "zathura"
    end,
  },

  -- Preview en navegador
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    version = "1.*",
    build = function()
      require("typst-preview").update()
    end,
    opts = {},
  },
}
