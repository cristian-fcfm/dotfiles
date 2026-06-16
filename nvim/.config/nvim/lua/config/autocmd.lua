-- ============================================================================
-- Autocommands
-- ============================================================================

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

local auto_read = api.nvim_create_augroup("auto_read", { clear = true })

local function refresh_changed_buffer(bufnr)
  if not api.nvim_buf_is_valid(bufnr) then
    return
  end

  if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
    return
  end

  local view = nil
  local current_buf = api.nvim_get_current_buf()
  if current_buf == bufnr then
    view = vim.fn.winsaveview()
  end

  pcall(vim.treesitter.stop, bufnr)

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("silent! keepalt keepjumps edit!")
  end)

  local ok = pcall(vim.treesitter.start, bufnr)
  if ok then
    for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
      if api.nvim_win_is_valid(win) then
        vim.wo[win].foldmethod = "expr"
        vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[win].foldlevel = 99
      end
    end

    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  if view and api.nvim_get_current_buf() == bufnr then
    vim.fn.winrestview(view)
  end

  vim.cmd("redraw!")
end

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

-- Notificar cuando un archivo cambió en disco
api.nvim_create_autocmd("FileChangedShellPost", {
  group = auto_read,
  desc = "Notificar cambio de archivo en disco",
  callback = function(args)
    vim.schedule(function()
      refresh_changed_buffer(args.buf)
    end)

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

-- Toggle números relativos y cursorcolumn
local insert_ui_toggle = api.nvim_create_augroup("insert_ui_toggle", { clear = true })

api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = insert_ui_toggle,
  desc = "Desactivar números relativos y activar cursorcolumn en insert mode",
  callback = function(args)
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
    -- Solo activar cursorcolumn en InsertEnter, no en WinLeave
    if args.event == "InsertEnter" then
      vim.wo.cursorcolumn = true
    end
  end,
})

api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = insert_ui_toggle,
  desc = "Activar números relativos y desactivar cursorcolumn en normal mode",
  callback = function(args)
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
    -- Solo desactivar cursorcolumn en InsertLeave, no en WinEnter
    if args.event == "InsertLeave" then
      vim.wo.cursorcolumn = false
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

-- Activar spell en filetypes de escritura
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("spell_filetypes", { clear = true }),
  pattern = { "markdown", "zk", "typst" },
  desc = "Activar spell en filetypes de escritura",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Evitar auto-wrap de texto en todos los filetypes
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("format_options", { clear = true }),
  pattern = "*",
  desc = "Desactivar auto-wrap de texto",
  callback = function()
    vim.opt_local.formatoptions:remove("t")
  end,
})
