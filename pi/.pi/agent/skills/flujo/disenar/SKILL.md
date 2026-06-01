---
name: disenar
description: Propone un diseño de implementación consultando los principios y el contexto del proyecto antes de escribir código. Úsala después de explorar y alinear, para elegir un enfoque con trade-offs explícitos. Triggers: "diseñar", "cómo construyo", "qué enfoque", "propón un diseño", fase de diseño previa a implementar.
---

# Diseñar

Fase DISEÑAR. **Aún no implementes.**

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
   porqué (estoy aprendiendo: enséñame el razonamiento).
5. Si la decisión es difícil de revertir y fue un trade-off real, sugiere
   registrar un ADR (lo gestiona la skill `alinear`).

## Cierre

Termina con un plan de implementación en pasos cortos y espera mi visto bueno
antes de pasar a `/skill:implementar` (o a `/skill:tdd` si hay tests de por medio).
