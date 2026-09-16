-- ============================================================================
-- Autocommands
-- ============================================================================

local api = vim.api

-- Resaltar brevemente el texto copiado (yank)
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", { clear = true }),
  desc = "Resaltar texto copiado brevemente",
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Auto-crear directorios al guardar archivos
api.nvim_create_autocmd("BufWritePre", {
  group = api.nvim_create_augroup("auto_create_dir", { clear = true }),
  desc = "Crear directorios automáticamente si no existen",
  callback = function(ctx)
    if vim.bo[ctx.buf].buftype ~= "" then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(ctx.file, ":p:h"), "p")
  end,
})

local auto_read = api.nvim_create_augroup("auto_read", { clear = true })

-- Auto-reload archivos cambiados externamente
api.nvim_create_autocmd("FocusGained", {
  group = auto_read,
  desc = "Recargar archivos si cambiaron externamente",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

api.nvim_create_autocmd("FileChangedShellPost", {
  group = auto_read,
  desc = "Notificar cambio de archivo en disco",
  callback = function()
    vim.notify("Archivo cambió en disco. Buffer recargado!", vim.log.levels.WARN)
  end,
})

-- Toggle números relativos y cursorcolumn
local insert_ui_toggle = api.nvim_create_augroup("insert_ui_toggle", { clear = true })

api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = insert_ui_toggle,
  desc = "Desactivar números relativos fuera del foco",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})

api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = insert_ui_toggle,
  desc = "Activar números relativos en la ventana enfocada",
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

api.nvim_create_autocmd("InsertEnter", {
  group = insert_ui_toggle,
  desc = "Activar cursorcolumn en modo insert",
  callback = function()
    vim.wo.cursorcolumn = true
  end,
})

api.nvim_create_autocmd("InsertLeave", {
  group = insert_ui_toggle,
  desc = "Desactivar cursorcolumn al salir de modo insert",
  callback = function()
    vim.wo.cursorcolumn = false
  end,
})

api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("writing_filetypes", { clear = true }),
  pattern = { "markdown", "typst" },
  desc = "Activar spell e indentación de 2 espacios en filetypes de escritura",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("format_options", { clear = true }),
  desc = "Desactivar auto-wrap de texto",
  callback = function()
    vim.opt_local.formatoptions:remove("t")
  end,
})
