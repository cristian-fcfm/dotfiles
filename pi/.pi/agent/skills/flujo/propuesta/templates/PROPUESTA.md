# <slug>

- **Estado**: borrador | aprobada | construida | descartada
- **Fecha**: AAAA-MM-DD

## Problema

Qué duele, para quién, y cómo se nota hoy. El lenguaje del negocio, sin jerga de
implementación. Si no puedo explicarlo en un párrafo, todavía no lo entiendo.

## Viaje del usuario

El flujo que esta propuesta toca, contado paso a paso. Es el **esqueleto de la
propuesta**: criterios, alcance y patrón anclan a sus pasos. Un paso que no se
puede contar como «actor hace → el sistema responde» todavía no está pensado.

| # | Actor | Hace | El sistema responde |
|---|-------|------|---------------------|
| V1 | … | … | … |

Si el viaje ya existe, marca qué pasos cambian (→) y cuáles son nuevos (+). Lo
que no toca ningún paso del viaje, no entra en esta propuesta.

## Solución y patrón

Una frase: el efecto buscado, no el mecanismo. Y **el patrón bajo el que se
implementa**, con nombre: uno conocido (pipeline, event sourcing, repository,
fail-closed, reemplazo atómico de datos derivados…) o «ad hoc» explícito con su
por qué. El patrón es el molde contra el que una persona audita la
implementación: sin patrón nombrado, auditar es leer neblina.

## Alternativas consideradas

| Opción | Por qué no |
|---|---|
| no hacer nada | … |

Incluye siempre «no hacer nada». Los patrones descartados van aquí, no sueltos
en otra sección: lo que no está descrito aquí, no está decidido, y esta sección
es lo que evita rediseñar lo mismo en un año.

## Alcance

Qué entra. El detalle técnico que no se ve en el viaje (esquemas, IaC,
ficheros) en lista corta; el cómo vive en el `PLAN.md`, no aquí.

Una propuesta, un tramo del viaje: si encierra dos cambios que se podrían
revertir por separado, son dos propuestas.

## Criterios de aceptación

Cómo sé que está hecho: comportamientos verificables, cada uno **anclado a un
paso del viaje (V1, V2…) o al viaje completo si es una invariante**, y redactado
para poder fallar — «funciona» no es un criterio. Un criterio sin paso al que
anclar es prosa disfrazada de contrato.

- [ ] **V1**: …
- [ ] **V3**: …responde en <200ms al p95…

## Fuera de alcance

Qué explícitamente no toca esta propuesta.

## Riesgos aceptados

Lo que queda abierto **a sabiendas** y quién lo asume: cada riesgo es una
decisión humana de aceptar, no un pendiente técnico. Si no hay, «—».

## Contexto y bloqueos

Qué tiene que aterrizar antes (otra propuesta, una rama en vuelo) y qué
preguntas sin resolver bloquean decisiones — lo que bloquea se escribe, no se
descubre a mitad del build. Zonas del código, términos de `CONTEXT.md`, ADRs
(enlazados, no copiados), principios por `id`, y evidencia (spikes,
verificaciones): **enlazada, nunca pegada**. Si no hay nada, «—».

## Revisiones

Append-only. Cada iteración sobre esta funcionalidad (feedback, lo aprendido
durante el build) añade una entrada y actualiza las secciones afectadas dejando
rastro del cambio:

- **AAAA-MM-DD — <motivo>**: qué cambia del diseño original y por qué.
