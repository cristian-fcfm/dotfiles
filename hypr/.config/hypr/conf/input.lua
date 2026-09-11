-- ============================================================================
-- Entrada
-- ============================================================================
-- Dos layouts US: el segundo con variante intl (acentos con tecla muerta).
-- Se alternan con Alt+Shift; waybar muestra cuál está activo.

hl.config({
  input = {
    kb_layout = "us,us",
    kb_variant = ",intl",
    kb_options = "grp:alt_shift_toggle",
    follow_mouse = 1,
    sensitivity = 0,
  },
})
