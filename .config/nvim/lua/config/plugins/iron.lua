return {
  'hkupty/iron.nvim',
  config = function()
    local iron = require('iron.core')
    local common = require('iron.fts.common')
    local view = require('iron.view')

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { 'ipython', '--no-autoindent' },
            format = common.bracketed_paste_python,
            block_dividers = { '# %%', '#%%' },
          },
        },
        -- Ventana flotante en lugar de división lateral
        repl_open_cmd = view.center({
          width = 80,
          height = 20,
          winfixwidth = false,
          winfixheight = false,
        }),
        send_chunk = true,
      },
      keymaps = {
        -- REPL actions
        restart_repl = '<space>rR',
        interrupt = '<space>ri',
        exit = '<space>rq',
        clear = '<space>rc',

        -- Send actions (simplificado a <space>s)
        send_motion = '<space>sc',
        visual_send = '<space>sc',
        send_file = '<space>sf',
        send_line = '<space>sl',
        send_paragraph = '<space>sp',
        send_until_cursor = '<space>su',
        send_code_block = '<space>sb',
        send_code_block_and_move = '<space>sn',
        cr = '<space>s<cr>',

        -- Mark actions (simplificado a <space>m)
        send_mark = '<space>ms',
        mark_motion = '<space>mm',
        mark_visual = '<space>mm',
        remove_mark = '<space>md',
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })
  end,
}
