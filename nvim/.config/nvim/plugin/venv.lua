-- =============================================================================
-- Configuracion venv-selector (Python virtualenvs)
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/linux-cultist/venv-selector.nvim", name = "venv-selector.nvim" },
    })

    require("venv-selector").setup({
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    })

    vim.keymap.set("n", "<leader>pv", "<cmd>VenvSelect<CR>", { desc = "Seleccionar virtualenv" })
  end,
})
