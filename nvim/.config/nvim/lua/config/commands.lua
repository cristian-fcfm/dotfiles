vim.api.nvim_create_user_command("MarkdownExportPDF", function()
  local current_file = vim.fn.expand("%:p")
  local output_file = vim.fn.expand("%:p:r") .. ".pdf"
  local cmd = string.format("pandoc '%s' -o '%s'", current_file, output_file)

  vim.notify("Exportando a PDF...", vim.log.levels.INFO)
  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("PDF creado: " .. output_file, vim.log.levels.INFO)
      else
        vim.notify("Error al exportar PDF. Asegúrate de tener instalado un motor LaTeX (brew install basictex)", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Exportar markdown a PDF con pandoc" })
