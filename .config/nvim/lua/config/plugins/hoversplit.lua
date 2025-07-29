return {
  'roobert/hoversplit.nvim',
  event = 'VeryLazy',
  config = function()
    require('hoversplit').setup({
      key_bindings = {
        split_remain_focused = '<leader>hs',
        vsplit_remain_focused = '<leader>hv',
        split = '<leader>hS',
        vsplit = '<leader>hV',
      },
      -- Configuraciones para controlar el tamaño del hover
      auto_split = {
        enable = true,
        split_command = 'split',
        vsplit_command = 'vsplit',
      },
      -- Configurar el tamaño de las ventanas divididas
      split_options = {
        split_height = 15, -- Altura para split horizontal
        vsplit_width = 80, -- Ancho para split vertical
      },
    })
  end,
}
