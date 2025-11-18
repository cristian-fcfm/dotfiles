return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      check_ts = true, -- Usa treesitter para mejor detección de contexto
      ts_config = {
        lua = { "string" }, -- No autopair en strings de lua
        javascript = { "template_string" },
        python = { "string" },
      },
      disable_filetype = { "TelescopePrompt", "vim", "fzf" },
      fast_wrap = {
        map = "<M-e>", -- Alt+e para envolver rápido
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    })

    -- Integración con blink.cmp
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("blink.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
  dependencies = {
    "saghen/blink.cmp",
  },
}
