# Waybar Circular Arch Logo Module

## Overview

Rediseñar visualmente el módulo `custom/arch` existente para que tenga forma circular con fondo accent, y agregarlo como primer elemento en `modules-left` de ambas barras.

## Current State

- El módulo `custom/arch` existe en `modules/custom=logo.jsonc` con el icono Nerd Font ``
- Abre rofi (click) y powermenu (click derecho)
- No tiene estilos propios en `style.css`
- No está incluido en ninguna barra actualmente

## Design

### CSS (style.css)

Agregar regla `#custom-arch` con:

- Dimensiones fijas: `min-width: 30px`, `min-height: 30px`
- Forma circular: `border-radius: 50%`
- Fondo: `@accent`
- Color del icono: `@background`
- Centrado: `display: flex`, `align-items: center`, `justify-content: center`
- Sin padding lateral extra (el centrado lo maneja flexbox)
- `font-weight: 700` para que el icono se vea sólido
- Margin consistente con otros módulos: `margin: 4px 3px`

### Bar configs

**bar-1.jsonc** (DP-1, top):
- Agregar `"~/.config/waybar/modules/custom=logo.jsonc"` al array `include`
- Agregar `"custom/arch"` al inicio de `modules-left`

**bar-2.jsonc** (HDMI-A-1, bottom):
- Agregar `"~/.config/waybar/modules/custom=logo.jsonc"` al array `include`
- Agregar `"custom/arch"` al inicio de `modules-left`

### Module config (sin cambios)

El archivo `modules/custom=logo.jsonc` se mantiene tal cual:

```jsonc
{
  "custom/arch": {
    "format": "  ",
    "tooltip": false,
    "on-click": "sleep 0.1 && rofi -show drun",
    "on-click-right": "~/.config/rofi/scripts/powermenu/powermenu"
  }
}
```

## Files Modified

1. `waybar/.config/waybar/style.css` — nueva regla `#custom-arch`
2. `waybar/.config/waybar/bars/bar-1.jsonc` — include + modules-left
3. `waybar/.config/waybar/bars/bar-2.jsonc` — include + modules-left

## Approach

CSS puro con dimensiones fijas. Máxima compatibilidad con GTK3/Waybar, simple de mantener y extender.

## Future Extensibility

El módulo está diseñado para ser extendido posteriormente con funcionalidad adicional (tooltips, indicadores, popups). El CSS circular sirve como base visual estable.
