---
name: consultar-notas
description: 'Busca y recupera conocimiento del vault de notas personales de Cristian en ~/Documents/notes (libros, aprendizajes, principios destilados). Úsala cuando necesites validar una decisión de diseño contra sus principios, saber qué dice un libro o nota que estudió, detectar si un tema es un gap, o citar fuentes de su vault. Triggers: "qué dice mi nota/libro", "según mis principios", "mi vault", validar diseño, buscar contexto. Usa las herramientas zk (búsqueda full-text indexada en markdown) y rg (grep crudo y YAML).'
---

# Consultar notas

El vault de notas de Cristian está en `~/Documents/notes`. Sigue la
estructura PARA (`1-projects`, `2-areas`, `3-resources`) y usa `zk` (zettelkasten)
sobre archivos markdown, más datos estructurados en YAML.

## Cuándo usar esta skill

- Cristian pregunta "¿qué dice mi nota / mi libro sobre X?"
- Necesitas validar una decisión de diseño contra lo que él ha estudiado.
- Quieres más contexto que el que dan los `principios.yaml` (p.ej. el detalle de
  un capítulo de un libro que él resumió).

## Fuentes clave (revisa primero estas)

- `3-resources/principios.yaml` — reglas accionables destiladas (lo más directo).
- `3-resources/aprendizaje.yaml` — temas que aún no domina (gaps).
- `3-resources/*.md` — resúmenes de libros en prosa (ej.
  `designing-data-intensive-applications.md`, `building-applications-with-ai-agents.md`).

## Cómo buscar

Prefiere `zk` para búsqueda semántica/full-text indexada; usa `rg` para grep crudo.

### Búsqueda full-text con zk (desde el vault)

```bash
zk list -W ~/Documents/notes --match "idempotencia" --format full --limit 10
```

### Por tag (ej. solo libros)

```bash
zk list -W ~/Documents/notes --tag "resource/book" --format oneline
```

### Grep directo (rápido, sin índice) sobre todo el vault

```bash
rg -i "replicacion|consistencia" ~/Documents/notes --type md -l
```

### Consultar principios estructurados

```bash
# Principios por dominio
rg -A6 "aplica_a:.*backend" ~/Documents/notes/3-resources/principios.yaml
# Un principio por id
rg -A8 "id: ddia-idempotencia-01" ~/Documents/notes/3-resources/principios.yaml
```

## Reglas

- Cita la fuente (archivo y, si aplica, el `id` del principio o el capítulo).
- Si la búsqueda no devuelve nada, dilo claramente: es probable que sea un **gap**
  (Cristian aún no lo ha estudiado). Sugiere registrarlo en `aprendizaje.yaml`.
- No edites el vault desde esta skill; solo lectura. La escritura va por `/destilar`.
