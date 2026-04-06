-- =============================================================================
-- Configuracion Gitsigns
-- =============================================================================
vim.api.nvim_create_autocmd("User", {
  pattern = "InGitRepo",
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/lewis6991/gitsigns.nvim" },
    })

    local gs = require("gitsigns")

    -- ===========================================================================
    -- Setup
    -- ===========================================================================
    gs.setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        changedelete = { text = "│" },
      },
      attach_to_untracked = true,
      current_line_blame = true,
      preview_config = { border = "single" },
    })

    -- ===========================================================================
    -- Highlights inline para diffs
    -- ===========================================================================
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

    -- ===========================================================================
    -- Keymaps
    -- ===========================================================================
    local map = vim.keymap.set

    map("n", "<leader>hp", function()
      gs.nav_hunk("prev")
    end, { desc = "Previous hunk" })
    map("n", "<leader>hn", function()
      gs.nav_hunk("next")
    end, { desc = "Next hunk" })
    map("n", "<leader>hb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame hunk" })
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage selection" })
    map("v", "<leader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset selection" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff against index" })
    map("n", "<leader>hD", function()
      gs.diffthis("~")
    end, { desc = "Diff against last commit" })
    map("n", "<leader>hq", gs.setqflist, { desc = "Hunks to quickfix" })
    map("n", "<leader>hQ", function()
      gs.setqflist("all")
    end, { desc = "All hunks to quickfix" })

    map("n", "]g", function()
      gs.nav_hunk("next")
    end, { desc = "Next git hunk" })
    map("n", "[g", function()
      gs.nav_hunk("prev")
    end, { desc = "Previous git hunk" })

    map("n", "<leader>gtb", function()
      gs.toggle_current_line_blame()
    end, { desc = "Toggle Blame" })
    map("n", "<leader>gtn", function()
      gs.toggle_numhl()
    end, { desc = "Toggle Number Highlight" })
    map("n", "<leader>gtl", function()
      gs.toggle_linehl()
    end, { desc = "Toggle Line Highlight" })
    map("n", "<leader>gts", function()
      gs.toggle_signs()
    end, { desc = "Toggle Signs" })
    map("n", "<leader>gtd", function()
      gs.toggle_deleted()
    end, { desc = "Toggle Deleted" })
  end,
})
