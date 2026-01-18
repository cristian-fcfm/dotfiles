-- Plugin para resaltado de sintaxis avanzado y otras mejoras de edición
-- NOTA: Esta configuración es para la rama main de nvim-treesitter (requiere Neovim 0.11+)

-- Lista de parsers a instalar automáticamente
local parsers = {
  -- Común
  "lua",
  "python",
  "javascript",
  "typescript",
  "bash",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "html",
  "css",
  -- DevOps
  "dockerfile",
  "terraform",
  "hcl",
  "nix",
  -- Data
  "sql",
  "graphql",
  "toml",
  -- Rust
  "rust",
  -- Typst
  "typst",
  -- Diagramas
  "d2",
  -- Neovim config
  "vim",
  "vimdoc",
  "query",
  "regex",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Setup básico (opcional, usa valores por defecto)
      require("nvim-treesitter").setup({
        -- Directorio de instalación (por defecto: stdpath('data')/site)
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- Instalar parsers de forma asíncrona
      vim.schedule(function()
        require("nvim-treesitter").install(parsers)
      end)

      -- Habilitar highlight con treesitter para los filetypes soportados
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        callback = function(args)
          -- Intenta habilitar treesitter highlight si hay un parser disponible
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            -- Si treesitter está activo, habilitar folds basados en treesitter
            local win = vim.api.nvim_get_current_win()
            vim.wo[win].foldmethod = "expr"
            vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[win].foldlevel = 99 -- Empezar con todos los folds abiertos
          end
        end,
      })

      -- Habilitar indentación con treesitter (experimental)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
        callback = function(args)
          -- Solo habilitar para filetypes con parser
          local ok = pcall(vim.treesitter.get_parser, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
