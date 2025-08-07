return {
  'jpalardy/vim-slime',
  event = 'VeryLazy',
  config = function()
    -- Configurar vim-slime para usar tmux
    vim.g.slime_target = 'tmux'
    vim.g.slime_default_config = {
      socket_name = 'default',
      target_pane = '{last}'
    }

    -- Configuración específica para Python/IPython
    vim.g.slime_python_ipython = 1
    vim.g.slime_cell_delimiter = '# %%'

    -- No preguntar por la configuración cada vez
    vim.g.slime_dont_ask_default = 1

    -- Preservar posición del cursor
    vim.g.slime_preserve_curpos = 1

    -- Usar paste bracketed para mejor manejo de código
    vim.g.slime_bracketed_paste = 1

    -- Configuración avanzada para tmux
    vim.g.slime_no_mappings = 0
  end,
}
