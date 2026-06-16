-- ============================================================================
-- Configuracion Typst
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/kaarmu/typst.vim" },
      { src = "https://github.com/chomosuke/typst-preview.nvim" },
    })

    -- ===========================================================================
    -- Setup
    -- ===========================================================================
    vim.g.typst_auto_compile = 0
    vim.g.typst_conceal = 1

    require("typst-preview").setup({})

    -- ===========================================================================
    -- Comandos
    -- ===========================================================================
    vim.api.nvim_buf_create_user_command(0, "TypstCompile", function()
      local file = vim.fn.expand("%")
      vim.cmd("write")
      vim.fn.system({ "typst", "compile", file })
      vim.notify("Compilado: " .. vim.fn.expand("%:r") .. ".pdf", vim.log.levels.INFO)
    end, { desc = "Compilar Typst a PDF" })
  end,
})
