---
name: explorar
description: 'Mapea el código relevante de un proyecto antes de hacer cambios, en modo solo lectura. Úsala al inicio de una tarea para entender estructura, puntos de entrada/salida y riesgos. Triggers: "explorar", "entender el código", "mapear", "antes de tocar nada", primera fase de una tarea nueva.'
---

# Explorar

Fase EXPLORAR. **Solo lectura**: no edites ni ejecutes comandos que modifiquen nada.

## Objetivo

Entender el código relacionado con la tarea antes de proponer cambios.

## Pasos

1. Localiza los archivos y módulos relevantes (búscalos, no asumas).
2. Si el repo tiene `CONTEXT.md` (glosario de dominio) o `docs/adr/`, léelos primero:
   te dan el lenguaje y las decisiones ya tomadas.
   Si la tarea toca dos o más zonas independientes (módulos o paquetes sin
   dependencia entre sí), lanza un `explorador` por zona en una sola llamada a la tool
   `subagent` (máximo 4) y une sus resúmenes. Cada tarea es autocontenida: las rutas de
   su zona y qué devolver, porque el explorador no ve esta conversación. Con una sola
   zona, o si la tool `subagent` no existe, explora tú mismo.
3. Explica en pocas líneas: qué hace, cómo está estructurado, puntos de entrada/salida
   (con referencias `archivo:línea`).
4. Identifica riesgos, dependencias y zonas frágiles.
5. Si la tarea toca un dominio con principios míos, menciona cuáles podrían aplicar
   (usa la skill `consultar-notas` para revisar `principios.yaml`).

## Cierre

Resume en corto y pregunta si paso a `/skill:disenar`. **No implementes aún.**
