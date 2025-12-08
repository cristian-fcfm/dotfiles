return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  opts = {
    file_types = { "markdown" },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
  },
}
