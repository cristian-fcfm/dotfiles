return {
  "akinsho/bufferline.nvim",
  event = "BufEnter",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    require("bufferline").setup({
      options = {
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = nil,
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 10,
        diagnostics = false,
        custom_filter = function(bufnr)
          -- Filtrar buffers que no queremos mostrar
          local exclude_ft = { "qf", "fugitive", "git", "alpha" }
          local cur_ft = vim.bo[bufnr].filetype
          local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

          if should_filter then
            return false
          end

          return true
        end,
        show_buffer_icons = true, -- Mostrar iconos de archivos
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin", -- 'slant', 'slope', 'thick', 'thin', 'bar'
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "id",
        offsets = {
          {
            filetype = "oil",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
      },
    })
  end,
}
