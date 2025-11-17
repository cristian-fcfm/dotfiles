return {
  -- zk-nvim: note-taking with zk
  {
    "zk-org/zk-nvim",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkMatch" },
    ft = "zk",
    config = function()
      require("zk").setup({
        picker = "fzf_lua",
      })
    end,
  },

  -- Markdown preview and rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "zk" },
    opts = {
      file_types = { "markdown", "zk" },
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
  },
}
