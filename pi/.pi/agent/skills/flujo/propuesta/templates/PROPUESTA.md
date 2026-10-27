# <slug>

- **Estado**: borrador | aprobada | construida | descartada
- **Fecha**: AAAA-MM-DD
- **Diseño**: `docs/design/<slug>.md` (se genera tras aprobar; hasta entonces «—»)

Presupuesto: ≤ ~100 líneas, tope duro 150; se audita de una sentada (~10 min). Si
no cabe, no falta espacio: son dos propuestas, o hay detalle que pertenece al
diseño. La evidencia se **enlaza**, nunca se pega.

## Problema

Qué duele, para quién, y cómo se nota hoy, en lenguaje de negocio. Mejor **una
historia concreta** que muestre por qué el estado actual no funciona que una lista
de síntomas. Un párrafo; si no cabe, todavía no lo entiendo.

## Apetito

Opcional. Cuánto vale la pena invertir (días, ciclos) y qué recorta de la solución.
Si no aplica, «—».

## Viaje del usuario

El esqueleto: criterios y alcance anclan a sus pasos. Marca qué pasos cambian (→)
y cuáles son nuevos (+). Lo que no toca ningún paso, no entra.

| # | Actor | Hace | El sistema responde |
|---|-------|------|---------------------|
| V1 | … | … | … |

## Solución y patrón

Dos a cinco líneas: el efecto buscado, no el mecanismo. Y **el patrón** con nombre
(fail-closed, reemplazo atómico de datos derivados, repository…) o «ad hoc»
explícito con su porqué: es el molde contra el que se audita la implementación.

## Decisiones clave

Las que, si cambian, cambian el diseño. **Máximo 7**, una línea cada una:
decisión — porqué. Más de 7 es la señal de que son dos propuestas.

1. … — …

## Alternativas descartadas

Las 3–5 que de verdad compitieron, incluida «no hacer nada». Una línea de porqué.
El resto, con su detalle, vive en el diseño.

| Opción | Por qué no |
|---|---|
| No hacer nada | … |

## Riesgos aceptados

Lo que queda abierto a sabiendas y **quién lo acepta**. Si no hay, «—».

## Fuera de alcance

Lo que explícitamente no entra (*no-gos*), con condición de reapertura si la hay.

## Criterios de aceptación

Comportamientos verificables, cada uno anclado a un paso (V#) o al viaje completo
si es una invariante, y redactado para poder fallar. Unos 10 como mucho: los
técnicos finos los deriva el diseño de estos, no al revés.

- [ ] **V1**: …

## Preguntas abiertas

Lo que bloquea decidir o construir (*rabbit holes*): con quién se resuelve y si
bloquea el diseño o solo la entrega. Si no hay, «—».

## Referencias

Enlaces, no copias: ADRs, spikes, notas de verificación, `ruta:línea` del código,
principios por `id`, términos de `CONTEXT.md`. Si no hay, «—».

## Revisiones

Append-only, **una línea por iteración**: fecha — qué cambió. El porqué largo va al
diseño o al mensaje de commit, no aquí.

- **AAAA-MM-DD** — nace.
