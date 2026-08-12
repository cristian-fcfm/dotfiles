-- Programas y recursos por defecto, compartidos por el autostart, los
-- keybinds y los monitores.

local M = {
  terminal = "kitty",
  file_manager = "yazi",
  browser = "firefox",
  menu = "rofi -show drun",
  lock = "hyprlock",

  wallpaper = "~/.wallpapers/berserk.png",
}

--- Comando para (re)aplicar el wallpaper a todos los outputs activos.
---@return string
function M.wallpaper_cmd()
  return "awww img " .. M.wallpaper
end

return M
