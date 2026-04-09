-- =============================================================================
-- Configuracion Blink (completado)
-- =============================================================================
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/saghen/blink.cmp" },
    })

    -- ===========================================================================
    -- Setup
    -- ===========================================================================
    require("blink.cmp").setup({
      appearance = { use_nvim_cmp_as_default = false },
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
        default = { "lsp", "path", "buffer" },
        providers = { buffer = { min_keyword_length = 4 } },
      },
      cmdline = { enabled = true },
      fuzzy = {
        implementation = "lua",
      },
    })
  end,
})
