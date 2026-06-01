---
name: alinear
description: 'Sesión de interrogatorio (grilling) que desafía tu plan contra el modelo de dominio del proyecto, afina la terminología y actualiza la documentación (CONTEXT.md, ADRs) sobre la marcha. Úsala antes de diseñar/implementar para estresar un plan y alinearte con el agente una pregunta a la vez. Triggers: "aliname", "grill", "interrógame", "estresa el plan", "no estoy seguro de qué quiero", antes de construir algo no trivial.'
---

<que-hacer>

Interrógame sin tregua sobre cada aspecto de este plan hasta llegar a un entendimiento compartido. Recorre cada rama del árbol de decisiones, resolviendo dependencias entre decisiones una por una. Para cada pregunta, propón tu respuesta recomendada.

Haz las preguntas **una a la vez**, esperando mi respuesta antes de continuar.

Si una pregunta se puede responder explorando el código, explóralo en vez de preguntarme.

</que-hacer>

<info-de-apoyo>

## Conciencia del dominio

Durante la exploración del código, busca también documentación existente:

### Estructura de archivos

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

Si existe un `CONTEXT-MAP.md` en la raíz, el repo tiene múltiples contextos. El mapa indica dónde vive cada uno (ver [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md)).

Crea los archivos de forma **perezosa (lazy)** — solo cuando tengas algo que escribir. Si no existe `CONTEXT.md`, créalo al resolver el primer término. Si no existe `docs/adr/`, créalo cuando se necesite el primer ADR.

## Durante la sesión

### Desafía contra el glosario

Cuando use un término que choque con el lenguaje existente en `CONTEXT.md`, señálalo de inmediato. "Tu glosario define 'cancelación' como X, pero pareces referirte a Y — ¿cuál es?"

### Afina el lenguaje difuso

Cuando use términos vagos o sobrecargados (overloaded), propón un término canónico preciso. "Dices 'cuenta' — ¿te refieres al Customer o al User? Son cosas distintas."

### Discute escenarios concretos

Cuando se discutan relaciones de dominio, estréstalas con escenarios específicos. Inventa escenarios que sondeen casos borde (edge cases) y me fuercen a ser preciso sobre los límites entre conceptos.

### Cruza con el código

Cuando afirme cómo funciona algo, verifica si el código está de acuerdo. Si hay contradicción, sácala a la luz: "Tu código cancela Orders enteras, pero acabas de decir que la cancelación parcial es posible — ¿cuál es?"

### Actualiza CONTEXT.md sobre la marcha

Cuando se resuelva un término, actualiza `CONTEXT.md` ahí mismo. No lo acumules — captúralo cuando ocurra. Usa el formato de [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` debe estar **totalmente libre de detalles de implementación**. No lo trates como una spec, un borrador ni un repositorio de decisiones de implementación. Es un glosario y nada más.

### Ofrece ADRs con moderación

Ofrece crear un ADR solo cuando las tres condiciones sean ciertas:

1. **Difícil de revertir** — el costo de cambiar de opinión luego es significativo.
2. **Sorprendente sin contexto** — un lector futuro se preguntará "¿por qué lo hicieron así?".
3. **Resultado de un trade-off real** — había alternativas genuinas y elegiste una por razones específicas.

Si falta cualquiera de las tres, omite el ADR. Usa el formato de [ADR-FORMAT.md](./ADR-FORMAT.md).

## Conexión con mi flujo

- Si durante el grilling detectas un área sin principios míos, márcala como gap
  (ver AGENTS.md) y propón registrarla en `aprendizaje.yaml`.
- Tras alinear, lo natural es pasar a `/skill:disenar`.

</info-de-apoyo>
