#!/bin/bash

# Estado del toggle (archivo temporal)
STATE_FILE="/tmp/waybar-cpu-state"
TEMP_PATH="/sys/class/hwmon/hwmon2/temp1_input"

# Función para alternar el estado
toggle_state() {
  if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
  else
    touch "$STATE_FILE"
  fi
  pkill -RTMIN+8 waybar
}

# Si se pasa el argumento "toggle", alternar estado
if [ "$1" == "toggle" ]; then
  toggle_state
  exit 0
fi

# Obtener uso de CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d'.' -f1)

# Obtener cores usados
CPU_CORES=$(nproc)

# Obtener temperatura de CPU
if [ -f "$TEMP_PATH" ]; then
  TEMP_RAW=$(cat "$TEMP_PATH")
  TEMP=$((TEMP_RAW / 1000))
else
  TEMP="N/A"
fi

# Determinar ícono de temperatura
if [ "$TEMP" != "N/A" ]; then
  if [ "$TEMP" -ge 80 ]; then
    TEMP_ICON=""
  elif [ "$TEMP" -ge 60 ]; then
    TEMP_ICON=""
  else
    TEMP_ICON=""
  fi
else
  TEMP_ICON=""
fi

# Crear tooltip con información detallada
TOOLTIP=" CPU Usage: ${CPU_USAGE}%\\n Cores: ${CPU_CORES}\\n${TEMP_ICON} Temperature: ${TEMP}°C"

# Mostrar según el estado
if [ -f "$STATE_FILE" ]; then
  # Mostrar uso + temperatura con iconos
  echo "{\"text\": \" ${CPU_USAGE}% ${TEMP_ICON} ${TEMP}°C\", \"tooltip\": \"${TOOLTIP}\", \"class\": \"expanded\"}"
else
  # Mostrar solo uso con icono
  echo "{\"text\": \" ${CPU_USAGE}%\", \"tooltip\": \"${TOOLTIP}\\nClick to show temperature\", \"class\": \"compact\"}"
fi
