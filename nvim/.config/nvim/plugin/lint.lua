-- ============================================================================
-- Linting con nvim-lint
-- ============================================================================
vim.schedule(function()
  vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint" },
  })

  -- ===========================================================================
  -- Linters por tipo de archivo
  -- ===========================================================================
  local lint = require("lint")
  local utils = require("utils")
  local linters_by_ft = {}

  utils.set_if_executable(linters_by_ft, "python", "ruff")
  utils.set_if_executable(linters_by_ft, "sh",     "shellcheck")
  utils.set_if_executable(linters_by_ft, "bash",   "shellcheck")
  utils.set_if_executable(linters_by_ft, "yaml",   "yamllint")
  utils.set_if_executable(linters_by_ft, "markdown", "markdownlint")
  utils.set_if_executable(linters_by_ft, "zk",     "markdownlint")
  utils.set_if_executable(linters_by_ft, "dockerfile", "hadolint")
  utils.set_if_executable(linters_by_ft, "css",    "stylelint")
  utils.set_if_executable(linters_by_ft, "scss",   "stylelint")
  utils.set_if_executable(linters_by_ft, "less",   "stylelint")

  -- Lua: preferir selene, fallback a luacheck
  if utils.executable("selene") then
    linters_by_ft.lua = { "selene" }
  elseif utils.executable("luacheck") then
    linters_by_ft.lua = { "luacheck" }
  end

  -- Zig usa zlint (incluido con zls)
  if utils.executable("zig") then
    linters_by_ft.zig = { "zlint" }
  end

  lint.linters_by_ft = linters_by_ft

  -- ===========================================================================
  -- Autocmd y comandos de usuario
  -- ===========================================================================
  local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = lint_augroup,
    desc = "Ejecutar linting automatico",
    callback = function()
      if lint.linters_by_ft[vim.bo.filetype] then
        lint.try_lint()
      end
    end,
  })

  vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
  end, { desc = "Ejecutar linting manualmente" })
end)
