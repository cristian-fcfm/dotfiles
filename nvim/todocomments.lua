vim.schedule(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    { src = "https://github.com/folke/todo-comments.nvim", version = vim.version.range("*") },
  })

  require("todo-comments").setup({
    signs = true,
    sign_priority = 8,
    keywords = {
      FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = "󰋖", color = "hint", alt = { "INFO" } },
      TEST = { icon = "󰙨", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF006E" },
    },
    search = {
      command = "rg",
      args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
      pattern = [[\b(KEYWORDS):]],
    },
    highlight = {
      multiline = false,
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 250,
      exclude = {},
    },
  })

  local function insert_todo_comment(keyword)
    local commentstring = vim.bo.commentstring
    if commentstring == "" then commentstring = "# %s" end
    local comment = commentstring:format(keyword .. ": ")
    local line = vim.api.nvim_get_current_line()
    local indent = line:match("^%s*")
    vim.api.nvim_set_current_line(indent .. comment)
    vim.cmd("startinsert!")
  end

  vim.api.nvim_create_user_command("InsertTodo", function() insert_todo_comment("TODO") end, { desc = "Insert TODO comment" })
  vim.api.nvim_create_user_command("InsertFixme", function() insert_todo_comment("FIXME") end, { desc = "Insert FIXME comment" })
  vim.api.nvim_create_user_command("InsertNote", function() insert_todo_comment("NOTE") end, { desc = "Insert NOTE comment" })
  vim.api.nvim_create_user_command("InsertHack", function() insert_todo_comment("HACK") end, { desc = "Insert HACK comment" })

  local wk = require("which-key")
  wk.add({
    { "<leader>T", group = "TODO", icon = "" },
    { "<leader>Ts", function() Snacks.picker.grep({ search = "TODO|FIXME|HACK|WARN|PERF|NOTE|TEST" }) end, desc = "Search TODOs", icon = "󱎸" },
    { "<leader>Tl", "<cmd>TodoLocList<cr>", desc = "TODOs in location list", icon = "" },
    { "<leader>Tq", "<cmd>TodoQuickFix<cr>", desc = "TODOs in quickfix", icon = "󱃕" },
    { "<leader>Ti", group = "Insert TODO", icon = "" },
    { "<leader>Tit", "<cmd>InsertTodo<cr>", desc = "Insert TODO", icon = "" },
    { "<leader>Tif", "<cmd>InsertFixme<cr>", desc = "Insert FIXME", icon = "󰁨" },
    { "<leader>Tin", "<cmd>InsertNote<cr>", desc = "Insert NOTE", icon = "" },
    { "<leader>Tih", "<cmd>InsertHack<cr>", desc = "Insert HACK", icon = "" },
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO (any)" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO (any)" },
    { "]T", function() require("todo-comments").jump_next({ keywords = { "TODO" } }) end, desc = "Next TODO" },
    { "[T", function() require("todo-comments").jump_prev({ keywords = { "TODO" } }) end, desc = "Previous TODO" },
    { "]x", function() require("todo-comments").jump_next({ keywords = { "FIX", "FIXME", "BUG" } }) end, desc = "Next FIXME/BUG" },
    { "[x", function() require("todo-comments").jump_prev({ keywords = { "FIX", "FIXME", "BUG" } }) end, desc = "Previous FIXME/BUG" },
    { "]n", function() require("todo-comments").jump_next({ keywords = { "NOTE" } }) end, desc = "Next NOTE" },
    { "[n", function() require("todo-comments").jump_prev({ keywords = { "NOTE" } }) end, desc = "Previous NOTE" },
    { "]h", function() require("todo-comments").jump_next({ keywords = { "HACK" } }) end, desc = "Next HACK" },
    { "[h", function() require("todo-comments").jump_prev({ keywords = { "HACK" } }) end, desc = "Previous HACK" },
  })
end)
