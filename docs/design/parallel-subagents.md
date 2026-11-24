# parallel-subagents — diseño

- **Propuesta**: `docs/proposals/parallel-subagents.md` (aprobada el 2026-11-24)
- **Fecha**: 2026-11-24
- **Depende de**: `docs/design/agent-guardrails.md` (ya integrado antes de empezar)

Lector: un agente. Deriva de la propuesta y no amplía su alcance, criterios ni
riesgos. Lo que ya dice la propuesta se enlaza, no se repite.

## Mapa

- **Decisiones**: D1–D10; las clave de la propuesta (1–6) y las de detalle.
- **Componentes y datos**: la extensión, la tool, el formato de agente y los dos agentes.
- **Cambios en skills y prompts**: `revisar`, `explorar`, `plan-ejecutar`.
- **Comportamiento ante fallos**: validar antes de lanzar; un hijo que falla no tumba a los demás.
- **Criterios técnicos**: T1–T10, cada uno con su V#.
- **Notas para el plan**: orden y tracer bullet.

## Decisiones

- **D1** (clave 1) — `pi/.pi/agent/extensions/subagent/`: `index.ts` (registro
  de la tool) + `core.ts` (lógica pura con `exec` inyectado) + `core.test.ts`
  (`node:test`), como `extensions/guardrails/`; pi solo carga `index.ts` de un
  subdirectorio. `core.ts` no importa paquetes de pi (no hay `node_modules` en el
  repo): `index.ts` llama a `parseFrontmatter` y pasa el resultado a `core`. El tope
  de ~120 líneas aplica a `index.ts` + `core.ts`, sin tests. Lanza hijos con `pi.exec("pi", args, { cwd, signal, timeout })`: sin
  shell (sin inyección por el texto de la tarea) y con aborto y SIGTERM→SIGKILL
  ya resueltos por pi (`docs/extensions.md` § `pi.exec`). Validado en
  `docs/design/parallel-subagents/spike-pi-print.md`.
- **D2** (clave 2) — Nada en la tool distingue lectura de escritura salvo D3: la
  garantía es que ningún agente puede declarar tools de escritura.
- **D3** (clave 3) — Al cargar un agente, la extensión **rechaza** uno sin
  `tools` o con `subagent`, `write` o `edit`. El límite vive en el código, no solo
  en el `.md`: un agente mal escrito no llega a lanzarse.
- **D4** (clave 4) — Modelo: `model` del frontmatter o, si falta, el de la sesión
  (`${ctx.model.provider}/${ctx.model.id}`). Thinking: `thinking` del frontmatter
  o `ctx.thinkingLevel`. Sin esto el hijo usaría `defaultModel` de
  `settings.json`, no el de la sesión.
- **D5** (clave 5) — Agentes solo desde `path.join(getAgentDir(), "agents")`; el
  nombre debe casar `^[a-z0-9-]+$`, así `../x` no sale del directorio.
- **D6** (clave 6) — Fan-out con `Promise.all` sobre 1–4 tareas (`maxItems: 4` en
  el esquema); sin cola: el tope del esquema ya es el de concurrencia.
- **D7** (detalle) — Args del hijo: `-p --no-session --tools <lista> --model <m>
  --thinking <t> --append-system-prompt <cuerpo del .md>` y, al final, la tarea
  con el prefijo `Tarea:\n`, para que nunca empiece por `-` y se lea como flag.
- **D8** (detalle) — Tope de salida por hijo: 16 KB (cabeza) con marca de
  truncado; 4 × 16 KB cabe holgado en contexto (`agentes-resultados-acotados`).
- **D9** (detalle) — Timeout por hijo: 10 min (`agentes-limites-ejecucion`). Un
  hijo que no converge falla solo, con motivo.
- **D10** (detalle) — `pi` se busca en el `PATH`. Es lo mismo en Linux y macOS
  mientras pi se lance desde la shell; si no está, el error de spawn lo dice.

## Componentes y datos

