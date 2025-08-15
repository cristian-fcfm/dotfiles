return {
  'folke/todo-comments.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('todo-comments').setup({
      signs = true,      -- Mostrar iconos en la columna de signos
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
        test = { "Identifier", "#FF006E" }
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

      -- Configuración de highlights
      highlight = {
        multiline = true,                -- Habilitar highlight multilínea
        multiline_pattern = "^.",        -- Patrón para líneas multilínea
        multiline_context = 10,          -- Contexto para multilínea
        before = "",                     -- Highlight antes de la palabra clave
        keyword = "wide",                -- Estilo del highlight: "fg", "bg", "wide", "wide_bg", "wide_fg"
        after = "fg",                    -- Highlight después de la palabra clave
        pattern = [[.*<(KEYWORDS)\s*:]], -- Patrón para vim regex
        comments_only = true,            -- Solo en comentarios
        max_line_len = 400,              -- Máxima longitud de línea
        exclude = {},                    -- Tipos de archivo excluidos
      },
    })
  end,

}
