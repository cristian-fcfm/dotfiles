#!/bin/bash
# GPU NVIDIA: uso, temperatura y memoria para waybar.

set -uo pipefail

if ! command -v nvidia-smi &>/dev/null; then
  echo '{"text": "󰢮", "tooltip": "nvidia-smi no disponible", "class": "unavailable"}'
  exit 0
fi

read -r USAGE TEMP MEM_USED MEM_TOTAL NAME <<<"$(
  nvidia-smi \
    --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total,name \
    --format=csv,noheader,nounits 2>/dev/null | tr -d ',' | head -1
)"

# nvidia-smi puede responder vacío (driver dormido): no pintar basura.
if [ -z "${USAGE:-}" ] || [ -z "${TEMP:-}" ]; then
  echo '{"text": "󰢮 —", "tooltip": "GPU sin respuesta", "class": "unavailable"}'
  exit 0
fi

if [ "$TEMP" -ge 75 ]; then
  TEMP_ICON=""
  CLASS="critical"
elif [ "$TEMP" -ge 55 ]; then
  TEMP_ICON=""
  CLASS="warning"
else
  TEMP_ICON=""
  CLASS="normal"
fi

TOOLTIP="󰢮 GPU: ${NAME}\nUso: ${USAGE}%\nMemoria: ${MEM_USED}MB / ${MEM_TOTAL}MB\n${TEMP_ICON} Temperatura: ${TEMP}°C"

printf '{"text": "󰢮 %s%% %s %s°C", "tooltip": "%s", "class": "%s"}\n' \
  "$USAGE" "$TEMP_ICON" "$TEMP" "$TOOLTIP" "$CLASS"
