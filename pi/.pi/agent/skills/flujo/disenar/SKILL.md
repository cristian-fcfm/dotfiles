---
name: disenar
description: 'Propone un diseño de implementación consultando los principios y el contexto del proyecto antes de escribir código. Úsala después de explorar y alinear, para elegir un enfoque con trade-offs explícitos. Triggers: "diseñar", "cómo construyo", "qué enfoque", "propón un diseño", fase de diseño previa a implementar.'
---

# Diseñar

Fase DISEÑAR. **Aún no implementes.**

## Paso 0 — Escalera de simplicidad (filtro previo)

Antes de proponer diseño, pasa la solución por esta escalera y **detente en el
primer peldaño que aguante** (principio `simplicidad-escalera-01`):

1. **¿Esto necesita existir?** Necesidad especulativa → no lo hagas, dilo en una
   línea (YAGNI).
2. **¿La librería estándar lo resuelve?** Úsala.
3. **¿Una feature nativa de la plataforma lo cubre?** (`<input type="date">` en vez
   de una lib, constraint de BD en vez de código, CSS en vez de JS). Úsala.
4. **¿Una dependencia ya instalada lo resuelve?** Úsala. No añadas una nueva por
   lo que unas líneas hacen.
5. **¿Puede ser una línea?** Una línea.
6. **Solo entonces:** el mínimo código que funciona.

La escalera es un reflejo, no una investigación: si dos peldaños sirven, toma el
más alto y sigue. Esto acota el espacio de diseño *antes* de comparar opciones.

No apliques la escalera para recortar salvaguardas: validación en límites de
confianza, manejo de errores que evita pérdida de datos, seguridad, accesibilidad
y la calibración que pide el hardware real nunca se simplifican
(principio `simplicidad-salvaguardas-01`).

## Pasos

1. Consulta mis principios con la skill `consultar-notas` (o lee
   `~/Documents/notes/3-resources/principios.yaml`) y selecciona los que encajen
   por `aplica_a`/`trigger`.
2. Si el repo tiene `CONTEXT.md`/`docs/adr/`, respeta su glosario y decisiones.
3. Aplica la REGLA DE PRECEDENCIA de AGENTS.md:
   - `confirmado` → respétalo y cítalo por `id`.
   - `propuesto`  → aplícalo pero avísame que no lo he validado.
   - sin principio → usa el mejor default y **márcalo como gap** (propón entrada
     en `aprendizaje.yaml`, sin escribir hasta que confirme).
4. Propón 1-2 opciones de diseño con trade-offs. Recomienda una y explica el
   porqué (estoy aprendiendo: enséñame el razonamiento). Prefiere la opción más
   simple de la escalera salvo que un principio mío o una salvaguarda pidan más.
5. Si recomiendas una simplificación deliberada con un techo conocido (un lock
   global, un scan O(n²), una heurística naíf), nómbrala con un comentario
   `# ponytail:` que diga el techo y el camino de upgrade (principio
   `simplicidad-marcador-01`); así se lee como intención, no como descuido.
6. Si la decisión es difícil de revertir y fue un trade-off real, sugiere
   registrar un ADR (lo gestiona la skill `alinear`).

## Cierre

Termina con un plan de implementación en pasos cortos y espera mi visto bueno
antes de pasar a `/skill:implementar` (o a `/skill:tdd` si hay tests de por medio).
