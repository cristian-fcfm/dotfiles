return {
  "lewis6991/gitsigns.nvim",
  event = { "User InGitRepo" },
  config = function()
    local gs = require("gitsigns")

    gs.setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        changedelete = { text = "│" },
      },
      attach_to_untracked = true,
      current_line_blame = true,
      preview_config = {
        border = "single",
      },
    })

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.cmd([[
          hi GitSignsChangeInline gui=reverse
          hi GitSignsAddInline gui=reverse
          hi GitSignsDeleteInline gui=reverse
        ]])
      end,
    })
  end,
}
