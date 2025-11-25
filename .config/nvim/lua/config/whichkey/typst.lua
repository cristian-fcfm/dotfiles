local wk = require("which-key")

wk.add({
  { "<leader>l", group = "Typst", icon = "󰬛" },

  -- Preview
  {
    "<leader>lp",
    "<cmd>TypstPreview<CR>",
    desc = "[P]review en navegador",
    icon = "󰈟",
  },
  {
    "<leader>ls",
    "<cmd>TypstPreviewStop<CR>",
    desc = "[S]top preview",
    icon = "󰓛",
  },
  {
    "<leader>lu",
    "<cmd>TypstPreviewUpdate<CR>",
    desc = "[U]pdate plugin",
    icon = "󰚰",
  },

  -- Compilación
  {
    "<leader>lc",
    "<cmd>!typst compile %<CR>",
    desc = "[C]ompilar a PDF",
    icon = "󰈚",
  },
  {
    "<leader>lw",
    "<cmd>!typst watch %<CR>",
    desc = "[W]atch mode",
    icon = "󰁯",
  },
  {
    "<leader>lo",
    function()
      local pdf = vim.fn.expand("%:r") .. ".pdf"
      vim.fn.system(string.format("%s %s &", vim.g.typst_pdf_viewer or "zathura", pdf))
    end,
    desc = "[O]pen PDF viewer",
    icon = "󰈥",
  },
})
