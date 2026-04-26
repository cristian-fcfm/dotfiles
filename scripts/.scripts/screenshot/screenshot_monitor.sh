#!/bin/bash
DIR="$HOME/Images/Screenshots"
[ ! -d "$DIR" ] && mkdir -p "$DIR"

# Obtener ID del monitor activo desde la ventana activa
MONITOR_ID=$(hyprctl activewindow | awk '$1 == "monitor:" {print $2}')
[ -z "$MONITOR_ID" ] && notify-send "Error" "No se pudo obtener el monitor ID" && exit 1

# Traducir el ID al nombre real del monitor
OUTPUT=$(hyprctl monitors | awk -v id="$MONITOR_ID" '
  $1 == "Monitor" && ($(NF-1) " " $NF) == "(ID "id"):" { print $2 }
')



if [ -z "$OUTPUT" ]; then
  notify-send "Error" "No se encontró monitor con ID $MONITOR_ID"
  exit 1
fi

FILE="$DIR/monitor_${OUTPUT}_$(date +%Y-%m-%d_%H-%M-%S).png"

if grim -o "$OUTPUT" "$FILE"; then
  wl-copy < "$FILE"
  notify-send "󰄄 Captura de $OUTPUT" "Guardada y copiada al portapapeles"
else
  notify-send "Error" "Falló la captura de $OUTPUT"
fi
