return {
  -- zk-nvim: note-taking with zk
  {
    "zk-org/zk-nvim",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkMatch", "ZkCd" },
    ft = "zk",
    config = function()
      require("zk").setup({
        picker = "snacks_picker",
        picker_options = {
          layout = {
            preset = "ivy",
          },
        },
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "zk" },
          },
        },
      })
    end,
  },
}
