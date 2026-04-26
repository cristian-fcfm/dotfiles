#!/bin/bash

# Toggle HDMI-A-1. DP-1 siempre activo.
#   HDMI ON  → DP: 1-5  |  HDMI: 6-10
#   HDMI OFF → todo en DP (mover 6-10)

DP="DP-1"
HDMI="HDMI-A-1"

if hyprctl monitors | grep -q "^Monitor $HDMI "; then
  # HDMI activo → mover ventanas a DP, apagar HDMI y recargar config base
  for i in 6 7 8 9 10; do
    hyprctl dispatch moveworkspacetomonitor "$i $DP" 2>/dev/null
  done

  hyprctl reload

  notify-send "Monitores" "Solo DP-1 activo"
else
  hyprctl keyword monitor "$HDMI,2560x1080@74.99,-2560x0,1"

  for i in 6 7 8 9 10; do
    hyprctl keyword workspace "$i,monitor:$HDMI,persistent:true"
  done

  sleep 0.1
  for i in 6 7 8 9 10; do
    hyprctl dispatch moveworkspacetomonitor "$i $HDMI" 2>/dev/null
  done

  hyprctl dispatch focusmonitor "$HDMI"
  hyprctl dispatch workspace 6

  notify-send "Monitores" "Dual: DP-1 + HDMI-A-1"
fi
