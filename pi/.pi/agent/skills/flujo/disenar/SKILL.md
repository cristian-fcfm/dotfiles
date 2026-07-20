---
name: disenar
description: 'Propone un diseño de implementación consultando los principios y el contexto del proyecto antes de escribir código. Úsala después de explorar y alinear, para elegir un enfoque con trade-offs explícitos. Triggers: "diseñar", "cómo construyo", "qué enfoque", "propón un diseño", fase de diseño previa a implementar.'
---

# Diseñar

Fase DISEÑAR. **Aún no implementes.**

## Paso 0 — Escalera de simplicidad (filtro previo)

Antes de proponer diseño, pasa la solución por la escalera de simplicidad de
`AGENTS.md` y **detente en el primer peldaño que aguante**. Aquí su trabajo es
acotar el espacio de diseño *antes* de comparar opciones: lo que la escalera
descarta no llega a ser una opción que discutamos.

## Pasos

1. Consulta mis principios con la skill `consultar-notas` (o lee
   `~/Documents/notes/3-resources/zk/principios.yaml`) y selecciona los que encajen
   por `aplica_a`/`trigger`.
2. Si el repo tiene `CONTEXT.md`/`docs/adr/`, respeta su glosario y decisiones.
3. Aplica la REGLA DE PRECEDENCIA de AGENTS.md:
   - `confirmado` → respétalo y cítalo por `id`.
   - `propuesto`  → aplícalo pero avísame que no lo he validado.
   - sin principio → usa el mejor default y **márcalo como gap** (propón entrada
     en `aprendizaje.yaml`, sin escribir hasta que confirme).
4. Si el diseño toca terreno que no dominas (una librería, un patrón, una API) o
   yo referencié un repo de ejemplo, investiga antes de proponer: `web_search`
   para contrastar prácticas actuales (cita la fuente) y `fetch_content` para el
   repo de referencia (los de GitHub se clonan localmente — explóralo como código
   real). La investigación acota opciones; no la conviertas en un informe.
5. Propón 1-2 opciones de diseño con trade-offs. Recomienda una y explica el
   porqué (estoy aprendiendo: enséñame el razonamiento). Prefiere la opción más
   simple de la escalera salvo que un principio mío o una salvaguarda pidan más.
6. Si recomiendas una simplificación deliberada con un techo conocido (un lock
   global, un scan O(n²), una heurística naíf), nómbrala con un comentario
   `# YAGNI:` que diga el techo y el camino de upgrade (principio
   `simplicidad-marcador-01`); así se lee como intención, no como descuido.
7. Si la decisión es difícil de revertir y fue un trade-off real, sugiere
   registrar un ADR (lo gestiona la skill `modelo-dominio`).

## Cierre

Termina con un plan de implementación en pasos cortos y espera mi visto bueno antes
de construir. Si hay tests de por medio, lo natural es seguir con `/skill:tdd`.
