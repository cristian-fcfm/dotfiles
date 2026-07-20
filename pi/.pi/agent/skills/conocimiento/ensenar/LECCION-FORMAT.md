# Formato de lección

Una lección enseña **una sola cosa**, atada al gap que abrió el tema, y se completa
rápido.

Ruta: `~/Documents/notes/3-resources/aprendizaje/<tema-slug>/lecciones/000N-<nombre-en-guiones>.md`

El frontmatter sigue las convenciones del vault para que `zk` la indexe.

```markdown
---
created: 2026-07-16
resource_type: lesson
status: active
tags: [resource, resource/lesson, aprendizaje/<tema-slug>]
---

# <Título: la cosa concreta que enseña, no el tema>

## Por qué esto, ahora

Una o dos líneas atando la lección al gap real: qué decisión de qué proyecto se
tomó a ciegas por no saber esto. Sale de `detectado_en` y `notas` en
`aprendizaje.yaml`.

## La idea

El conocimiento mínimo necesario para la habilidad de esta lección. Solo eso — lo
que sobra se come la memoria de trabajo. Cada afirmación no trivial va con su cita
enlazada.

## Practícalo

La habilidad, no la teoría. Un ejercicio o un caso a resolver. Si es código, que
sea código que se pueda correr. Lo hago yo; tú das feedback en la conversación.

## Fuente primaria

El mejor recurso que encontraste sobre esto — enlace directo, y capítulo o minuto
si aplica. Léelo/míralo: la lección acelera, la fuente enseña.

## Enlaces

- Lección anterior / siguiente: [[000N-...]]
- Notas del vault relacionadas: [[...]]
- Registros que salieron de aquí: [[000N-...]]

---
¿Algo no cuadra? Pregúntamelo en la sesión — soy tu profesor, no un PDF.
```

## Reglas

- **Corta.** Si no se completa en una sentada, son dos lecciones.
- **Citada.** Sin cita, es tu conocimiento paramétrico disfrazado.
- **Anclada.** Si no puedes escribir "Por qué esto, ahora", no tienes misión y la
  lección va a salir abstracta. Pregunta antes de escribirla.
