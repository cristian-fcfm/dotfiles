---
name: propuesta
description: 'Abre, enmienda y cierra la propuesta de diseño de una funcionalidad: docs/proposals/<slug>.md, versionada en el repo. Es la entrada del flujo: la propuesta nace aquí, se enmienda por iteraciones y se cierra al integrar.'
argument-hint: "<la idea o funcionalidad | slug de la propuesta>"
disable-model-invocation: true
---

# Propuesta

Entrada del flujo: aquí nace el trabajo, aquí se decide el porqué.

Dos capas, cada una con su dueño y su ciclo de vida:

| Capa | Vive en | Contiene | Ciclo de vida |
|---|---|---|---|
| Propuesta | `docs/proposals/<slug>.md`, rama base | el PORQUÉ: problema, alternativas, alcance | **nace y se cierra en el flujo** |
| `PLAN.md` | la raíz del repo, ignorado por git | el CÓMO: contrato, ciclos, bitácora | muere al integrar |

La propuesta es la **fuente de verdad del diseño**: sobrevive a la rama para poder
iterar sobre la funcionalidad sin rediseñar desde cero, y adelgaza el plan (que la
referencia, no la copia).

## 1. Nacer

La propuesta nace **aquí**, de lo que te cuento: una idea, una mejora, deuda técnica,
un bug.

Si el argumento es el slug de una propuesta existente, es una iteración: lee
`docs/proposals/<slug>.md` y salta al paso 4.

## 2. Diseñar antes de escribir

La propuesta no es transcripción de lo que te dije: es su destilado **con las
decisiones**. Según el tipo de trabajo:

- **Bug** → skill `diagnose` primero; su post-mortem alimenta la propuesta.
- **Feature** → `explorar` y, si el diseño tiene trade-offs reales, `alinear` +
  `disenar`. El cierre de `disenar` aterriza en este mismo fichero.

Respeta la REGLA DE PRECEDENCIA de `AGENTS.md`: cita principios por `id`, marca gaps.

## 3. Escribir la propuesta

En `docs/proposals/<slug>.md` del repo donde trabajas (crea el directorio si no
existe). Formato: [templates/PROPUESTA.md](./templates/PROPUESTA.md). Markdown plano:
su lector principal es un agente.

Reglas:

- El detalle sigue al riesgo y a la ambigüedad, no a la plantilla: una propuesta
  pequeña puede ser ocho líneas; lo que no puede ser es ambigua en lo que arriesga.
- El slug, en kebab-case, es el que luego usará `/rama`: una funcionalidad, un
  slug en ambas capas (propuesta, plan).
- «Alternativas consideradas» es la sección más valiosa: incluye la opción de «no
  hacer nada». Lo que no está descrito, no está decidido.
- «Criterios de aceptación» son comportamientos verificables — cada uno debe poder
  fallar. Sin ellos no hay contrato posible: no me muestres la propuesta sin ellos.
- La propuesta es **producto, no andamiaje**: se commitea en la rama base (con
  `/commit`, cuando yo lo pida) y debe existir antes de abrir la rama.
- Decisiones difíciles de revertir que salgan aquí no se duplican: su sitio es un ADR
  (skill `modelo-dominio`), y la propuesta lo enlaza.

## 4. Iterar (enmendar)

Sobre una propuesta ya escrita —feedback mío, lo aprendido durante el build— cada
iteración **añade** una entrada a «Revisiones» con fecha y motivo, y actualiza las
secciones afectadas dejando rastro del cambio. La historia de por qué se decidió algo
no se reescribe: se apila.

## 5. Puerta humana

Antes de enseñármela, pásala por el test de entrega — es la misma prueba de
autocontención que el `PLAN.md`, un escalón antes:

- ¿Otro agente, leyendo solo la propuesta y el repo, entendería qué construir sin
  preguntarme nada que afecte al alcance o a los criterios?
- ¿Lo que queda fuera está tan explícito como lo que entra?
- ¿Los criterios se pueden marcar uno a uno, no solo describir?
- ¿Es un solo motivo de cambio, no tres disfrazados de uno?

Si algo no pasa, la propuesta está a medio cocer: lo ambiguo se resuelve con
`alinear`, no se adivina. Enséñamela solo en verde.

Con mi OK, su estado pasa a `aprobada` y el siguiente paso es `/rama`, que la
referencia desde la cabecera del plan — **la referencia, no una copia**.

## 6. Cerrar

El cierre de la propuesta vive en el flujo: `/rama-cerrar` marca su estado como
`construida` (o `descartada`, con motivo en «Revisiones»).
