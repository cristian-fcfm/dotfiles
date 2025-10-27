return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "echasnovski/mini.icons" },
  cond = function()
    local utils = require("utils")
    return utils.executable("fzf")
  end,
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      "default-title",
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.50,
        border = "single",
        preview = {
          scrollbar = "float",
          scrollchars = { "┃", "" },
        },
      },
      fzf_opts = {
        ["--layout"] = "reverse",
        ["--info"] = "inline",
        ["--cycle"] = true,
      },
      keymap = {
        builtin = {
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      files = {
        git_icons = true,
        file_icons = true,
        color_icons = true,
        find_opts = [[-type f -not -path '*/\.git/*' -not -path '*/.venv/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!.venv'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude .venv",
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096",
        RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
      },
      oldfiles = {
        include_current_session = true,
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB limit for syntax highlighting
          ueberzug_scaler = "fit_contain",
          extensions = {
            ["png"] = { "kitty" },
            ["jpg"] = { "kitty" },
            ["jpeg"] = { "kitty" },
            ["gif"] = { "kitty" },
            ["webp"] = { "kitty" },
          },
        },
      },
    })
  end,
}
