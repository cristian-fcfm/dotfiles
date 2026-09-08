local fn = vim.fn

local M = {}

--- Verifica si un ejecutable existe en el PATH del sistema
--- @param name string Nombre/ruta del ejecutable
--- @return boolean
function M.executable(name)
  return fn.executable(name) > 0
end

return M
