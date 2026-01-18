#!/bin/bash

# Estado del toggle (archivo temporal)
STATE_FILE="/tmp/waybar-gpu-state"

# Función para alternar el estado
toggle_state() {
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
    else
        touch "$STATE_FILE"
    fi
    pkill -RTMIN+9 waybar
}

# Si se pasa el argumento "toggle", alternar estado
if [ "$1" == "toggle" ]; then
    toggle_state
    exit 0
fi

# Obtener información de GPU con nvidia-smi
if command -v nvidia-smi &> /dev/null; then
    GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "0")
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
    GPU_MEM_USED=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null || echo "0")
    GPU_MEM_TOTAL=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null || echo "0")
    GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || echo "GPU")
else
    GPU_USAGE="0"
    GPU_TEMP="N/A"
    GPU_MEM_USED="0"
    GPU_MEM_TOTAL="0"
    GPU_NAME="GPU"
fi

TEMP="$GPU_TEMP"

# Determinar ícono de temperatura
if [ "$TEMP" != "N/A" ]; then
    if [ "$TEMP" -ge 75 ]; then
        TEMP_ICON=""
    elif [ "$TEMP" -ge 55 ]; then
        TEMP_ICON=""
    else
        TEMP_ICON=""
    fi
else
    TEMP_ICON=""
fi

# Crear tooltip con información detallada
TOOLTIP="󰍛  GPU: ${GPU_NAME}\\nUsage: ${GPU_USAGE}%\\nMemory: ${GPU_MEM_USED}MB / ${GPU_MEM_TOTAL}MB\\n${TEMP_ICON} Temperature: ${TEMP}°C"

# Mostrar según el estado
if [ -f "$STATE_FILE" ]; then
    # Mostrar uso + temperatura con iconos
    echo "{\"text\": \"󰍛  ${GPU_USAGE}% ${TEMP_ICON} ${TEMP}°C\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"expanded\"}"
else
    # Mostrar solo uso con icono
    echo "{\"text\": \"󰍛  ${GPU_USAGE}%\", \"tooltip\": \"${TOOLTIP}\\nClick to show temperature\", \"class\": \"compact\"}"
fi
