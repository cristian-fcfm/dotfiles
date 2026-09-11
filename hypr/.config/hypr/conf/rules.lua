-- Reglas de ventana y permisos.
--
-- Los permisos requieren `hyprland-guiutils` y un restart de Hyprland: no se
-- aplican con `hyprctl reload`. Lo no permitido aquí dispara un popup.

---------------------------------------------------------------------------
-- Window rules
---------------------------------------------------------------------------

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

-- Terminal flotante que usan los on-click de waybar.
hl.window_rule({
  name = "center-float-mini",
  match = { class = "^center-float-mini$" },
  float = true,
  size = "900 500",
  center = true,
})

-- Utilidades de audio y diálogos del portal: ventanas de usar y tirar.
hl.window_rule({
  name = "float-utils",
  match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol|easyeffects|qpwgraph|blueman-manager|nm-connection-editor)$" },
  float = true,
  center = true,
})

hl.window_rule({
  name = "float-portal-dialogs",
  match = { class = "^(xdg-desktop-portal-gtk)$" },
  float = true,
  center = true,
})

-- Video o juego a pantalla completa: hypridle no bloquea ni apaga el monitor.
hl.window_rule({
  name = "inhibit-idle-fullscreen",
  match = { fullscreen = true },
  idle_inhibit = "fullscreen",
})

-- decoration.blur solo alcanza a las capas que lo pidan. Namespaces según
-- `hyprctl layers`; rofi y swaync aparecen cuando están abiertos.
hl.layer_rule({
  name = "blur-shell",
  match = { namespace = "^(waybar|rofi|swaync-control-center|swaync-notification-window)$" },
  blur = true,
  ignore_alpha = 0.3,
})

---------------------------------------------------------------------------
-- Permisos (screencopy / plugins)
---------------------------------------------------------------------------
-- Solo estos binarios capturan pantalla sin preguntar.

hl.config({ ecosystem = { enforce_permissions = true } })

hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })
hl.permission({
  binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",
  type = "screencopy",
  mode = "allow",
})
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })
