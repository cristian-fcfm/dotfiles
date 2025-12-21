local api = vim.api
local utils = require("utils")

-- Resaltar brevemente el texto copiado (yank)
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", { clear = true }),
  desc = "Resaltar texto copiado brevemente",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Auto-crear directorios al guardar archivos
api.nvim_create_autocmd("BufWritePre", {
  group = api.nvim_create_augroup("auto_create_dir", { clear = true }),
  desc = "Crear directorios automáticamente si no existen",
  callback = function(ctx)
    -- Ignorar buffers de Oil
    if vim.bo[ctx.buf].filetype == "oil" then
      return
    end
    local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
    utils.may_create_dir(dir)
  end,
})

-- Auto-reload archivos cambiados externamente
api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
  group = api.nvim_create_augroup("auto_read", { clear = true }),
  desc = "Recargar archivos si cambiaron externamente",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- Notificar cuando un archivo cambió en disco
api.nvim_create_autocmd("FileChangedShellPost", {
  group = "auto_read",
  desc = "Notificar cambio de archivo en disco",
  callback = function()
    vim.notify("Archivo cambió en disco. Buffer recargado!", vim.log.levels.WARN)
  end,
})

-- Configuración para buffers de terminal
api.nvim_create_autocmd("TermOpen", {
  group = api.nvim_create_augroup("term_settings", { clear = true }),
  desc = "Configuración para terminal integrado",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

-- Toggle números relativos inteligente
local number_toggle = api.nvim_create_augroup("number_toggle", { clear = true })

api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = number_toggle,
  desc = "Desactivar números relativos en insert mode o al salir de ventana",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = number_toggle,
  desc = "Activar números relativos en normal mode",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

-- Toggle cursorcolumn en insert mode
local cursorcolumn_toggle = api.nvim_create_augroup("cursorcolumn_toggle", { clear = true })

api.nvim_create_autocmd("InsertEnter", {
  group = cursorcolumn_toggle,
  desc = "Activar cursorcolumn en insert mode",
  callback = function()
    vim.wo.cursorcolumn = true
  end,
})

api.nvim_create_autocmd("InsertLeave", {
  group = cursorcolumn_toggle,
  desc = "Desactivar cursorcolumn al salir de insert mode",
  callback = function()
    vim.wo.cursorcolumn = false
  end,
})

-- Advertir si el archivo no está en UTF-8
api.nvim_create_autocmd("BufRead", {
  group = api.nvim_create_augroup("non_utf8_file", { clear = true }),
  desc = "Advertir si el archivo no está en UTF-8",
  callback = function()
    local exclude_ft = { "oil", "snacks_dashboard" }
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) and vim.bo.fileencoding ~= "utf-8" then
      vim.notify("Archivo no está en UTF-8: " .. vim.bo.fileencoding, vim.log.levels.WARN)
    end
  end,
})

-- Activar spell check para Markdown y Typst
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("markdown_spell", { clear = true }),
  desc = "Activar corrección ortográfica en Markdown y Typst",
  pattern = { "markdown", "typst" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
