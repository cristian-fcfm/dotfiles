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

1. Consulta mis principios por dominio con la skill `consultar-notas`
   (`principios.sh <dominios de esta tarea>`: los `general` van siempre incluidos) y
   selecciona los que encajen
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

Antes del plan, aterriza el diseño en disco: `docs/proposals/<slug>.md` con el formato
de la skill `propuesta` (problema, alternativas consideradas, alcance). Si llegaste
aquí vía `/skill:propuesta`, ese fichero ya existe: amplíalo. El diseño no vive en el
chat — es la regla del flujo entero, y aquí es donde más se pierde.

Luego termina con un plan de implementación en pasos cortos y espera mi visto bueno
antes de construir.

Y no lo dejes en una lista plana: **clasifica cada paso**, porque de eso depende cuánto
trabajo se puede paralelizar.

- **Ciclo** — un comportamiento observable dentro de la misma funcionalidad. Va como
  fila en el `PLAN.md` de un worktree.
- **Funcionalidad propia** — tiene su motivo de cambio, su worktree y su plan. Señales:
  se podría revertir sola, se entrega sola, o toca una zona del código sin relación con
  el resto.

Si sale más de una funcionalidad, dame el **orden por dependencias**: cuál desbloquea a
cuál, y cuáles son independientes entre sí —esas son las que pueden ir en paralelo, un
agente por worktree—. Marca también qué ficheros toca cada una, para poder detectar
solapes antes de abrir dos worktrees que se pisen.

Prefiere el primer paso más fino que ya cruce el sistema de punta a punta (*tracer
bullet*) antes que uno grande que lo deje todo a medias.

Con el plan aprobado, aterrízalo en disco antes de tocar código: `/worktree` abre el
worktree de cada funcionalidad y transcribe ahí su parte ejecutable como `PLAN.md`,
referenciando la propuesta. Ese fichero es desde entonces la fuente de verdad —no esta
conversación—, y de él se construye, con `/skill:tdd` si hay tests de por medio.
