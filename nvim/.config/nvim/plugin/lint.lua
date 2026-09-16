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

  local linters_by_ft = {
    python     = { "ruff" },
    sh         = { "shellcheck" },
    bash       = { "shellcheck" },
    yaml       = { "yamllint" },
    markdown   = { "markdownlint-cli2" },
    dockerfile = { "hadolint" },
    css        = { "stylelint" },
    scss       = { "stylelint" },
    less       = { "stylelint" },
    zig        = { "zlint" },
  }

  -- Lua: preferir selene, fallback a luacheck
  if utils.executable("selene") then
    linters_by_ft.lua = { "selene" }
  elseif utils.executable("luacheck") then
    linters_by_ft.lua = { "luacheck" }
  end

  lint.linters_by_ft = linters_by_ft

  --- Devuelve los linters de un filetype que tienen su binario en PATH.
  --- @param filetype string
  --- @return string[] Vacio si no hay ninguno ejecutable
  local function available_linters(filetype)
    local names = lint.linters_by_ft[filetype]
    if not names then
      return {}
    end

    return vim.tbl_filter(function(name)
      local ok, linter = pcall(function()
        return lint.linters[name]
      end)
      local cmd = ok and type(linter) == "table" and linter.cmd or nil
      if type(cmd) == "function" then
        local resolved, value = pcall(cmd)
        cmd = resolved and value or nil
      end
      return type(cmd) == "string" and utils.executable(cmd)
    end, names)
  end

  -- ===========================================================================
  -- Autocmd y comandos de usuario
  -- ===========================================================================
  local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = lint_augroup,
    desc = "Ejecutar linting automatico",
    callback = function()
      local linters = available_linters(vim.bo.filetype)
      if #linters > 0 then
        lint.try_lint(linters)
      end
    end,
  })

  vim.api.nvim_create_user_command("Lint", function()
    lint.try_lint()
  end, { desc = "Ejecutar linting manualmente" })
end)
