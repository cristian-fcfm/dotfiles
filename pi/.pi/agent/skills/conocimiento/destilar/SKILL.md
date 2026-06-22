---
name: destilar
description: 'Convierte una nota o aprendizaje del vault de Cristian en prosa en principios accionables estructurados (principios.yaml) para que el agente los aplique. Úsala tras estudiar un libro/tema o cuando quieras cerrar un gap de aprendizaje. Triggers: "destilar", "convertir mi nota en principios", "actualizar principios.yaml", "cerrar un gap".'
---

# Destilar

Conviertes conocimiento en prosa de mi vault en principios accionables para el agente.

## Entrada

Una ruta a una nota en `~/Documents/notes`, o un tema. Si es un tema, usa la skill
`consultar-notas` para encontrar la nota.

## Pasos

1. Lee la nota/fuente indicada.
2. Extrae solo lo **accionable durante el desarrollo** (heurísticas, no teoría).
   Descarta lo puramente descriptivo.
3. Para cada heurística, propón un record con el schema de `principios.yaml`:
   `id`, `principio` (imperativo), `fuente`, `estado: propuesto`, `aplica_a`,
   `trigger`, `severidad`, y `por_que` si ayuda.
   - `id` estable y único; evita colisiones con los existentes.
   - Arranca siempre en `estado: propuesto` (yo lo subo a `confirmado` al validar).
4. Muéstrame los records propuestos y **espera mi confirmación** antes de escribir.
5. Tras confirmar: añádelos a `~/Documents/notes/3-resources/zk/principios.yaml`.
6. Si esta nota cierra un gap, actualiza la entrada correspondiente en
   `~/Documents/notes/3-resources/zk/aprendizaje.yaml` a `estado: destilado`.

## Regla

No inventes principios que la fuente no respalde. Si algo es opinión mía y no del
libro, márcalo en `fuente` como `experiencia`.