```
pi/.pi/agent/
├── extensions/subagent/
│   ├── index.ts                   # registro de la tool `subagent`
│   ├── core.ts                    # lógica pura (exec inyectado)
│   └── core.test.ts
└── agents/
    ├── explorador.md
    └── revisor.md
```

**Tool** `subagent`:

- Parámetros: `{ tasks: Array<{ agent: string; task: string }> }`, `minItems: 1`,
  `maxItems: 4` (TypeBox; pi valida antes de `execute`).
- Descripción para el modelo: lanza de 1 a 4 subagentes de solo lectura en
  paralelo, cada uno con contexto limpio; **solo para tareas independientes**;
  el subagente no ve esta conversación, así que `task` lleva rutas, comandos y
  qué devolver.
- Resultado: un bloque por tarea, `### <agent> (i/n)` + stdout o el error.
  `isError: true` solo si fallan todas.

**Formato de agente** (`agents/<nombre>.md`), leído con `parseFrontmatter` de pi:

| Campo | Obligatorio | Uso |
|---|---|---|
| `name` | sí | debe coincidir con el nombre del fichero |
| `description` | sí | qué hace; aparece en la descripción de la tool |
| `tools` | sí | lista separada por comas → `--tools`; sin `subagent`/`write`/`edit` (D3) |
| `model` | no | `proveedor/id`; si falta, el de la sesión (D4) |
| `thinking` | no | si falta, el de la sesión |
| cuerpo | sí | `--append-system-prompt` |

**Agentes**:

- `explorador` — `tools: read, grep, find, ls, bash`,
  `model: github-copilot/claude-haiku-5.5`, `thinking: low`. Prompt: no ve la
  conversación; devuelve ficheros relevantes con `ruta:línea`, cómo encajan y
  riesgos, en ≤ 300 palabras; bash solo para leer (`rg`, `git log`, `git diff`).
- `revisor` — `tools: read, grep, find, ls, bash`, hereda modelo. Prompt: revisa
  **un** eje, el que diga la tarea, y no opina del otro; cada hallazgo con
  severidad, `archivo:línea` y arreglo propuesto; ≤ 400 palabras; bash solo para
  leer.

## Cambios en skills y prompts

- **`skills/flujo/revisar/SKILL.md` § Dos ejes** — Sustituir «se pueden correr en
  paralelo» por la instrucción: una sola llamada `subagent` con dos tareas
  `revisor`. Cada tarea lleva **referencias, no copias**: el comando del diff, la
  ruta de esta skill y la sección del eje a aplicar, y para Spec las rutas de
  `PLAN.md`/propuesta/diseño. Si el eje Spec no aplica, una sola tarea. Después,
  juntar los informes bajo «Spec» y «Estándares» sin reordenarlos (V2). Si la
  tool `subagent` no existe, seguir como hoy, un eje tras otro.
- **`skills/flujo/explorar/SKILL.md` § Pasos** — Si la tarea toca dos o más zonas
  independientes, un `explorador` por zona en una sola llamada `subagent`, y
  luego unir los resúmenes; con una sola zona, explorar sin subagentes.
- **`prompts/plan-ejecutar.md:47-48`** — Quitar «y volver a preguntarlas es lo
  que hace inútil correr esto en paralelo». La regla (no volver a pedir lo ya
  aprobado) se queda.

## Comportamiento ante fallos

- Agente inexistente, nombre inválido, frontmatter incompleto o tools prohibidas
  → la tool falla **antes de lanzar ningún hijo**, con motivo (V3). Todo o nada:
  un lote a medias deja un fan-in incompleto.
- Hijo con exit ≠ 0 → su bloque dice `falló (exit N)` y los últimos 2 KB de
  stderr; los demás hijos siguen. Ejemplo real: modelo inexistente → 400
  `model_not_supported` (spike).
- `pi` no está en el `PATH` → error de spawn en cada bloque.
- Esc (abortar) → `signal` aborta todos los `pi.exec`; los bloques dicen «cancelado».
- Timeout (D9) → igual que exit ≠ 0, con motivo «timeout».
- Bash peligroso dentro de un hijo → lo bloquea `agent-guardrails` (sin UI =
  bloqueo); el hijo lo cuenta en su salida.

