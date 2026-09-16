local utils = require("utils")

--- Exporta el buffer actual (markdown) a PDF usando pandoc con typst como motor.
--- Ejecuta la conversion de forma asincrona y notifica el resultado.
--- Requiere: pandoc + typst instalados.
--- Uso: :MarkdownExportPDF
vim.api.nvim_create_user_command("MarkdownExportPDF", function()
  if not utils.executable("pandoc") then
    vim.notify("pandoc no está instalado", vim.log.levels.ERROR)
    return
  end

  local source = vim.api.nvim_buf_get_name(0)
  if source == "" then
    vim.notify("El buffer no tiene fichero: guárdalo antes de exportar", vim.log.levels.ERROR)
    return
  end
  if vim.bo.modified then
    vim.notify("Guarda el buffer: pandoc leería la versión en disco", vim.log.levels.ERROR)
    return
  end

  local output = vim.fn.fnamemodify(source, ":r") .. ".pdf"

  vim.notify("Exportando a PDF...", vim.log.levels.INFO)
  vim.system({ "pandoc", source, "--pdf-engine=typst", "-o", output }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("PDF creado: " .. output, vim.log.levels.INFO)
        return
      end

      local detail = vim.trim(result.stderr or "")
      if detail == "" then
        detail = "pandoc terminó con código " .. result.code
      elseif #detail > 300 then
        detail = detail:sub(1, 300) .. "…"
      end
      vim.notify("Error al exportar PDF:\n" .. detail, vim.log.levels.ERROR)
    end)
  end)
end, { desc = "Exportar markdown a PDF con pandoc" })
