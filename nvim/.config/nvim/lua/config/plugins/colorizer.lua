return {
  "NvChad/nvim-colorizer.lua",
  -- Cargar solo en filetypes donde se necesita (evita cargar para todos los buffers)
  ft = {
    "css",
    "scss",
    "less",
    "html",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "lua",
    "vim",
    "conf",
    "toml",
  },
  opts = {
    filetypes = { "*" }, -- Aplicar a todos los filetypes cargados (ya filtrado por ft= arriba)
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      names = true, -- "Name" codes like Blue or red
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = true, -- 0xAARRGGBB hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      mode = "background", -- Set the display mode: "foreground", "background", "virtualtext"
      tailwind = true, -- Enable tailwind colors
      sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
      virtualtext = "■",
      always_update = false,
    },
    -- Buffers específicos para excluir
    buftypes = {},
  },
}
