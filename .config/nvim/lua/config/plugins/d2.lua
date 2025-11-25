-- Plugin para soporte de D2 (lenguaje de diagramas de arquitectura cloud)
return {
  {
    "terrastruct/d2-vim",
    ft = { "d2" },
    config = function()
      -- Tema optimizado para diagramas cloud (Cool classics es ideal para arquitectura)
      vim.g.d2_theme = "3" -- Cool classics - profesional para cloud architecture

      -- Layout engine ELK es mejor para diagramas de arquitectura complejos
      vim.g.d2_layout = "elk" -- ELK maneja mejor diagramas grandes y complejos

      -- Deshabilitar auto-compilación (usaremos comandos manuales con tmux)
      vim.g.d2_compile_on_save = 0

      -- Configurar formato de salida
      vim.g.d2_format = "svg" -- SVG es mejor para diagramas técnicos

      -- Configurar sketch mode (desactivado para arquitectura profesional)
      vim.g.d2_sketch = 0 -- Líneas limpias para diagramas profesionales
    end,
  },
}
