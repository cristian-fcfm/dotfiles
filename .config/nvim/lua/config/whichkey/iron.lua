local wk = require('which-key')

wk.add({
  -- Grupo REPL
  { '<space>r', group = 'REPL', icon = '' },
  { '<space>rr', '<cmd>IronRepl<cr>', desc = 'Abrir REPL', icon = '' },
  { '<space>rf', '<cmd>IronFocus<cr>', desc = 'Foco REPL', icon = '' },
  { '<space>rh', '<cmd>IronHide<cr>', desc = 'Ocultar REPL', icon = '󰗼' },
  { '<space>rR', desc = 'Reiniciar REPL', icon = '󰑓' },
  { '<space>ri', desc = 'Interrumpir REPL', icon = '' },
  { '<space>rq', desc = 'Salir REPL', icon = '󰗼' },
  { '<space>rc', desc = 'Limpiar REPL', icon = '󰅚' },

  -- Grupo Enviar (simplificado a <space>s)
  { '<space>s', group = 'Enviar a REPL', icon = '' },
  { '<space>sl', desc = 'Enviar línea', icon = '' },
  { '<space>sp', desc = 'Enviar párrafo', icon = '󰈔' },
  { '<space>sf', desc = 'Enviar archivo', icon = '󰈙' },
  { '<space>sb', desc = 'Enviar bloque de código', icon = '󰆼' },
  { '<space>sn', desc = 'Enviar bloque y mover', icon = '󰆼' },
  { '<space>sc', desc = 'Enviar selección/movimiento', icon = '' },
  { '<space>su', desc = 'Enviar hasta cursor', icon = '󰇘' },
  { '<space>s<cr>', desc = 'Enviar <CR>', icon = '↵' },

  -- Grupo Marcas (simplificado a <space>m)
  { '<space>m', group = 'Marcas REPL', icon = '󰃀' },
  { '<space>mm', desc = 'Marcar movimiento/visual', icon = '󰃀' },
  { '<space>md', desc = 'Eliminar marca', icon = '󰆴' },
  { '<space>ms', desc = 'Enviar marca', icon = '󰃀' },
})
