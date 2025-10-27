return {
  "rachartier/tiny-inline-diagnostic.nvim",
  -- Cargar cuando LSP se adjunta a un buffer
  event = "LspAttach",
  opts = {
    -- Preset: modern, classic, minimal, ghost, simple, nonerdfont, amongus
    preset = "modern",
    -- Opciones de performance
    options = {
      -- Mostrar diagnósticos inline
      show_source = false,
      -- Throttle para evitar actualizaciones excesivas
      throttle = 20,
      -- Multiline para mensajes largos
      multilines = false,
      -- Overflow para mensajes muy largos
      overflow = {
        mode = "wrap",
      },
      -- Break line para mejor legibilidad
      break_line = {
        enabled = false,
      },
    },
  },
}