## Criterios técnicos

- **T1** (V1) — Un lote de 2 tareas tarda ≈ el hijo más lento, no la suma
  (medido como en el spike).
- **T2** (V2) — `revisar` presenta las secciones «Spec» y «Estándares» con los
  informes tal cual, sin ranking común.
- **T3** (V3) — `explorar` con dos zonas lanza una llamada `subagent` con dos
  tareas `explorador`.
- **T4** (V3) — Una salida de más de 16 KB llega truncada con marca.
- **T5** (V3) — 5 tareas → error de validación del esquema; `agent: "nope"` o
  `"../x"` → error antes de lanzar ningún `pi` (test con `exec` espía: cero lanzamientos).
- **T6** (V4) — Un agente cuyo `.md` declara `subagent` en `tools` es rechazado;
  un `revisor` al que se le pide lanzar un subagente responde que no tiene la
  tool.
- **T7** (V5) — Un `explorador` al que se le pide editar un fichero no puede, y
  el fichero queda intacto (`git status` limpio).
- **T8** (V6) — Esc durante un lote: `pgrep -xa pi` solo lista la sesión padre
  a los 6 s (5 s de gracia de SIGTERM→SIGKILL); los hijos se renombran a `pi`, por
  eso `pgrep -f "pi -p"` no sirve. Medido en el ciclo 6: a +1 s, sin hijos ni nietos.
- **T9** (V7) — En Linux y macOS, tras `stow -R pi`, `~/.pi/agent/extensions/subagent`
  y `~/.pi/agent/agents` existen y la tool `subagent` aparece en una sesión.
- **T10** (invariante) — `git diff pi/.pi/agent/settings.json` vacío por este
  cambio, sin `package.json` en la extensión, y `index.ts` + `core.ts` ≤ ~120 líneas de código (sin blancos, comentarios ni docstrings):
  `cat core.ts index.ts | grep -vE '^\s*$|^\s*(/\*\*|\*|//)' | wc -l`.

## Alternativas (detalle)

- **Pasar la tarea por stdin** (`echo task | pi -p`): evitaría el prefijo de D7,
  pero `pi.exec` no ofrece stdin. Se reabre si el prefijo confunde a los hijos.
- **`--mode json` para tokens y progreso**: es lo que hace el ejemplo oficial; se
  reabre con el riesgo aceptado de «sin progreso en vivo».
- **Buscar el binario como el ejemplo** (`process.execPath` + `argv[1]`): más
  robusto si pi no está en el `PATH`; se reabre si D10 falla en alguna máquina.

## Evidencia

- Spike: `docs/design/parallel-subagents/spike-pi-print.md`.
- Docs de pi: `docs/extensions.md` § `pi.exec`, § Custom Tools, § `ctx.model`;
  `docs/cli.md` § Tools, `--print`, `--append-system-prompt`.
- Referencia de lectura (no se copia): `examples/extensions/subagent/agents.ts`
  (uso de `parseFrontmatter` y `getAgentDir`).

## Notas para el plan

1. **Tracer bullet**: `index.ts` + `core.ts` con una tarea y `explorador.md`; probar con una
   pregunta sobre el repo (T7 de paso).
2. Fan-out con `Promise.all` y el tope del esquema (T1, T5).
3. Validación todo-o-nada y rechazo de tools prohibidas (T5, T6).
4. Truncado, timeout y aborto (T4, T8).
5. `revisor.md` y los cambios en `revisar`, `explorar` y `plan-ejecutar` (T2, T3).
6. `stow -R pi` en Linux; anotar en la bitácora que falta verificar en macOS (T9).

- Un solo paquete stow tocado: `pi`. Commits con scope `pi`; los cambios de skills
  pueden ir en un commit aparte de la extensión, porque el motivo es otro.
- Sin `CONTEXT.md` en el repo; ningún ADR que tocar.
