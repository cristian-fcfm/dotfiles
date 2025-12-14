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

-- Redimensionar ventanas automáticamente al cambiar tamaño del terminal
api.nvim_create_autocmd("VimResized", {
  group = api.nvim_create_augroup("win_autoresize", { clear = true }),
  desc = "Redimensionar ventanas automáticamente",
  command = "wincmd =",
})

-- Configuración para buffers de terminal
api.nvim_create_autocmd("TermOpen", {
  group = api.nvim_create_augroup("term_settings", { clear = true }),
  desc = "Configuración para terminal integrado",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    -- No entrar en insert mode si es el dashboard de snacks
    if vim.bo.filetype ~= "snacks_dashboard" then
      vim.cmd("startinsert")
    end
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

-- Optimización para archivos grandes (> 0.5MB)
api.nvim_create_autocmd("BufReadPre", {
  group = api.nvim_create_augroup("large_file", { clear = true }),
  desc = "Optimizar para archivos grandes",
  callback = function(ev)
    local ok, stats = pcall(vim.loop.fs_stat, ev.file)
    if ok and stats and stats.size > 524288 then -- 0.5MB
      vim.notify("Archivo grande detectado. Desactivando features pesadas.", vim.log.levels.INFO)
      vim.opt_local.swapfile = false
      vim.opt_local.undolevels = -1
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.spell = false
      vim.opt_local.foldmethod = "manual"
    end
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

-- Forzar modo normal en dashboard de snacks
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("snacks_dashboard_normal", { clear = true }),
  desc = "Forzar modo normal en dashboard de snacks",
  pattern = "snacks_dashboard",
  callback = function()
    vim.cmd("stopinsert")
  end,
})

api.nvim_create_autocmd("BufEnter", {
  group = "snacks_dashboard_normal",
  desc = "Forzar modo normal al entrar al dashboard",
  callback = function()
    if vim.bo.filetype == "snacks_dashboard" then
      vim.cmd("stopinsert")
    end
  end,
})

-- Configurar colores de indentación de Snacks según el tema
api.nvim_create_autocmd("ColorScheme", {
  group = api.nvim_create_augroup("snacks_indent_colors", { clear = true }),
  desc = "Configurar colores de indentación de Snacks",
  callback = function()
    -- Obtener colores del tema actual
    local colors = vim.api.nvim_get_hl(0, { name = "Comment" })
    local base_fg = colors.fg or vim.api.nvim_get_hl(0, { name = "Normal" }).fg or 0x7e9cd8

    -- Para Kanagawa, usar colores de la paleta que se mezclan bien
    if vim.g.colors_name == "kanagawa" then
      vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#2d4f67" })
      vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#625e5a" })
      vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#49443c" })
      vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#43436c" })
      vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#614f6e" })
      vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#2d4f67" })
      vim.api.nvim_set_hl(0, "SnacksIndent7", { fg = "#625e5a" })
      vim.api.nvim_set_hl(0, "SnacksIndent8", { fg = "#49443c" })
    else
      -- Fallback: usar el color de Comment con opacidad reducida
      vim.api.nvim_set_hl(0, "SnacksIndent", { fg = base_fg })
    end
  end,
})

-- Aplicar colores inmediatamente al cargar la config
vim.schedule(function()
  if vim.g.colors_name then
    vim.api.nvim_exec_autocmds("ColorScheme", { group = "snacks_indent_colors" })
  end
end)
