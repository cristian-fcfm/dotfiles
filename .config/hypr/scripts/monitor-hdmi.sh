#!/bin/bash

# Apagar DP primero — Hyprland reasigna sus workspaces al fallback (HDMI)
hyprctl keyword monitor DP-1,disable
hyprctl keyword monitor HDMI-A-1,2560x1080@74.99,0x0,1

sleep 0.15

# Definir reglas: 5 persistentes, 5 despersistidos
for i in 1 2 3 4 5; do
    hyprctl keyword workspace $i,monitor:HDMI-A-1,persistent:true
done
for i in 6 7 8 9 10; do
    hyprctl keyword workspace $i,monitor:HDMI-A-1,persistent:false
done

sleep 0.1

# Asegurar que todos los workspaces con ventanas queden en HDMI
for i in {1..10}; do
    hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1 2>/dev/null
done

notify-send "Monitores" "Solo HDMI activo"
