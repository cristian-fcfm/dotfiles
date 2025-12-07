return {
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    ft = { "markdown", "html", "svg" },
    config = function()
      require("livepreview").setup({})
    end,
  },
}
