#!/bin/bash

# Solo HDMI-A-1
hyprctl keyword monitor HDMI-A-1,2560x1080@74.99,0x0,1
hyprctl keyword monitor DP-1,disable

# Todos los workspaces a HDMI-A-1
for i in {1..10}; do
    hyprctl keyword workspace $i,monitor:HDMI-A-1
done

notify-send "Monitores" "Solo HDMI activo"
