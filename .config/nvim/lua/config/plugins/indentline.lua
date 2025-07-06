return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "󰇙",
        highlight = {
          "IblIndent1",
          "IblIndent2",
          "IblIndent3",
          "IblIndent4",
          "IblIndent5",
          "IblIndent6",
        },
      },
      scope = { enabled = true },
      whitespace = { remove_blankline_trail = true },
      exclude = {
        filetypes = { "help", "dashboard", "NvimTree", "Trouble", "lazy" },
        buftypes = { "terminal", "nofile" },
      },
    },
    config = function(_, opts)
      -- Define los highlights ANTES del setup
      vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#3b4252" })
      vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#4c566a" })
      vim.api.nvim_set_hl(0, "IblIndent3", { fg = "#5e81ac" })
      vim.api.nvim_set_hl(0, "IblIndent4", { fg = "#81a1c1" })
      vim.api.nvim_set_hl(0, "IblIndent5", { fg = "#88c0d0" })
      vim.api.nvim_set_hl(0, "IblIndent6", { fg = "#e5e9f0" })
      vim.api.nvim_set_hl(0, "IblScope",   { fg = "#8fbcbb" })

      require("ibl").setup(opts)
    end,
  },
}
