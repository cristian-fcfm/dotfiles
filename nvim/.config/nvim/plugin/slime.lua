-- ============================================================================
-- Configuracion Slime (REPL via Kitty)
-- ============================================================================
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
    vim.g.slime_bracketed_paste = 1
    vim.g.slime_no_mappings = 0

    vim.g.slime_default_config = {
      listen_on = vim.env.KITTY_LISTEN_ON or "unix:/tmp/mykitty",
      window_id = nil,
    }

    -- ===========================================================================
    -- Keymaps
    -- ===========================================================================
    local map = vim.keymap.set

    map("n", "<leader>sc", "<Plug>SlimeSendCell", { desc = "Enviar celda" })
    map("n", "<leader>ss", "<Plug>SlimeParagraphSend", { desc = "Enviar parrafo" })
    map("x", "<leader>ss", "<Plug>SlimeRegionSend", { desc = "Enviar seleccion" })
    map("n", "<leader>sl", "<Plug>SlimeLineSend", { desc = "Enviar linea" })
    map("n", "<leader>sj", "<Plug>SlimeCellsNext", { desc = "Celda siguiente" })
    map("n", "<leader>sk", "<Plug>SlimeCellsPrev", { desc = "Celda anterior" })
    map("n", "<leader>sC", "<Plug>SlimeCellsSendAndGoToNext", { desc = "Enviar celda e ir a siguiente" })
    map("n", "<leader>sd", "o# %%<Esc>", { desc = "Insertar divisor de celda" })
    map("n", "<leader>sv", "<Plug>SlimeConfig", { desc = "Configurar destino" })
  end,
})
