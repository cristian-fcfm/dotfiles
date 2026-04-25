#!/bin/bash

# Configuración dual — DP primero para liberar 0x0 si venía de monitor-dp.sh
hyprctl keyword monitor DP-1,2560x1440@165,2560x0,1
hyprctl keyword monitor HDMI-A-1,2560x1080@74.99,0x0,1

# Esperar a que Hyprland registre ambos monitores
sleep 0.15

# 1) Definir reglas de persistencia para los 10 workspaces
for i in 1 3 4 5 6; do
    hyprctl keyword workspace $i,monitor:HDMI-A-1,persistent:true
done
for i in 2 7 8 9 10; do
    hyprctl keyword workspace $i,monitor:DP-1,persistent:true
done

sleep 0.1

# 2) Mover workspaces existentes (con ventanas) al monitor correcto
for i in 1 3 4 5 6; do
    hyprctl dispatch moveworkspacetomonitor $i HDMI-A-1 2>/dev/null
done
for i in 2 7 8 9 10; do
    hyprctl dispatch moveworkspacetomonitor $i DP-1 2>/dev/null
done

notify-send "Monitores" "Dual monitor activado"
