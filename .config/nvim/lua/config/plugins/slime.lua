return {
  'jpalardy/vim-slime',
  event = 'VeryLazy',
  config = function()
    -- Configurar vim-slime para usar Kitty
    vim.g.slime_target = 'kitty'
    vim.g.slime_default_config = {
      window_id = 'neighbors',
      listen_on = nil,
    }

    -- Configuración específica para Python/IPython
    vim.g.slime_python_ipython = 1
    vim.g.slime_cell_delimiter = '# %%'

    -- No preguntar por la ventana cada vez
    vim.g.slime_dont_ask_default = 1

    -- Preservar indentación
    vim.g.slime_preserve_curpos = 1

    -- Usar paste bracketed para mejor manejo de código
    vim.g.slime_bracketed_paste = 1

    -- Keybindings personalizados
    local opts = { noremap = true, silent = true }

    -- Atajos adicionales más intuitivos
    vim.keymap.set('n', '<leader>sc', '<Plug>SlimeSendCell', { desc = 'Send cell to REPL' })
    vim.keymap.set('n', '<leader>ss', '<Plug>SlimeParagraphSend', { desc = 'Send paragraph to REPL' })
    vim.keymap.set('x', '<leader>ss', '<Plug>SlimeRegionSend', { desc = 'Send selection to REPL' })
    vim.keymap.set('n', '<leader>sl', '<Plug>SlimeLineSend', { desc = 'Send line to REPL' })
    vim.keymap.set('n', '<leader>sr', ':SlimeSend1 %reset -f<CR>', { desc = 'Reset IPython' })
    vim.keymap.set('n', '<leader>si', ':SlimeSend1 whos<CR>', { desc = 'Show variables' })

    -- Función para enviar comandos custom
    vim.keymap.set('n', '<leader>s:', ':SlimeSend1 ', { desc = 'Send custom command' })

    -- Navegación entre celdas
    vim.keymap.set('n', ']c', '/# %%<CR>:nohlsearch<CR>', { desc = 'Next cell' })
    vim.keymap.set('n', '[c', '?# %%<CR>:nohlsearch<CR>', { desc = 'Previous cell' })

    -- Enviar celda y avanzar a la siguiente
    vim.keymap.set('n', '<leader>sn', function()
      vim.cmd('normal <Plug>SlimeSendCell')
      vim.cmd('normal /# %%<CR>:nohlsearch<CR>')
    end, { desc = 'Send cell and go to next' })
  end,
}
