-- =============================================================================
-- Configuracion Smart Splits (navegacion Neovim <-> Kitty)
-- =============================================================================

-- ===========================================================================
-- Kitty integration helpers
-- ===========================================================================
local function is_smart_splits_spec(spec)
  if not spec then
    return false
  end

  if spec.name == "smart-splits.nvim" then
    return true
  end

  return type(spec.src) == "string" and spec.src:match("smart%-splits%.nvim/?$") ~= nil
end

local function smart_splits_plugin_dir()
  local runtime_file = vim.api.nvim_get_runtime_file("lua/smart-splits/init.lua", false)[1]
  if not runtime_file then
    return nil
  end

  return vim.fn.fnamemodify(runtime_file, ":h:h:h")
end

local function install_kitty_kittens()
  local plugin_dir = smart_splits_plugin_dir()
  if not plugin_dir then
    return
  end

  local kitty_dir = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/kitty"
  local src_file = plugin_dir .. "/kitty/neighboring_window.py"
  local dst_file = kitty_dir .. "/neighboring_window.py"
  local src_stat = vim.uv.fs_stat(src_file)
  local dst_stat = vim.uv.fs_stat(dst_file)

  if not src_stat then
    return
  end

  if dst_stat and dst_stat.mtime.sec >= src_stat.mtime.sec then
    return
  end

  vim.fn.mkdir(kitty_dir, "p")
  vim.fn.system({
    "bash",
    "-c",
    "cd " .. vim.fn.shellescape(plugin_dir) .. " && bash kitty/install-kittens.bash",
  })
end

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if not is_smart_splits_spec(ev.data.spec) or ev.data.kind == "delete" then
      return
    end

    if not ev.data.active then
      vim.cmd.packadd("smart-splits.nvim")
    end

    install_kitty_kittens()
  end,
})

vim.pack.add({
  { src = "https://github.com/mrjones2014/smart-splits.nvim" },
})

-- ===========================================================================
-- Setup
-- ===========================================================================
local ss = require("smart-splits")

install_kitty_kittens()

ss.setup({
  multiplexer_integration = "kitty",
  at_edge = "stop",
  disable_multiplexer_nav_when_zoomed = true,
})

-- ===========================================================================
-- Keymaps
-- ===========================================================================
local map = vim.keymap.set

-- Navegacion entre splits (Ctrl+HJKL, seamless con Kitty)
map("n", "<C-h>", ss.move_cursor_left, { desc = "Ir al split izquierdo" })
map("n", "<C-j>", ss.move_cursor_down, { desc = "Ir al split inferior" })
map("n", "<C-k>", ss.move_cursor_up, { desc = "Ir al split superior" })
map("n", "<C-l>", ss.move_cursor_right, { desc = "Ir al split derecho" })
