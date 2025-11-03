-- Plugin del tema Tokyonight
return {
  "folke/tokyonight.nvim",
  priority = 1000, -- Se carga primero para que el tema se aplique antes que otros plugins
  config = function()
    require("tokyonight").setup({
      style = "night",
      on_highlights = function(hl, c)
        hl.LineNr = { fg = c.purple, bg = c.bg_gutter }
        hl.LineNrAbove = { fg = c.purple, bg = c.bg_gutter }
        hl.LineNrBelow = { fg = c.purple, bg = c.bg_gutter }
        hl.CursorLineNr = { fg = "#ff9e64", bold = true, bg = c.bg_gutter }
      end,
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
