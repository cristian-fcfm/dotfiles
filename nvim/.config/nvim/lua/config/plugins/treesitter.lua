-- Plugin para resaltado de sintaxis avanzado y otras mejoras de edición
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    init = function()
      -- Lista de lenguajes soportados
      local supported_langs = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "markdown",
        "markdown_inline",
        "norg",
        "python",
        "query",
        "regex",
        "sql",
        "toml",
        "typst",
        "vim",
        "xml",
        "yaml",
      }

      -- Auto-habilitar treesitter para tipos de archivo soportados
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreeSitterAutoEnable", { clear = true }),
        desc = "Auto enable treesitter for supported filetype",
        pattern = supported_langs,
        callback = function(args)
          -- Habilitar treesitter highlighting
          vim.treesitter.start(args.buf, args.match)

          -- Configurar indentación con treesitter
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Configurar folding con treesitter
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldenable = false -- No cerrar folds por defecto
        end,
      })
    end,
  },

  -- Parser de D2 para treesitter
  {
    "ravsii/tree-sitter-d2",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*",
    build = "make nvim-install",
    ft = { "d2" },
  },
}
