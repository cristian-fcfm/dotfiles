return {
  "kosayoda/nvim-lightbulb",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    priority = 10,
    hide_in_unfocused_buffer = true,
    link_highlights = true,
    validate_config = "auto",
    action_kinds = nil,
    sign = {
      enabled = true,
      text = "",
      hl = "DiagnosticSignWarn",
    },
    virtual_text = {
      enabled = false,
      text = "",
      hl = "DiagnosticVirtualTextWarn",
    },
    float = {
      enabled = false,
      text = "",
      hl = "DiagnosticFloatingWarn",
      win_opts = {
        border = "single",
      },
    },
    status_text = {
      enabled = false,
      text = "",
      text_unavailable = "",
    },
    number = {
      enabled = false,
    },
    line = {
      enabled = false,
    },
    autocmd = {
      enabled = true,
      updatetime = 200,
      events = { "CursorHold", "CursorHoldI" },
      pattern = { "*" },
    },
    ignore = {
      clients = {},
      ft = { "alpha", "oil" },
      actions_without_kind = false,
    },
    ---@diagnostic disable-next-line: unused-local
    filter = function(client_name, result)
      -- Ruff siempre envía estas acciones incluso si no hay nada que hacer
      -- https://github.com/astral-sh/ruff-lsp/issues/91
      local ignored_kinds = {
        "source.fixAll.ruff",
        "source.organizeImports.ruff",
      }

      if result.kind and vim.tbl_contains(ignored_kinds, result.kind) then
        return false
      end

      return true
    end,
  },
}
