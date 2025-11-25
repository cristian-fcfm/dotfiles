local wk = require("which-key")

-- Función helper para compilar y mostrar en tmux
local function compile_and_show_in_tmux(format, extra_flags)
  extra_flags = extra_flags or ""
  local filename = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") .. "." .. format

  -- Compilar el diagrama
  local compile_cmd = string.format("d2 --theme=3 --layout=elk %s %s %s", extra_flags, filename, output)

  -- Comando para mostrar en tmux panel vertical
  local tmux_cmd = string.format(
    "tmux split-window -h -l 50%% 'cat %s && echo \"\" && echo \"Press any key to close...\" && read -n 1' && tmux select-pane -L",
    output
  )

  -- Ejecutar compilación y mostrar
  vim.fn.system(compile_cmd)
  if vim.v.shell_error == 0 then
    vim.fn.system(tmux_cmd)
    vim.notify("D2 diagram compiled to " .. format, vim.log.levels.INFO)
  else
    vim.notify("D2 compilation failed", vim.log.levels.ERROR)
  end
end

-- Función para watch mode con recarga automática en tmux
local function watch_mode()
  local filename = vim.fn.expand("%")
  local output = vim.fn.expand("%:r") .. ".svg"

  -- Crear panel tmux con watch
  local watch_cmd = string.format(
    "tmux split-window -h -l 50%% 'watch -n 1 \"cat %s 2>/dev/null || echo Waiting for compilation...\"'",
    output
  )

  vim.fn.system(watch_cmd)

  -- Mensaje al usuario
  vim.notify("Watch mode started. Save file to recompile.", vim.log.levels.INFO)

  -- Habilitar auto-compilación temporal
  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = 0,
    callback = function()
      local compile_cmd = string.format("d2 --theme=3 --layout=elk %s %s", filename, output)
      vim.fn.system(compile_cmd)
    end,
    desc = "D2 auto-compile on save",
  })
end

-- Función para recargar el diagrama actual en tmux
local function reload_diagram()
  local output = vim.fn.expand("%:r") .. ".svg"

  -- Recompilar
  local compile_cmd = string.format("d2 --theme=3 --layout=elk %s %s", vim.fn.expand("%"), output)
  vim.fn.system(compile_cmd)

  if vim.v.shell_error == 0 then
    -- Refrescar el panel de tmux (enviar C-c y luego el comando de visualización)
    local refresh_cmd = string.format(
      "tmux send-keys -t {right} C-c Enter && tmux send-keys -t {right} 'cat %s' Enter",
      output
    )
    vim.fn.system(refresh_cmd)
    vim.notify("D2 diagram reloaded", vim.log.levels.INFO)
  else
    vim.notify("D2 compilation failed", vim.log.levels.ERROR)
  end
end

wk.add({
  { "<leader>d", group = "D2 Diagrams", icon = "󱓷" },

  -- Previsualización y compilación
  {
    "<leader>dp",
    function()
      compile_and_show_in_tmux("svg")
    end,
    desc = "[P]review diagram (SVG)",
    icon = "󰈟",
  },
  {
    "<leader>dc",
    function()
      compile_and_show_in_tmux("png")
    end,
    desc = "[C]ompile to PNG",
    icon = "󰸭",
  },
  {
    "<leader>ds",
    function()
      compile_and_show_in_tmux("svg")
    end,
    desc = "Compile to [S]VG",
    icon = "󰈟",
  },

  -- Modo sketch
  {
    "<leader>dS",
    function()
      compile_and_show_in_tmux("svg", "--sketch")
    end,
    desc = "[S]ketch mode",
    icon = "󰽔",
  },

  -- Watch mode con auto-reload
  {
    "<leader>dw",
    watch_mode,
    desc = "[W]atch mode (auto-reload)",
    icon = "󰁯",
  },

  -- Recargar diagrama
  {
    "<leader>dr",
    reload_diagram,
    desc = "[R]eload diagram",
    icon = "󰑓",
  },

  -- Temas
  { "<leader>dt", group = "[T]hemes", icon = "󰏘" },
  {
    "<leader>dt1",
    function()
      vim.g.d2_theme = "0"
      vim.notify("D2 theme: Neutral default", vim.log.levels.INFO)
    end,
    desc = "Neutral default",
  },
  {
    "<leader>dt2",
    function()
      vim.g.d2_theme = "1"
      vim.notify("D2 theme: Neutral grey", vim.log.levels.INFO)
    end,
    desc = "Neutral grey",
  },
  {
    "<leader>dt3",
    function()
      vim.g.d2_theme = "3"
      vim.notify("D2 theme: Cool classics", vim.log.levels.INFO)
    end,
    desc = "Cool classics",
  },
  {
    "<leader>dt4",
    function()
      vim.g.d2_theme = "7"
      vim.notify("D2 theme: Colorblind clear", vim.log.levels.INFO)
    end,
    desc = "Colorblind clear",
  },

  -- Layout engines
  { "<leader>dl", group = "[L]ayout engine", icon = "󱓻" },
  {
    "<leader>dle",
    function()
      vim.g.d2_layout = "elk"
      vim.notify("D2 layout: ELK (complex diagrams)", vim.log.levels.INFO)
    end,
    desc = "[E]LK (complex)",
  },
  {
    "<leader>dld",
    function()
      vim.g.d2_layout = "dagre"
      vim.notify("D2 layout: Dagre (fast)", vim.log.levels.INFO)
    end,
    desc = "[D]agre (fast)",
  },
  {
    "<leader>dlt",
    function()
      vim.g.d2_layout = "tala"
      vim.notify("D2 layout: Tala (experimental)", vim.log.levels.INFO)
    end,
    desc = "[T]ala (experimental)",
  },
})
