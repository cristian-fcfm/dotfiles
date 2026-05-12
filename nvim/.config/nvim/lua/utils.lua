local fn = vim.fn

local M = {}

--- Verifica si un ejecutable existe en el PATH del sistema
--- @param name string Nombre/ruta del ejecutable
--- @return boolean
function M.executable(name)
  return fn.executable(name) > 0
end

--- Crea un directorio si no existe
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then
    fn.mkdir(dir, "p")
  end
end

--- Asigna un valor a una tabla solo si el ejecutable existe en PATH
--- @param tbl table       Tabla destino (ej: linters_by_ft)
--- @param key string      Clave (filetype)
--- @param exec string     Nombre del ejecutable a verificar
--- @param value any       Valor a asignar si existe
function M.set_if_executable(tbl, key, exec, value)
  value = value or { exec }
  if M.executable(exec) then
    tbl[key] = value
  end
end

return M
