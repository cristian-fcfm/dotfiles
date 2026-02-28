-- bullets.vim: Auto-continuación inteligente de listas en Markdown
-- Soporta listas numeradas, checkboxes, y listas anidadas
return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "zk", "text" },
  init = function()
    -- Filetypes donde bullets.vim estará activo
    vim.g.bullets_enabled_file_types = { "markdown", "zk", "text" }

    -- Desactivar en filetypes no deseados
    vim.g.bullets_enable_in_empty_buffers = 0

    -- Mapeos habilitados
    vim.g.bullets_set_mappings = 1

    -- Soporte para checkboxes con marcadores personalizados
    vim.g.bullets_checkbox_markers = " .oOx"

    -- Renumerar al cambiar listas
    vim.g.bullets_renumber_on_change = 1

    -- No agregar padding extra después del marcador
    vim.g.bullets_pad_right = 0

    -- Outline levels para listas anidadas
    vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
  end,
}
