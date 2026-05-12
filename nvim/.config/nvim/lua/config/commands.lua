--- Exporta el buffer actual (markdown) a PDF usando pandoc.
--- Ejecuta la conversion de forma asincrona y notifica el resultado.
--- Requiere: pandoc + motor LaTeX instalado.
--- Uso: :MarkdownExportPDF
vim.api.nvim_create_user_command("MarkdownExportPDF", function()
  local current_file = vim.fn.shellescape(vim.fn.expand("%:p"))
  local output_file = vim.fn.shellescape(vim.fn.expand("%:p:r") .. ".pdf")
  local cmd = string.format("pandoc %s -o %s", current_file, output_file)

  vim.notify("Exportando a PDF...", vim.log.levels.INFO)
  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("PDF creado: " .. output_file, vim.log.levels.INFO)
      else
        vim.notify("Error al exportar PDF. Asegúrate de tener instalado un motor LaTeX", vim.log.levels.ERROR)
      end
    end,
  })
end, { desc = "Exportar markdown a PDF con pandoc" })

--- Descarga los diccionarios de spell para los idiomas configurados en `spelllang`.
--- Los archivos .spl se guardan en `stdpath("data")/site/spell/`.
--- Omite idiomas que ya tienen diccionario descargado.
--- Uso: :SpellDownload
vim.api.nvim_create_user_command("SpellDownload", function()
  local langs = vim.opt.spelllang:get()
  local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
  vim.fn.mkdir(spell_dir, "p")

  for _, lang in ipairs(langs) do
    local spell_file = spell_dir .. "/" .. lang .. ".utf-8.spl"
    if vim.fn.filereadable(spell_file) == 1 then
      vim.notify("Diccionario '" .. lang .. "' ya existe, omitiendo...", vim.log.levels.INFO)
    else
      local url = "https://ftp.nluug.nl/vim/runtime/spell/" .. lang .. ".utf-8.spl"
      vim.notify("Descargando diccionario '" .. lang .. "'...", vim.log.levels.INFO)
      local result = vim.fn.system({ "curl", "-fLo", spell_file, "--create-dirs", url })
      if vim.v.shell_error == 0 then
        vim.notify("Diccionario '" .. lang .. "' descargado correctamente", vim.log.levels.INFO)
      else
        vim.notify("Error al descargar diccionario '" .. lang .. "': " .. result, vim.log.levels.ERROR)
      end
    end
  end
end, { desc = "Descargar diccionarios de spell según spelllang" })
