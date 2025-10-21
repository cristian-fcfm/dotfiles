#!/bin/bash

# Solo DP-1
hyprctl keyword monitor DP-1,2560x1440@165,0x0,1
hyprctl keyword monitor HDMI-A-1,disable

# Todos los workspaces a DP-1
for i in {1..10}; do
    hyprctl keyword workspace $i,monitor:DP-1
done

notify-send "Monitores" "Solo DP-1 activo"
