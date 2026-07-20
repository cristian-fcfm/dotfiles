---
name: modelo-dominio
description: 'Afila el lenguaje del dominio de un proyecto y registra las decisiones difíciles de revertir: desafía términos difusos contra el glosario, los cruza con el código y mantiene CONTEXT.md y docs/adr/ al día. Úsala cuando aparezca terminología ambigua o sobrecargada, cuando el lenguaje del código y el de la conversación se contradigan, o cuando una decisión de arquitectura merezca quedar registrada. Triggers: "modelo de dominio", "glosario", "lenguaje ubicuo", "qué significa este término", "esto merece un ADR", términos vagos o usados con dos sentidos.'
---

# Modelo de dominio

Construyes y afilas el lenguaje del proyecto. Es trabajo **activo**: desafiar
términos, estresarlos con escenarios y escribir. Leer `CONTEXT.md` para saber cómo
se llama algo no es esta skill — es solo leer un archivo.

## Estructura de archivos

La mayoría de repos tienen un solo contexto:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-orders-event-sourced.md
│       └── 0002-postgres-para-write-model.md
└── src/
```

Si existe un `CONTEXT-MAP.md` en la raíz, el repo tiene múltiples contextos. El mapa
indica dónde vive cada uno (ver [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md)).

Crea los archivos de forma **perezosa (lazy)** — solo cuando tengas algo que
escribir. Si no existe `CONTEXT.md`, créalo al resolver el primer término. Si no
existe `docs/adr/`, créalo cuando se necesite el primer ADR.

## Afilar el lenguaje

### Desafía contra el glosario

Cuando use un término que choque con el lenguaje existente en `CONTEXT.md`,
señálalo de inmediato. "Tu glosario define 'cancelación' como X, pero pareces
referirte a Y — ¿cuál es?"

### Da un término canónico a lo difuso

Cuando use términos vagos o sobrecargados (overloaded), propón un término canónico
preciso. "Dices 'cuenta' — ¿te refieres al Customer o al User? Son cosas distintas."

### Discute escenarios concretos

Cuando se discutan relaciones de dominio, estréstalas con escenarios específicos.
Inventa escenarios que sondeen casos borde (edge cases) y me fuercen a ser preciso
sobre los límites entre conceptos.

### Cruza con el código

Cuando afirme cómo funciona algo, verifica si el código está de acuerdo. Si hay
contradicción, sácala a la luz: "Tu código cancela Orders enteras, pero acabas de
decir que la cancelación parcial es posible — ¿cuál es?"

### Escribe en el momento

Cuando se resuelva un término, actualiza `CONTEXT.md` ahí mismo. No lo acumules —
captúralo cuando ocurra. Usa el formato de [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` debe estar **totalmente libre de detalles de implementación**. No lo
trates como una spec, un borrador ni un repositorio de decisiones de
implementación. Es un glosario y nada más.

## ADRs (con moderación)

Ofrece crear un ADR solo cuando las tres condiciones sean ciertas:

1. **Difícil de revertir** — el costo de cambiar de opinión luego es significativo.
2. **Sorprendente sin contexto** — un lector futuro se preguntará "¿por qué lo
   hicieron así?".
3. **Resultado de un trade-off real** — había alternativas genuinas y elegiste una
   por razones específicas.

Si falta cualquiera de las tres, omite el ADR. Usa el formato de
[ADR-FORMAT.md](./ADR-FORMAT.md).
