return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    stages = "fade_in_slide_out",
    timeout = 1500,
    max_width = 80,
    max_height = 10,
    render = "compact",
    background_colour = "#000000",
    fps = 60,
    level = vim.log.levels.INFO,
    minimum_width = 80,
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { border = "single" })
    end,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}
