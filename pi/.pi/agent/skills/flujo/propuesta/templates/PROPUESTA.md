# <slug>

- **Estado**: borrador | aprobada | construida | descartada
- **Fecha**: AAAA-MM-DD

## Problema

Qué duele, para quién, y cómo se nota hoy. El lenguaje del negocio, sin jerga de
implementación. Si no puedo explicarlo en un párrafo, todavía no lo entiendo.

## Solución propuesta

Una frase: el efecto buscado, no el mecanismo.

## Alternativas consideradas

| Opción | Por qué no |
|---|---|
| no hacer nada | … |

Incluye siempre «no hacer nada». Lo que no está descrito aquí, no está decidido: esta
sección es lo que evita rediseñar lo mismo en un año.

## Alcance

Qué entra.

Una propuesta, un motivo: si el alcance encierra dos cambios que se podrían revertir
por separado, son dos propuestas.

## Criterios de aceptación

Cómo sé que está hecho: comportamientos verificables de la solución, en lista. Cada
uno debe poder fallar — «funciona» no es un criterio; «responde en <200ms al p95» sí.
Son la materia prima del contrato del `PLAN.md` y de la verificación final: si un
criterio no es verificable, la propuesta no está cerrada.

## Fuera de alcance

Qué explícitamente no toca esta propuesta.

## Dependencias y preguntas abiertas

Qué tiene que aterrizar antes (otra propuesta, un worktree en vuelo) y qué preguntas
sin resolver bloquean decisiones. Lo que bloquea se escribe, no se descubre a mitad
del build. Si no hay nada, «—».

## Contexto para el plan

Lo que el `PLAN.md` necesita saber pero no es ejecución: zonas del código,
términos de `CONTEXT.md`, ADRs que aplican (enlazados, no copiados), principios por
`id`. El plan lo referencia, no lo duplica.

## Revisiones

Append-only. Cada iteración sobre esta funcionalidad (feedback, lo aprendido durante
el build) añade una entrada y actualiza las secciones afectadas dejando rastro del
cambio:

- **AAAA-MM-DD — <motivo>**: qué cambia del diseño original y por qué.
