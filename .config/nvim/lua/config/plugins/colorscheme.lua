-- Plugin del tema Tokyonight
return {
  'folke/tokyonight.nvim',
  priority = 1000,                    -- Se carga primero para que el tema se aplique antes que otros plugins
  config = function()
    vim.cmd.colorscheme('tokyonight') -- Aplica el tema Tokyonight
  end,
}
