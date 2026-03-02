return {
  -- Smart-splits: Seamless navigation between Neovim and Kitty splits
  -- Ctrl+HJKL moves across both Neovim and Kitty panes (boundary-aware)
  -- Also provides cross-mux resize with Alt+HJKL
  {
    "mrjones2014/smart-splits.nvim",
    -- Must NOT be lazy loaded: sets IS_NVIM user variable for Kitty detection
    lazy = false,
    build = "./kitty/install-kittens.bash",
    config = function()
      require("smart-splits").setup({
        multiplexer_integration = "kitty",
        at_edge = "stop",
        -- When zoomed in Kitty (stack layout), don't navigate to other panes
        disable_multiplexer_nav_when_zoomed = true,
      })

      local ss = require("smart-splits")

      -- Seamless split navigation: Neovim <-> Kitty (Ctrl+HJKL)
      vim.keymap.set("n", "<C-h>", ss.move_cursor_left, { desc = "Move to left split" })
      vim.keymap.set("n", "<C-j>", ss.move_cursor_down, { desc = "Move to below split" })
      vim.keymap.set("n", "<C-k>", ss.move_cursor_up, { desc = "Move to above split" })
      vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Move to right split" })

      -- Swap buffers between splits (Leader+Leader+HJKL)
      vim.keymap.set("n", "<leader><leader>h", ss.swap_buf_left, { desc = "Swap buffer left" })
      vim.keymap.set("n", "<leader><leader>j", ss.swap_buf_down, { desc = "Swap buffer down" })
      vim.keymap.set("n", "<leader><leader>k", ss.swap_buf_up, { desc = "Swap buffer up" })
      vim.keymap.set("n", "<leader><leader>l", ss.swap_buf_right, { desc = "Swap buffer right" })
    end,
  },
}
