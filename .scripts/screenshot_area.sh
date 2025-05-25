#!/bin/bash
DIR="$HOME/Images/Screenshots"
[ ! -d "$DIR" ] && mkdir -p "$DIR"

FILE="$DIR/area_$(date +%Y-%m-%d_%H-%M-%S).png"

if grim -g "$(slurp)" "$FILE"; then
  wl-copy < "$FILE"
  notify-send "󰄄 Captura de zona" "Guardada y copiada al portapapeles"
else
  notify-send "Error" "La captura fue cancelada o falló"
fi
