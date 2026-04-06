-- =============================================================================
-- Configuracion Slime (REPL via Kitty)
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "julia", "r", "lua", "javascript", "typescript", "sh", "bash", "sql" },
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/jpalardy/vim-slime" },
      { src = "https://github.com/klafyvel/vim-slime-cells" },
    })

    -- ===========================================================================
    -- Setup
    -- ===========================================================================
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
        if socket ~= "" then
          return "unix:" .. socket
        end
      end
      return "unix:/tmp/mykitty"
    end

    vim.g.slime_default_config = {
      listen_on = get_kitty_socket(),
      window_id = nil,
    }

    -- ===========================================================================
    -- Keymaps
    -- ===========================================================================
    local map = vim.keymap.set

    map("n", "<leader>sc", "<Plug>SlimeSendCell", { desc = "Send cell" })
    map("n", "<leader>ss", "<Plug>SlimeParagraphSend", { desc = "Send paragraph" })
    map("x", "<leader>ss", "<Plug>SlimeRegionSend", { desc = "Send selection" })
    map("n", "<leader>sl", "<Plug>SlimeLineSend", { desc = "Send line" })
    map("n", "<leader>sj", "<Plug>SlimeCellsNext", { desc = "Next cell" })
    map("n", "<leader>sk", "<Plug>SlimeCellsPrev", { desc = "Previous cell" })
    map("n", "<leader>sC", "<Plug>SlimeCellsSendAndGoToNext", { desc = "Send cell & go next" })
    map("n", "<leader>sd", "o# %%<Esc>", { desc = "Insert cell divider" })
    map("n", "<leader>sv", "<Plug>SlimeConfig", { desc = "Configure target" })
  end,
})
