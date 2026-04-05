vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  once = true,
  callback = function()
    vim.pack.add({
      { src = "https://github.com/kaarmu/typst.vim" },
      { src = "https://github.com/chomosuke/typst-preview.nvim", version = vim.version.range("1.x") },
    })

    vim.g.typst_auto_compile = 0
    vim.g.typst_conceal = 1
    vim.g.typst_pdf_viewer = "zathura"

    require("typst-preview").setup({})

    local wk = require("which-key")
    wk.add({
      { "<leader>l", group = "Typst", icon = "󰬛" },
      { "<leader>lp", "<cmd>TypstPreview<CR>", desc = "[P]review en navegador", icon = "󰈟" },
      { "<leader>ls", "<cmd>TypstPreviewStop<CR>", desc = "[S]top preview", icon = "󰓛" },
      { "<leader>lu", "<cmd>TypstPreviewUpdate<CR>", desc = "[U]pdate plugin", icon = "󰚰" },
      { "<leader>lc", "<cmd>!typst compile %<CR>", desc = "[C]ompilar a PDF", icon = "󰈚" },
      { "<leader>lw", "<cmd>!typst watch %<CR>", desc = "[W]atch mode", icon = "󰁯" },
      {
        "<leader>lo", function()
          local pdf = vim.fn.expand("%:r") .. ".pdf"
          vim.fn.system(string.format("%s %s &", vim.g.typst_pdf_viewer or "zathura", pdf))
        end, desc = "[O]pen PDF viewer", icon = "󰈥",
      },
    })
  end,
})
