---
name: propuesta
description: 'Abre, enmienda y cierra la propuesta de una funcionalidad: un pitch corto en docs/proposals/<slug>.md que yo audito, y tras mi OK su diseño detallado en docs/design/<slug>.md para los agentes. Es la entrada del flujo.'
argument-hint: "<la idea o funcionalidad | slug de la propuesta>"
disable-model-invocation: true
---

# Propuesta

Entrada del flujo: aquí nace el trabajo, aquí se decide el porqué.

Tres capas, cada una con su lector y su ciclo de vida:

| Capa | Vive en | Lector | Contiene | Ciclo de vida |
|---|---|---|---|---|
| Propuesta | `docs/proposals/<slug>.md` | **yo** | el PORQUÉ y el QUÉ: problema, viaje, decisiones clave, riesgos, criterios | nace, se aprueba y se cierra en el flujo |
| Diseño | `docs/design/<slug>.md` | agente | el detalle: decisiones numeradas, datos, fallos, criterios técnicos, evidencia enlazada | se genera tras aprobar; sobrevive a la rama |
| `PLAN.md` | raíz del repo, ignorado por git | agente | el CÓMO ejecutable: contrato, ciclos, bitácora | muere al integrar |

El motivo de partir propuesta y diseño: un documento que sirve a la vez a una
persona que decide y a un agente que construye acaba demasiado largo para auditarlo
y se aprueba sin leer, que es peor que no escribirlo. La propuesta es lo que **yo**
apruebo; el diseño se deriva de ella y no puede ampliarla.

**Referencias, no copias**, en las tres capas: cada capa enlaza a la anterior y a la
evidencia (ADRs, spikes, `ruta:línea`) en vez de repetirla. Así cada lector carga
solo lo que necesita y el contexto del agente no se llena de material que no va a
usar.

## 1. Nacer

La propuesta nace **aquí**, de lo que te cuento: una idea, una mejora, deuda técnica,
un bug.

Si el argumento es el slug de una propuesta existente, es una iteración: lee
`docs/proposals/<slug>.md` y salta al paso 5.

## 2. Pensar antes de escribir

La propuesta no es transcripción de lo que te dije: es su destilado **con las
decisiones**. Según el tipo de trabajo:

- **Bug** → skill `diagnose` primero; su post-mortem alimenta la propuesta.
- **Feature** → `explorar` y, si el diseño tiene trade-offs reales, `alinear` +
  `disenar`.

Respeta la REGLA DE PRECEDENCIA de `AGENTS.md`: cita principios por `id`, marca gaps.

## 3. Escribir la propuesta (para mí)

En `docs/proposals/<slug>.md` del repo donde trabajas (crea el directorio si no
existe). Formato: [templates/PROPUESTA.md](./templates/PROPUESTA.md).

Reglas:

- **Presupuesto**: ≤ ~100 líneas, tope duro 150 (`wc -l`). Se audita de una sentada.
  Si no cabe, o sobran decisiones (más de 7 clave), el viaje tiene tramos que se
  podrían revertir por separado: **son dos propuestas**. Propón el corte en vez de
  comprimir.
- **La evidencia se enlaza, nunca se pega**: tablas de verificación, cifras de un
  spike, esquemas y código van a su fichero (ADR, nota de spike, el diseño) o se
  citan como `ruta:línea`.
- **El viaje del usuario es el esqueleto**: el flujo que toca, paso a paso (actor
  hace → el sistema responde). Criterios y alcance anclan a sus pasos; lo que no
  toca ningún paso, no entra.
- **La solución viaja con su patrón**: nombre conocido o «ad hoc» explícito. Es el
  molde contra el que una persona audita la implementación.
- El slug, en kebab-case y en inglés (tradúcelo si la idea viene en español), es el
  que luego usarán el diseño y `/rama`: una funcionalidad, un slug en las tres capas.
- «Alternativas descartadas» incluye siempre «no hacer nada»; aquí solo las que de
  verdad compitieron, el resto va al diseño.
- «Criterios de aceptación» son comportamientos verificables, cada uno anclado a un
  paso (V#) o al viaje completo si es una invariante, y cada uno debe poder fallar.
  Sin ellos no hay contrato: no me muestres la propuesta sin ellos.
- Lo que no se sabe se escribe como **pregunta abierta**, no se adivina.
- Decisiones difíciles de revertir: su sitio es un ADR (skill `modelo-dominio`) y la
  propuesta lo enlaza.

## 4. Puerta humana

Antes de enseñármela, pásala por estas preguntas:

- ¿Cabe en el presupuesto (`wc -l`) y la puedo auditar de una sentada?
- ¿Es un solo tramo del viaje, no tres disfrazados de uno?
- ¿Cada paso del viaje es actor-hace → sistema-responde, y cada criterio ancla a un
  paso (o al viaje completo)?
- ¿El patrón está nombrado —o «ad hoc» explícito—?
- ¿Lo que queda fuera está tan explícito como lo que entra, y cada riesgo aceptado
  tiene quién lo acepta?
- ¿Los criterios se pueden marcar uno a uno, no solo describir?
- ¿La evidencia está enlazada y no pegada?

Si algo no pasa, la propuesta está a medio cocer: lo ambiguo se resuelve con
`alinear`, no se adivina. Enséñamela solo en verde.

Con mi OK su estado pasa a `aprobada`. **Hasta entonces no se escribe el diseño.**

## 5. Generar el diseño (para el agente)

Con la propuesta aprobada, escribe `docs/design/<slug>.md` con
[templates/DISENO.md](./templates/DISENO.md) y enlázalo desde la cabecera de la
propuesta. Aquí aterriza el cierre de `disenar` y la spec conversada de `sdd`.

Reglas:

- **Deriva, no amplía**. El diseño detalla la propuesta aprobada. Si al detallar
  aparece alcance nuevo, un criterio que no sale de ninguno de la propuesta, un
  riesgo nuevo o una decisión clave que cambia: **para**, enmienda la propuesta
  (paso 6) y vuelve a la puerta humana. Es lo que mantiene válido lo que aprobé.
- **Referencia, no repite**: lo que ya dice la propuesta se enlaza.
- **Carga progresiva**: secciones cortas que un agente puede leer por separado, un
  «Mapa» al principio, evidencia en su fichero (`docs/design/<slug>/` si no tiene
  otro sitio natural) o en el código como `ruta:línea`.
- Sin tope de líneas, pero el mismo criterio que Google para un *design doc*: si
  supera lo que se lee en una sesión, el problema pide partirse.

Test de entrega: ¿otro agente, leyendo solo propuesta, diseño y repo, sabría qué
construir sin preguntarme nada que afecte al alcance o a los criterios?

No necesito leer el diseño línea a línea; dime en tres líneas qué añadió y si tocó
algo que me afecte. El siguiente paso es `/rama`, que referencia ambos desde la
cabecera del plan — **los referencia, no los copia**.

## 6. Iterar (enmendar)

Feedback mío o lo aprendido durante el build:

- Si cambia alcance, decisiones clave, riesgos o criterios → se enmienda la
  **propuesta** (y vuelve a mi puerta), luego el diseño.
- Si solo cambia el detalle → se enmienda el **diseño**.

En la propuesta, cada iteración añade **una línea** a «Revisiones» (fecha — qué
cambió); el porqué largo va al diseño o al mensaje de commit. La historia no se
reescribe: se apila.

## 7. Cerrar

`/rama-cerrar` marca la propuesta como `construida` (o `descartada`, con motivo en
«Revisiones»). El diseño no lleva estado propio: hereda el de la propuesta.
