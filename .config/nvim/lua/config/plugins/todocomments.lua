return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("todo-comments").setup({
    signs = true, -- Mostrar iconos en la columna de signos
    sign_priority = 8, -- Prioridad de los signos

    -- Palabras clave personalizadas
    keywords = {
      FIX = {
        icon = " ", -- Icono que aparecerá en la columna de signos
        color = "error", -- Color del highlight
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- Palabras alternativas
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = "󰋖", color = "hint", alt = { "INFO" } },
      TEST = { icon = "󰙨", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },

    -- Esquema de colores personalizado
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF006E" },
    },

    -- Configuración de búsqueda
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]], -- Patrón ripgrep
    },

    -- Configuración de highlights optimizada
    highlight = {
      multiline = false, -- Desactivar para mejor performance
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 250, -- Reducido para mejor performance
      exclude = {},
    },
    })

    -- Crear comandos para insertar TODOs
    local function insert_todo_comment(keyword)
      local commentstring = vim.bo.commentstring
      if commentstring == "" then
        commentstring = "# %s"
      end

      local comment = commentstring:format(keyword .. ": ")
      local line = vim.api.nvim_get_current_line()
      local indent = line:match("^%s*")

      vim.api.nvim_set_current_line(indent .. comment)
      vim.cmd("startinsert!")
    end

    vim.api.nvim_create_user_command("InsertTodo", function()
      insert_todo_comment("TODO")
    end, { desc = "Insert TODO comment" })

    vim.api.nvim_create_user_command("InsertFixme", function()
      insert_todo_comment("FIXME")
    end, { desc = "Insert FIXME comment" })

    vim.api.nvim_create_user_command("InsertNote", function()
      insert_todo_comment("NOTE")
    end, { desc = "Insert NOTE comment" })

    vim.api.nvim_create_user_command("InsertHack", function()
      insert_todo_comment("HACK")
    end, { desc = "Insert HACK comment" })
  end,
}
