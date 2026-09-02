# <tipo>/<slug>

- **Rama**: `<tipo>/<slug>`
- **Base**: `<base>` en `<sha corto>`
- **Origen del plan**: propuesta | sdd | tdd | kaizen
- **Propuesta**: `docs/proposals/<slug>.md` (si existe; si no, «—»)

## Objetivo

Una frase: el efecto para mí, no el mecanismo.

## Fuera de alcance

Explícito: lo que NO se toca aquí.

## Contexto

**Referencia la propuesta, no la copies**: si existe, un enlace basta y esta sección
queda solo con lo que la propuesta no puede saber — ficheros concretos a tocar y qué
hace falta para arrancar. Si no hay propuesta: ficheros a tocar,
términos de `CONTEXT.md`, ADRs que aplican, principios por `id`.

## Contrato

Gherkin en bloque de código, o lista de comportamientos observables.

## Ciclos

Uno por comportamiento, en orden. Esta tabla es el estado en disco.

| # | Comportamiento | Test | Estado |
|---|----------------|------|--------|
| 1 | …              | `ruta::nombre` | pendiente |

## Verificación

Comandos literales de test y lint, copiables.

## Puertas humanas

Dos listas, ambas explícitas.

**Ya aprobado** (no vuelvas a preguntármelo): el diseño, las interfaces públicas, la
lista de comportamientos y su orden. Se aprobó al escribir este plan.

**Para aquí y espérame**: cambiar el contrato de arriba, tocar ficheros fuera de
«Contexto», instalar una dependencia nueva, cualquier cosa irreversible, y el
`/commit` de cada ciclo.

## Bitácora

Append-only: qué se hizo, en qué ciclo, qué se aprendió.
