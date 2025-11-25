local fn = vim.fn
local version = vim.version

local M = {}

--- Verifica si un ejecutable existe (revisa PATH del sistema y directorio bin de Mason)
--- @param name string Nombre/ruta del ejecutable
--- @return boolean
function M.executable(name)
  -- Revisar primero el PATH del sistema
  if fn.executable(name) > 0 then
    return true
  end

  -- Revisar directorio bin de Mason
  local mason_bin = fn.stdpath("data") .. "/mason/bin/" .. name
  if fn.executable(mason_bin) > 0 then
    return true
  end

  return false
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

--- Verifica si la versión actual de nvim es compatible con la versión esperada
--- @param expected_version string
--- @return boolean
function M.is_compatible_version(expected_version)
  -- Verificar si tenemos la última versión estable de nvim
  local expect_ver = version.parse(expected_version)
  local actual_ver = vim.version()

  if expect_ver == nil then
    local msg = string.format("Versión no soportada: %s", expected_version)
    vim.notify(msg, vim.log.levels.ERROR)
    return false
  end

  local result = version.cmp(expect_ver, actual_ver)
  if result ~= 0 then
    local _ver = string.format("%s.%s.%s", actual_ver.major, actual_ver.minor, actual_ver.patch)
    local msg = string.format(
      "Se espera nvim versión %s, pero tu versión actual es %s. ¡Usa bajo tu propio riesgo!",
      expected_version,
      _ver
    )
    vim.notify(msg, vim.log.levels.WARN)
  end

  return true
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
