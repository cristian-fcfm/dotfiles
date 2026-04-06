-- =============================================================================
-- Linting con nvim-lint
-- =============================================================================
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

  if utils.executable("ruff") then
    linters_by_ft.python = { "ruff" }
  end

  if utils.executable("shellcheck") then
    linters_by_ft.sh = { "shellcheck" }
    linters_by_ft.bash = { "shellcheck" }
  end

  if utils.executable("yamllint") then
    linters_by_ft.yaml = { "yamllint" }
  end

  if utils.executable("markdownlint") then
    linters_by_ft.markdown = { "markdownlint" }
    linters_by_ft.zk = { "markdownlint" }
  end

  if utils.executable("hadolint") then
    linters_by_ft.dockerfile = { "hadolint" }
  end

  if utils.executable("selene") then
    linters_by_ft.lua = { "selene" }
  elseif utils.executable("luacheck") then
    linters_by_ft.lua = { "luacheck" }
  end

  if utils.executable("zig") then
    linters_by_ft.zig = { "zlint" }
  end

  if utils.executable("stylelint") then
    linters_by_ft.css = { "stylelint" }
    linters_by_ft.scss = { "stylelint" }
    linters_by_ft.less = { "stylelint" }
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
