---
name: implementar
description: Implementa el diseño acordado aplicando los principios activos y respetando el contexto del proyecto. Úsala tras diseñar/alinear, para escribir código de forma incremental y verificable. Triggers: "implementar", "construye", "escribe el código", fase de implementación tras un plan aprobado.
---

# Implementar

Fase IMPLEMENTAR.

## Reglas

1. Sigue el diseño acordado en `/skill:disenar`. Si no hubo, haz primero un plan corto.
2. Respeta la REGLA DE PRECEDENCIA: aplica mis principios `confirmado` y cita su
   `id` cuando los apliques (en el chat). Avísame de cualquier `propuesto` o gap
   que toques.
3. Respeta el `CONTEXT.md`/ADRs del repo si existen (lenguaje y decisiones).
4. Cambios incrementales y verificables. No hagas refactors masivos no pedidos.
5. Si la tarea se beneficia de tests, prefiere el flujo `/skill:tdd`
   (red-green-refactor) en vez de escribir todo y testear al final.
6. Explica brevemente el porqué de las decisiones no triviales mientras avanzas.
7. No commitees ni hagas push salvo que te lo pida.

## Cierre

Lista qué cambiaste (con `archivo:línea`) y sugiere pasar a `/skill:revisar`.
