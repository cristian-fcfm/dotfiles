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

    -- NOTA: Blink.cmp tiene auto_brackets integrado (completion.accept.auto_brackets)
    -- No requiere integración adicional con nvim-autopairs
  end,
}
