#!/bin/bash

# Configuración dual monitor
hyprctl keyword monitor HDMI-A-1,2560x1080@74.99,0x0,1
hyprctl keyword monitor DP-1,2560x1440@165,2560x0,1

# Asignar workspaces para dual monitor
hyprctl keyword workspace 1,monitor:HDMI-A-1
hyprctl keyword workspace 2,monitor:DP-1
hyprctl keyword workspace 3,monitor:HDMI-A-1
hyprctl keyword workspace 4,monitor:HDMI-A-1
hyprctl keyword workspace 5,monitor:HDMI-A-1
hyprctl keyword workspace 6,monitor:HDMI-A-1
hyprctl keyword workspace 7,monitor:DP-1
hyprctl keyword workspace 8,monitor:DP-1
hyprctl keyword workspace 9,monitor:DP-1
hyprctl keyword workspace 10,monitor:DP-1

notify-send "Monitores" "Dual monitor activado"
