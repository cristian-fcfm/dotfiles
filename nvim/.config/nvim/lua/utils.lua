local fn = vim.fn
local version = vim.version

local M = {}

--- Verifica si un ejecutable existe en el PATH del sistema
--- @param name string Nombre/ruta del ejecutable
--- @return boolean
function M.executable(name)
  return fn.executable(name) > 0
end

--- Verifica si una característica existe en Nvim
--- @param feat string Nombre de la característica, como `nvim-0.7` o `unix`.
--- @return boolean
M.has = function(feat)
  if fn.has(feat) == 1 then
    return true
  end

  return false
end

--- Crea un directorio si no existe
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then
    fn.mkdir(dir, "p")
  end
end

--- Verifica si estamos dentro de un repositorio git
--- @return boolean
function M.inside_git_repo()
  local result = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }, { text = true }):wait()
  if result.code ~= 0 then
    return false
  end

  -- Disparar manualmente un autocmd de usuario especial InGitRepo
  vim.cmd([[doautocmd User InGitRepo]])

  return true
end

return M
