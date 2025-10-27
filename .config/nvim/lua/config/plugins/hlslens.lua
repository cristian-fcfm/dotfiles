return {
  "kevinhwang91/nvim-hlslens",
  keys = { "/", "?", "n", "N", "*", "#", "g*", "g#" },
  config = function()
    local hlslens = require("hlslens")

    hlslens.setup({
      calm_down = true,
      nearest_only = true,
      nearest_float_when = "always",
    })

    local activate_hlslens = function(direction)
      local cmd = string.format("normal! %s%szzzv", vim.v.count1, direction)
      local status, msg = pcall(vim.cmd, cmd)

      if not status then
        local start_idx = string.find(msg, "E486", 1, true)
        if start_idx then
          local msg_part = string.sub(msg, start_idx)
          vim.api.nvim_echo({ { msg_part, "ErrorMsg" } }, true, {})
        end
        return
      end

      hlslens.start()
    end

    local check_cursor_word = function()
      local cursor_word = vim.fn.expand("<cword>")
      if cursor_word == "" then
        vim.api.nvim_echo({ { "E348: No string under cursor", "ErrorMsg" } }, true, {})
        return true, nil
      end
      return false, cursor_word
    end

    local search_word = function(direction)
      local cursor_word_empty, cursor_word = check_cursor_word()
      if cursor_word_empty then
        return
      end

      local search_char = direction == "forward" and "/" or "?"
      local cmd = string.format([[normal! %s\v<%s>]], search_char, cursor_word)
      local escaped_enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      local full_cmd = cmd .. escaped_enter .. "N"

      vim.fn.execute(full_cmd)
      hlslens.start()
    end

    -- Navegación básica
    vim.keymap.set("n", "n", function()
      activate_hlslens("n")
    end, { desc = "Next search result" })

    vim.keymap.set("n", "N", function()
      activate_hlslens("N")
    end, { desc = "Previous search result" })

    -- Búsqueda de palabra bajo cursor
    vim.keymap.set("n", "*", function()
      search_word("forward")
    end, { desc = "Search word under cursor forward" })

    vim.keymap.set("n", "#", function()
      search_word("backward")
    end, { desc = "Search word under cursor backward" })

    vim.keymap.set("n", "g*", function()
      local cursor_word_empty, cursor_word = check_cursor_word()
      if cursor_word_empty then
        return
      end
      local cmd = string.format([[normal! /\v%s]], cursor_word)
      local escaped_enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      vim.fn.execute(cmd .. escaped_enter .. "N")
      hlslens.start()
    end, { desc = "Search word under cursor (no boundary)" })

    vim.keymap.set("n", "g#", function()
      local cursor_word_empty, cursor_word = check_cursor_word()
      if cursor_word_empty then
        return
      end
      local cmd = string.format([[normal! ?\v%s]], cursor_word)
      local escaped_enter = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      vim.fn.execute(cmd .. escaped_enter .. "N")
      hlslens.start()
    end, { desc = "Search word under cursor backward (no boundary)" })

    -- Auto-start hlslens cuando inicias búsqueda con / o ?
    vim.api.nvim_create_autocmd("CmdlineEnter", {
      pattern = { "/", "?" },
      callback = function()
        vim.opt.hlsearch = true
      end,
    })

    vim.api.nvim_create_autocmd("CmdlineLeave", {
      pattern = { "/", "?" },
      callback = function()
        hlslens.start()
      end,
    })
  end,
}
