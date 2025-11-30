return {
  -- Live preview para Markdown, HTML, AsciiDoc, SVG
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "ibhagwan/fzf-lua", -- Usa fzf-lua como picker
    },
    ft = { "markdown", "html", "asciidoc", "svg" }, -- Lazy load por tipo de archivo
    config = function()
      require("livepreview").setup({
        -- Configuración por defecto
      })
    end,
  },
}
