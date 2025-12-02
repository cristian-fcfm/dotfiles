return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local utils = require("utils")

    -- Configurar linters dinámicamente según disponibilidad
    -- Nota: Los linters se instalan automáticamente vía mason-tool-installer (ver lsp.lua)
    local linters_by_ft = {}

    -- Python - ruff para linting rápido
    if utils.executable("ruff") then
      linters_by_ft.python = { "ruff" }
    end

    -- Bash/Shell - shellcheck es el estándar
    if utils.executable("shellcheck") then
      linters_by_ft.sh = { "shellcheck" }
      linters_by_ft.bash = { "shellcheck" }
    end

    -- YAML - yamllint para validación
    if utils.executable("yamllint") then
      linters_by_ft.yaml = { "yamllint" }
    end

    -- Markdown - markdownlint para estilo
    if utils.executable("markdownlint") then
      linters_by_ft.markdown = { "markdownlint" }
    end

    -- Docker - hadolint para mejores prácticas
    if utils.executable("hadolint") then
      linters_by_ft.dockerfile = { "hadolint" }
    end

    -- Lua - selene (más moderno) o luacheck
    if utils.executable("selene") then
      linters_by_ft.lua = { "selene" }
    elseif utils.executable("luacheck") then
      linters_by_ft.lua = { "luacheck" }
    end

    -- Rust - clippy para linting (requiere rustup)
    if utils.executable("cargo") then
      linters_by_ft.rust = { "clippy" }
    end

    lint.linters_by_ft = linters_by_ft

    -- Autocommands para ejecutar linting
    local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = lint_augroup,
      desc = "Ejecutar linting automático",
      callback = function()
        -- Solo ejecutar si hay linters configurados para este filetype
        if lint.linters_by_ft[vim.bo.filetype] then
          lint.try_lint()
        end
      end,
    })

    -- Comando manual para ejecutar linting
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Ejecutar linting manualmente" })
  end,
}
