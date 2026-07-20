---
name: alinear
description: 'Interrogatorio a una pregunta a la vez para estresar un plan antes de construirlo.'
disable-model-invocation: true
---

# Alinear

<que-hacer>

Interrógame sin tregua sobre cada aspecto de este plan hasta llegar a un entendimiento compartido. Recorre cada rama del árbol de decisiones, resolviendo dependencias entre decisiones una por una. Para cada pregunta, propón tu respuesta recomendada.

Haz las preguntas **una a la vez**, esperando mi respuesta antes de continuar.

Si una pregunta se puede responder explorando el código, explóralo en vez de preguntarme. Si depende de información externa (docs de una librería, prácticas actuales, un repo de referencia), usa `web_search`/`fetch_content` en vez de responder de memoria.

</que-hacer>

<info-de-apoyo>

## Alcance

Sirve para cualquier plan: una feature, un refactor, una decisión de infra, una idea
a medio formar. No hace falta que haya dominio de negocio de por medio.

## Investigación externa

- Suelo referenciar un repo como ejemplo de lo que quiero. Cuando lo haga, pásale la
  URL a `fetch_content`: los repos de GitHub se clonan localmente, así que explóralo
  como código real y extrae de ahí las decisiones relevantes para el grilling.
- Antes de recomendar una respuesta sobre terreno que no dominas (una librería, un
  patrón, una API), contrasta con `web_search` en vez de confiar en tu memoria. Cita
  la fuente al proponerla.
- La investigación alimenta las preguntas, no las reemplaza: sigue siendo una
  pregunta a la vez.

## Cuando el lenguaje se vuelve el problema

Si durante el interrogatorio aparecen términos difusos, sobrecargados o que chocan
con el `CONTEXT.md` del repo, cambia de marcha y usa la skill `modelo-dominio`: ahí
vive la disciplina de afilar el glosario y de decidir si algo merece un ADR. No
arrastres esa maquinaria si el plan no la pide.

## Conexión con mi flujo

- Si durante el grilling detectas un área sin principios míos, márcala como gap
  (ver AGENTS.md) y propón registrarla en `aprendizaje.yaml`.
- Tras alinear, lo natural es pasar a `/skill:disenar`.

</info-de-apoyo>
