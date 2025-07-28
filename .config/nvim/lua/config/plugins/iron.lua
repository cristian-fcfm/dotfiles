return {
  'hkupty/iron.nvim',
  config = function()
    local iron = require('iron.core')
    local common = require('iron.fts.common')

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          python = {
            command = { 'ipython', '--no-autoindent' },
            format = common.bracketed_paste_python,
            block_dividers = { '# %%', '#%%' },
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = require('iron.view').right(60),
        send_chunk = true,
      },
      keymaps = {
        restart_repl = '<space>rR',
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sf',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_mark = '<space>sm',
        send_code_block = '<space>sb',
        send_code_block_and_move = '<space>sn',
        mark_motion = '<space>mc',
        mark_visual = '<space>mc',
        remove_mark = '<space>md',
        cr = '<space>s<cr>',
        interrupt = '<space>s<space>',
        exit = '<space>sq',
        clear = '<space>cl',
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
    vim.keymap.set('n', '<space>rF', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
  end,
}
