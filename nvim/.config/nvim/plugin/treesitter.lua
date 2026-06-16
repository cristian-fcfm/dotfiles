-- ============================================================================
-- Parsers a instalar
-- ============================================================================
local parsers = {
  "lua", "python", "javascript", "typescript", "bash", "json", "yaml",
  "markdown", "markdown_inline", "html", "css",
  "dockerfile", "sql", "toml", "zig", "typst",
  "vim", "vimdoc", "query", "regex",
}

-- ============================================================================
-- Hook de actualizacion al cambiar paquetes
-- ============================================================================
vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
  if ev.data.spec.name == "nvim-treesitter" and ev.data.kind ~= "delete" then
    if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
    vim.cmd("TSUpdate")
  end
end })

-- ============================================================================
-- Instalacion y configuracion de Treesitter
-- ============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
  })

  vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-treesitter/runtime")

  require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  vim.schedule(function()
    require("nvim-treesitter").install(parsers)
  end)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(args)
      local ok = pcall(vim.treesitter.start, args.buf)
      if ok then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].foldmethod = "expr"
        vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[win].foldlevel = 99
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
    callback = function(args)
      local ok = pcall(vim.treesitter.get_parser, args.buf)
      if ok then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end)
