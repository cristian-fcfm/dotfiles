# Waybar Circular Arch Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rediseñar visualmente el módulo `custom/arch` existente para que sea circular con fondo `@accent`, y agregarlo como primer elemento en `modules-left` de ambas barras.

**Architecture:** El módulo `custom/arch` ya existe en `modules/custom=logo.jsonc` con icono y acciones configuradas. Solo se necesita agregar estilos CSS al módulo y referenciarlo en ambas barras.

**Tech Stack:** Waybar (GTK3), CSS custom properties, JSONC

---

### Task 1: Agregar estilo circular al módulo en style.css

**Files:**
- Modify: `waybar/.config/waybar/style.css`

- [ ] **Step 1: Abrir style.css y ubicar la sección de estilos de módulos**

  El archivo está en `waybar/.config/waybar/style.css`. La sección de módulos base empieza en línea 20.

- [ ] **Step 2: Agregar la regla CSS `#custom-arch` al final del archivo**

  Agregar al final de `style.css`:

  ```css
  /* ─── ARCH LOGO ──────────────────────────────────────────────────────── */

  #custom-arch {
    min-width: 30px;
    min-height: 30px;
    margin: 4px 3px;
    border-radius: 50%;
    background: @accent;
    color: @background;
    font-size: 14px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  ```

- [ ] **Step 3: Verificar que no hay conflictos con la regla base de módulos**

  La regla base en línea 21-36 lista módulos explícitos (`#custom-music`, `#clock`, etc.). `#custom-arch` no está listado, así que no habrá override conflict.

- [ ] **Step 4: Commit**

  ```bash
  git add waybar/.config/waybar/style.css
  git commit -m "feat(waybar): add circular style for custom/arch module"
  ```

---

### Task 2: Agregar el módulo a bar-1.jsonc

**Files:**
- Modify: `waybar/.config/waybar/bars/bar-1.jsonc`

- [ ] **Step 1: Agregar el include del módulo en bar-1.jsonc**

  En el array `include`, agregar la referencia al módulo del logo:

  ```jsonc
  {
    "include": [
      "~/.config/waybar/modules/custom=logo.jsonc",   // <-- agregar
      "~/.config/waybar/modules/custom-music.jsonc",
      "~/.config/waybar/modules/custom-notifications.jsonc",
      "~/.config/waybar/modules/hyprland-workspaces.jsonc",
      "~/.config/waybar/modules/hyprland-language.jsonc",
      "~/.config/waybar/modules/tray.jsonc",
      "~/.config/waybar/modules/network.jsonc"
    ],
    "modules-left": ["custom/arch", "hyprland/workspaces"],   // <-- custom/arch primero
    "modules-center": ["custom/music"],
    "modules-right": [
      "tray",
      "hyprland/language",
      "network",
      "custom/notifications"
    ]
  }
  ```

- [ ] **Step 2: Commit**

  ```bash
  git add waybar/.config/waybar/bars/bar-1.jsonc
  git commit -m "feat(waybar): add arch logo module to bar-1 modules-left"
  ```

---

### Task 3: Agregar el módulo a bar-2.jsonc

**Files:**
- Modify: `waybar/.config/waybar/bars/bar-2.jsonc`

- [ ] **Step 1: Agregar el include del módulo en bar-2.jsonc**

  En el array `include`, agregar la referencia al módulo del logo:

  ```jsonc
  {
    "include": [
      "~/.config/waybar/modules/custom=logo.jsonc",   // <-- agregar
      "~/.config/waybar/modules/memory.jsonc",
      "~/.config/waybar/modules/custom-cpu-combined.jsonc",
      "~/.config/waybar/modules/custom-gpu-combined.jsonc",
      "~/.config/waybar/modules/hyprland-workspaces.jsonc",
      "~/.config/waybar/modules/clock.jsonc"
    ],
    "modules-left": ["custom/arch", "hyprland/workspaces"],   // <-- custom/arch primero
    "modules-right": [
      "memory",
      "custom/cpu-combined",
      "custom/gpu-combined",
      "clock#cl1"
    ]
  }
  ```

- [ ] **Step 2: Commit**

  ```bash
  git add waybar/.config/waybar/bars/bar-2.jsonc
  git commit -m "feat(waybar): add arch logo module to bar-2 modules-left"
  ```

---

### Task 4: Verificar visualmente en Waybar

- [ ] **Step 1: Recargar Waybar**

  ```bash
  pkill waybar && waybar &
  ```

  O con el keybind configurado en Hyprland si existe.

- [ ] **Step 2: Verificar en ambos monitores**

  - Bar-1 (DP-1, top): círculo accent a la izquierda antes de workspaces
  - Bar-2 (HDMI-A-1, bottom): círculo accent a la izquierda antes de workspaces

- [ ] **Step 3: Verificar interacciones**

  - Click izquierdo → abre rofi
  - Click derecho → abre powermenu
