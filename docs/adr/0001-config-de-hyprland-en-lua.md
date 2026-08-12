# 1. Config de Hyprland en Lua

Fecha: 2026-08-12 · Estado: aceptado

## Contexto

Hyprland 0.55 deprecó hyprlang. La config se migró a `hyprland.lua` + módulos
en `conf/`.

Hyprland solo carga el gestor Lua si el archivo de config termina en `.lua`.
Al hacerlo, `hyprctl dispatch` pasa a interpretar su argumento como Lua:

    hyprctl dispatch workspace 3
    error: [string "return hl.dispatch(workspace 3)"]:1: ')' expected near '3'

## Decisión

Mantener la config en Lua y adaptar toda herramienta externa a la sintaxis
nueva: `hyprctl dispatch 'hl.dsp.focus({workspace=3})'`.

## Consecuencias

- Cualquier script, keybind de otra app o módulo de barra que use la sintaxis
  clásica deja de funcionar en silencio (devuelve error, no cambia nada).
- Waybar 0.15.0 envía la sintaxis clásica desde su código: el clic en los
  workspaces no funciona hasta que llegue el fix de upstream (PR #5013).
- A cambio: módulos con scope aislado, `hl.on` para eventos del compositor y
  lógica real (el toggle de monitores) en vez de duplicar reglas.
