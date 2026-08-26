#!/usr/bin/env bash
# principios.sh — consulta principios.yaml POR DOMINIO, sin cargarlo entero.
#
# El fichero crece con el tiempo; el agente solo necesita los records de los
# dominios de la tarea en curso. Este script es la forma canónica de leerlos
# (también lo usa la skill consultar-notas).
#
# Uso:
#   principios.sh dominios               # qué dominios existen ahora mismo
#   principios.sh <dominio> [dominio...] # records completos de esos dominios
#
# Los records `general` van siempre incluidos (aplican a cualquier tarea).
# Ruta por defecto sobreescribible: PRINCIPIOS_PATH=... principios.sh ...
set -euo pipefail

FILE="${PRINCIPIOS_PATH:-$HOME/Documents/notes/3-resources/zk/principios.yaml}"
[ -f "$FILE" ] || { echo "ERROR: no existe $FILE (¿vault en ~/Documents/notes?)" >&2; exit 1; }

if [ "${1:-}" = "dominios" ]; then
  grep -o 'aplica_a: \[.*\]' "$FILE" | sed 's/aplica_a: \[//; s/\]$//; s/, /\n/g' | sort -u
  exit 0
fi

[ $# -ge 1 ] || { echo "uso: principios.sh dominios | <dominio> [dominio...]" >&2; exit 1; }

# general aplica siempre
DOMS="general"
for d in "$@"; do DOMS="${DOMS}|${d}"; done

# Un record por bloque: los bloques empiezan en "  - id:" y el filtro es su
# línea aplica_a (regex sobre el bloque, no sobre el fichero).
awk -v dom="aplica_a:.*(${DOMS})" '
  /^  - id:/ { if (rec != "" && rec ~ dom) print rec "\n"; rec = $0; next }
  rec != "" { rec = rec "\n" $0 }
  END { if (rec != "" && rec ~ dom) print rec "\n" }
' "$FILE"
