local wk = require("which-key")

wk.add({
  { "<leader>t", group = "TODO", icon = "" },

  -- Búsqueda de TODOs
  { "<leader>ts", "<cmd>TodoFzfLua<cr>", desc = "Search TODOs", icon = "󱎸" },
  { "<leader>tl", "<cmd>TodoLocList<cr>", desc = "TODOs in location list", icon = "" },
  { "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "TODOs in quickfix", icon = "󱃕" },

  -- Insertar TODOs rápidamente
  { "<leader>ti", group = "Insert TODO", icon = "" },
  { "<leader>tit", "<cmd>InsertTodo<cr>", desc = "Insert TODO", icon = "" },
  { "<leader>tif", "<cmd>InsertFixme<cr>", desc = "Insert FIXME", icon = "󰁨" },
  { "<leader>tin", "<cmd>InsertNote<cr>", desc = "Insert NOTE", icon = "" },
  { "<leader>tih", "<cmd>InsertHack<cr>", desc = "Insert HACK", icon = "" },

  -- Navegación rápida con atajos cortos (estilo treesitter)
  -- Todos los TODOs (cualquier tipo)
  {
    "]t",
    function()
      require("todo-comments").jump_next()
    end,
    desc = "Next TODO (any)",
  },
  {
    "[t",
    function()
      require("todo-comments").jump_prev()
    end,
    desc = "Previous TODO (any)",
  },

  -- TODOs específicos
  {
    "]T",
    function()
      require("todo-comments").jump_next({ keywords = { "TODO" } })
    end,
    desc = "Next TODO",
  },
  {
    "[T",
    function()
      require("todo-comments").jump_prev({ keywords = { "TODO" } })
    end,
    desc = "Previous TODO",
  },

  -- FIXME/BUG (usando ]x / [x para evitar conflicto con ]f de funciones)
  {
    "]x",
    function()
      require("todo-comments").jump_next({ keywords = { "FIX", "FIXME", "BUG" } })
    end,
    desc = "Next FIXME/BUG",
  },
  {
    "[x",
    function()
      require("todo-comments").jump_prev({ keywords = { "FIX", "FIXME", "BUG" } })
    end,
    desc = "Previous FIXME/BUG",
  },

  -- NOTE
  {
    "]n",
    function()
      require("todo-comments").jump_next({ keywords = { "NOTE" } })
    end,
    desc = "Next NOTE",
  },
  {
    "[n",
    function()
      require("todo-comments").jump_prev({ keywords = { "NOTE" } })
    end,
    desc = "Previous NOTE",
  },

  -- HACK
  {
    "]h",
    function()
      require("todo-comments").jump_next({ keywords = { "HACK" } })
    end,
    desc = "Next HACK",
  },
  {
    "[h",
    function()
      require("todo-comments").jump_prev({ keywords = { "HACK" } })
    end,
    desc = "Previous HACK",
  },
})
