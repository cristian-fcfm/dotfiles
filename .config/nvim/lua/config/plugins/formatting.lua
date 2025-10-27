return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      local utils = require("utils")

      -- Configura formatters dinámicamente según disponibilidad
      local formatters_by_ft = {}

      -- Python - solo si ruff está disponible
      if utils.executable("ruff") then
        formatters_by_ft.python = { "ruff_format", "ruff_organize_imports" }
      end

      -- JSON/YAML/Markdown - solo si prettier está disponible
      if utils.executable("prettier") then
        formatters_by_ft.json = { "prettier" }
        formatters_by_ft.yaml = { "prettier" }
        formatters_by_ft.markdown = { "prettier" }
      end

      -- Bash - solo si shfmt está disponible
      if utils.executable("shfmt") then
        formatters_by_ft.bash = { "shfmt" }
        formatters_by_ft.sh = { "shfmt" }
      end

      -- Lua - solo si stylua está disponible
      if utils.executable("stylua") then
        formatters_by_ft.lua = { "stylua" }
      end

      require("conform").setup({
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 2000,
          lsp_format = "fallback",
        },
        formatters = {
          shfmt = {
            prepend_args = { "-i", "2" },
          },
          ruff_format = {
            command = "ruff",
            args = { "format", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
          },
          ruff_organize_imports = {
            command = "ruff",
            args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
          },
        },
      })
    end,
  },
}
