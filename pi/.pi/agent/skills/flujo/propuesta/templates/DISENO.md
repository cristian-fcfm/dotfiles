# <slug> — diseño

- **Propuesta**: `docs/proposals/<slug>.md` (aprobada el AAAA-MM-DD)
- **Fecha**: AAAA-MM-DD

Lector: un agente. Se deriva de la propuesta aprobada y **no amplía** su alcance,
criterios ni riesgos: si al detallar aparece algo así, para y enmienda la propuesta.
Lo que ya está en la propuesta se referencia, no se repite. Carga progresiva:
secciones cortas que se leen por separado, y la evidencia en su propio fichero o en
el código, enlazada (ruta, `ruta:línea`, ADR).

## Mapa

Índice de una línea por sección, para que el agente cargue solo la que necesita.

## Decisiones

Numeradas (D1, D2…). Cada una: qué se decide, porqué, qué alternativa sustituye,
principio por `id` o gap. Las decisiones clave de la propuesta se expanden aquí con
el mismo orden; las nuevas son de detalle y no cambian el alcance.

## Componentes y datos

Qué piezas cambian o nacen (módulos, esquemas, IaC) y sus contratos entre sí. Los
esquemas y ejemplos de código, solo si no existen ya en el repo; si existen,
`ruta:línea`.

## Comportamiento ante fallos

Qué pasa en cada error relevante: falla abierto/cerrado, reintentos, mensaje al
usuario.

## Criterios técnicos

Derivados de los criterios de la propuesta: cada uno indica de cuál (V#) sale.
Un criterio técnico sin padre en la propuesta es alcance nuevo → vuelve a la
propuesta.

## Alternativas (detalle)

Las descartadas que no caben en la propuesta, con su condición de reapertura.

## Evidencia

Solo enlaces: spikes, verificaciones, mediciones (`docs/design/<slug>/…` si no
tienen otro sitio natural), ADRs, docs externas.

## Notas para el plan

Ficheros a tocar, orden por dependencias, *tracer bullet* sugerido, términos de
`CONTEXT.md`, ADRs que tocar o crear, gaps detectados.
