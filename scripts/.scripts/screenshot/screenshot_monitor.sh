#!/bin/bash
# Captura el monitor enfocado.

set -euo pipefail

DIR="$HOME/Images/Screenshots"
mkdir -p "$DIR"

OUTPUT=$(hyprctl monitors | awk '/^Monitor/ {name = $2} /focused: yes/ {print name; exit}')

if [ -z "$OUTPUT" ]; then
  notify-send "Error" "No se pudo determinar el monitor enfocado"
  exit 1
fi

FILE="$DIR/monitor_${OUTPUT}_$(date +%Y-%m-%d_%H-%M-%S).png"

if grim -o "$OUTPUT" "$FILE"; then
  wl-copy <"$FILE"
  notify-send "󰄄 Captura de $OUTPUT" "Guardada y copiada al portapapeles"
else
  notify-send "Error" "Falló la captura de $OUTPUT"
  exit 1
fi
