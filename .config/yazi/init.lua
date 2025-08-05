local yazi = require("yazi")

-- Función para abrir en Neovim en nueva pestaña de Kitty
local function open_in_kitty_tab(state, args)
  local selected = state.selected
  if #selected == 0 then
    selected = { state.hovered }
  end

  for _, file in ipairs(selected) do
    os.execute(string.format(
      'kitty @ launch --type=tab --cwd=current nvim "%s"',
      file.url
    ))
  end
end

-- Función para abrir terminal en el directorio actual
local function open_terminal_here(state)
  os.execute(string.format(
    'kitty @ launch --type=window --cwd="%s"',
    state.cwd
  ))
end

-- Registrar las funciones
yazi.setup({
  open_in_kitty_tab = open_in_kitty_tab,
  open_terminal_here = open_terminal_here,
})
