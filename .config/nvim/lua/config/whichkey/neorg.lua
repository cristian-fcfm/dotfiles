local wk = require("which-key")

wk.add({
  -- ========================================================================
  -- NAVIGATION
  -- ========================================================================
  { "<localleader>n", group = "Neorg", icon = "" },
  { "<localleader>nn", desc = "Índice del workspace", icon = "" },
  { "<localleader>nw", desc = "Cambiar workspace", icon = "" },
  { "<localleader>nf", desc = "Buscar notas (archivos)", icon = "" },
  { "<localleader>ng", desc = "Buscar en contenido (grep)", icon = "" },
  { "<localleader>nr", desc = "Notas recientes", icon = "󰋚" },

  -- ========================================================================
  -- JOURNAL
  -- ========================================================================
  { "<localleader>j", group = "Journal", icon = "" },

  -- Día
  { "<localleader>jd", desc = "Hoy", icon = "" },
  { "<localleader>jD", desc = "Ayer", icon = "" },
  { "<localleader>j<C-d>", desc = "Mañana", icon = "" },

  -- Semana
  { "<localleader>jw", desc = "Semana actual", icon = "" },
  { "<localleader>jW", desc = "Semana anterior", icon = "" },
  { "<localleader>j<C-w>", desc = "Semana siguiente", icon = "" },

  -- Mes
  { "<localleader>jm", desc = "Mes actual", icon = "" },
  { "<localleader>jM", desc = "Mes anterior", icon = "" },
  { "<localleader>j<C-m>", desc = "Mes siguiente", icon = "" },

  -- Año
  { "<localleader>jy", desc = "Año actual", icon = "" },
  { "<localleader>jY", desc = "Año anterior", icon = "" },
  { "<localleader>j<C-y>", desc = "Año siguiente", icon = "" },

  -- ========================================================================
  -- TEMPLATES
  -- ========================================================================
  { "<localleader>t", group = "Templates & Tasks", icon = "" },
  { "<localleader>tp", desc = "Template: Project", icon = "" },
  { "<localleader>ta", desc = "Template: Area", icon = "" },
  { "<localleader>tr", desc = "Template: Resource", icon = "" },
  { "<localleader>tm", desc = "Template: Meeting", icon = "" },
  { "<localleader>tz", desc = "Template: Zettel", icon = "󰠮" },

  -- ========================================================================
  -- TASKS
  -- ========================================================================
  { "<localleader>td", desc = "Tarea completada", icon = "✓" },
  { "<localleader>tu", desc = "Tarea pendiente", icon = "✗" },
  { "<localleader>tP", desc = "Tarea en progreso", icon = "○" },
})
