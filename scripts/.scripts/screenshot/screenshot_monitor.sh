#!/bin/bash
# Captura un monitor: el que se pasa como $1 (lo resuelve el keybind en Lua
# con hl.get_active_monitor) o, si no hay argumento, el enfocado.

set -euo pipefail

DIR="$HOME/Images/Screenshots"
mkdir -p "$DIR"

OUTPUT=${1:-$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')}

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
