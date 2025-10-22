-- Setup full-border plugin
require("full-border"):setup()

-- Función para abrir en Neovim en nueva ventana de tmux
local function open_in_tmux_window()
  local selected = ya.selected()
  if #selected == 0 then
    selected = { ya.hovered() }
  end

  for _, file in ipairs(selected) do
    ya.manager_emit("shell", {
      string.format('tmux new-window -c "$(dirname "%s")" "nvim \\"%s\\""', tostring(file.url), tostring(file.url)),
      confirm = false,
      block = false,
    })
  end
end

-- Función para abrir en Neovim en nuevo panel de tmux
local function open_in_tmux_pane()
  local selected = ya.selected()
  if #selected == 0 then
    selected = { ya.hovered() }
  end

  for _, file in ipairs(selected) do
    ya.manager_emit("shell", {
      string.format('tmux split-window -c "$(dirname "%s")" "nvim \\"%s\\""', tostring(file.url), tostring(file.url)),
      confirm = false,
      block = false,
    })
  end
end

-- Función para abrir terminal en nueva ventana de tmux
local function open_terminal_window()
  local cwd = cx.active.current.cwd
  ya.manager_emit("shell", {
    string.format('tmux new-window -c "%s"', tostring(cwd)),
    confirm = false,
    block = false,
  })
end

-- Función para abrir terminal en nuevo panel de tmux
local function open_terminal_pane()
  local cwd = cx.active.current.cwd
  ya.manager_emit("shell", {
    string.format('tmux split-window -c "%s"', tostring(cwd)),
    confirm = false,
    block = false,
  })
end

-- Registrar los comandos personalizados
return {
  entry = function(_, args)
    local command = args[1]
    if command == "open_in_tmux_window" then
      open_in_tmux_window()
    elseif command == "open_in_tmux_pane" then
      open_in_tmux_pane()
    elseif command == "open_terminal_window" then
      open_terminal_window()
    elseif command == "open_terminal_pane" then
      open_terminal_pane()
    end
  end,
}
