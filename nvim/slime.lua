vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "julia", "r", "lua", "javascript", "typescript", "sh", "bash", "sql" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/jpalardy/vim-slime" },
      { src = "https://github.com/klafyvel/vim-slime-cells" },
    })

    vim.g.slime_target = "kitty"
    vim.g.slime_python_ipython = 1
    vim.g.slime_cell_delimiter = "# %%"
    vim.g.slime_dont_ask_default = 1
    vim.g.slime_preserve_curpos = 1
    vim.g.slime_bracketed_paste = 0
    vim.g.slime_no_mappings = 0

    local function get_kitty_socket()
      local handle = io.popen("ls -t /tmp/mykitty-* 2>/dev/null | head -1")
      if handle then
        local socket = handle:read("*a"):gsub("\n", "")
        handle:close()
        if socket ~= "" then return "unix:" .. socket end
      end
      return "unix:/tmp/mykitty"
    end

    vim.g.slime_default_config = {
      listen_on = get_kitty_socket(),
      window_id = nil,
    }

    vim.g.slime_cells_highlight = 1
    vim.api.nvim_set_hl(0, "SlimeCellsHeader", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "SlimeCellsCurrent", { bg = "#313244" })

    local wk = require("which-key")
    wk.add({
      { "<leader>s", group = "Slime REPL", icon = "󰞷" },
      { "<leader>sc", "<Plug>SlimeSendCell", desc = "Send cell", icon = "󱐪" },
      { "<leader>ss", "<Plug>SlimeParagraphSend", desc = "Send paragraph", icon = "", mode = "n" },
      { "<leader>ss", "<Plug>SlimeRegionSend", desc = "Send selection", icon = "󰩬", mode = "x" },
      { "<leader>sl", "<Plug>SlimeLineSend", desc = "Send line", icon = "󰘤" },
      { "<leader>sf", "ggVG<Plug>SlimeRegionSend", desc = "Send entire file", icon = "󰈙" },
      { "<leader>sj", "<Plug>SlimeCellsNext", desc = "Next cell", icon = "󰒭" },
      { "<leader>sk", "<Plug>SlimeCellsPrev", desc = "Previous cell", icon = "󰒮" },
      { "<leader>sC", "<Plug>SlimeCellsSendAndGoToNext", desc = "Send cell & go next", icon = "󰮰" },
      { "<leader>sd", "o# %%<Esc>", desc = "Insert cell divider", icon = "󱞣" },
      { "<leader>sr", ":SlimeSend1 %reset -f<CR>", desc = "Reset IPython", icon = "󰑓" },
      { "<leader>si", ":SlimeSend1 whos<CR>", desc = "Show variables", icon = "󰋽" },
      { "<leader>sm", ":SlimeSend1 %matplotlib inline<CR>", desc = "Enable matplotlib", icon = "" },
      { "<leader>sp", ":SlimeSend1 %pwd<CR>", desc = "Show current dir", icon = "󰉋" },
      { "<leader>s:", ":SlimeSend1 ", desc = "Send command...", icon = "󰞷" },
      { "<leader>sv", "<Plug>SlimeConfig", desc = "Configure target", icon = "" },
    })
  end,
})
