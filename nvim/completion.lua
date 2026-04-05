vim.api.nvim_create_autocmd("InsertEnter", { once = true, callback = function()
  vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets",
    { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
  })

  local luasnip = require("luasnip")
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

  luasnip.config.setup({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
  })

  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
  end, { silent = true, desc = "LuaSnip: Expand or jump forward" })

  vim.keymap.set({ "i", "s" }, "<C-h>", function()
    if luasnip.jumpable(-1) then luasnip.jump(-1) end
  end, { silent = true, desc = "LuaSnip: Jump backward" })

  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if luasnip.choice_active() then luasnip.change_choice(1) end
  end, { silent = true, desc = "LuaSnip: Change choice" })

  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono", use_nvim_cmp_as_default = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind" } } },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      list = { selection = { preselect = true, auto_insert = false } },
    },
    signature = { enabled = true, window = { border = "single" } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = { buffer = { min_keyword_length = 4 } },
    },
    snippets = { preset = "luasnip" },
    cmdline = { enabled = true },
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = { download = true, force_version = nil },
    },
  })
end })
