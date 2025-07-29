return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      -- Padding around the floating window
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
  config = function(_, opts)
    require('oil').setup(opts)

    -- Atajos de teclado
    vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open Oil (normal)' })
    vim.keymap.set('n', '--', '<cmd>Oil --float<cr>', { desc = 'Open Oil (float)' })
  end
}
