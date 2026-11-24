# parallel-subagents

- **Estado**: aprobada
- **Fecha**: 2026-11-24
- **Diseño**: `docs/design/parallel-subagents.md`
- **Depende de**: `agent-guardrails` (los subagentes corren sin UI y confían en su bloqueo)

## Problema

`revisar` me promete dos ejes independientes, Spec y Estándares, «en paralelo, un
agente por eje», pero pi no trae subagentes: hoy los dos ejes los corre el mismo
agente, uno detrás de otro, en el mismo contexto. Lo que leyó para juzgar calidad
contamina su juicio sobre alcance, justo lo que la separación quiere evitar. Lo
mismo pasa con `explorar` en una tarea grande: todo lo leído se queda en el
contexto de la sesión principal, que llega a diseñar ya cargada de ficheros que no
necesita.

## Apetito

Un kaizen: una extensión propia de ~80 líneas, dos definiciones de agente y
retocar dos skills. Si pasa de ~120 líneas, recortar funciones, no añadirlas.

## Viaje del usuario

| # | Actor | Hace | El sistema responde |
|---|-------|------|---------------------|
| V1 → | Yo | Invoco `/skill:revisar` sobre cambios pendientes | El agente lanza dos `revisor` en paralelo, uno por eje, cada uno con contexto limpio; veo la llamada y, al terminar, los resultados (sin progreso en vivo) |
| V2 → | Agente | Recibe los dos informes | Me los presenta en dos secciones, sin mezclarlos ni reordenarlos |
| V3 → | Agente | En `explorar`, la tarea toca zonas independientes | Lanza un `explorador` por zona en paralelo; cada uno devuelve un resumen acotado |
| V4 + | Subagente | Intenta lanzar otro subagente | La tool no existe para él |
| V5 + | Subagente | Intenta `write` o `edit` | La tool no existe para él |
| V6 + | Yo | Pulso Ctrl+C mientras corren | Los procesos hijos terminan y la sesión principal sigue viva |
| V7 + | Yo | Abro pi en Linux o en macOS tras `stow -R pi` | La tool `subagent` y los dos agentes están disponibles sin tocar `settings.json` |

## Solución y patrón

Delegar las tareas **de solo lectura** a procesos pi hijos con contexto aislado,
lanzados a la vez, y unir sus resultados en la sesión principal. Patrón:
**fan-out / fan-in** con trabajadores sin estado. La herramienta es una extensión
propia mínima que solo orquesta la CLI de pi (`pi -p`): no reimplementa nada.

## Decisiones clave

1. Extensión propia en `pi/.pi/agent/extensions/subagent/` (~80 líneas): una tool `subagent` con 1–4 tareas que lanza `pi -p --no-session` por tarea vía `pi.exec` y devuelve las salidas — depende solo de flags documentados de la CLI y de `registerTool`, no de la API de TUI; la entiendo entera y es igual en Linux y macOS vía stow.
2. Solo subagentes de lectura; nada de implementadores en paralelo — trabajo en una rama sin worktrees y con una funcionalidad en vuelo (commit `b2c16b3`).
3. Cada agente declara `tools:` explícitas sin `subagent`, `write` ni `edit` — el límite de recursión y de poder lo pone el harness, no el prompt (`agentes-least-power`).
4. `explorador` con modelo barato (`claude-haiku-5.5`); `revisor` hereda el de la sesión — explorar es volumen, revisar es juicio (`ddia-coste-como-metrica-01`).
5. Solo agentes de usuario (`~/.pi/agent/agents/`), nunca los del proyecto — un repo ajeno no puede inyectar agentes.
6. Paralelo solo entre tareas independientes; lo dependiente sigue en cadena (`agentes-topologia-por-dependencia`).

## Alternativas descartadas

| Opción | Por qué no |
|---|---|
| No hacer nada | `revisar` sigue prometiendo algo que no ocurre y los ejes se contaminan |
| `pi -p … &` desde bash | Sin límite de concurrencia, sin abortar con Ctrl+C, salida sin acotar (`agentes-resultados-acotados`) |
| Paquetes npm (`pi-subagents`, `@williamcr01/pi-subagents`, `chthub/pi-subagents`, `pi-subagent-extension`) | Todos traen async, recursión, sesiones residentes o rutas de modelos ajenas; de ~190 KB a 10.9 MB para lo que caben 80 líneas |
| Vendorizar el ejemplo oficial `subagent` | ~1400 líneas ajenas (streaming, render TUI, modo cadena) que no voy a usar y que se rompen con la API de TUI |
| Cargar el ejemplo por ruta desde la instalación de pi | La ruta difiere entre Linux (`/usr/lib/node_modules`) y macOS (Homebrew/nvm); no es portable |
| `codemode` nativo | Paraleliza tools, no agentes: no aísla contexto |

## Riesgos aceptados

- Sin progreso en vivo ni contador de tokens por hijo: solo veo el resultado al
  final. Se reabre si una revisión tarda tanto que no sé si sigue viva. Lo acepta
  Cristian.
- El código es mío: si un flag de la CLI cambia, lo arreglo yo. Lo acepta
  Cristian.
- `revisor` y `explorador` necesitan `bash` (para `git diff`, `rg`), y con bash se
  puede escribir; solo los cubre `agent-guardrails`. Lo acepta Cristian.
- El coste de los hijos no se suma al contador de la sesión principal. Lo acepta
  Cristian.

## Fuera de alcance

- Implementadores en paralelo y worktrees (tipo `implement-spec` de Matt). Se
  reabre si vuelvo a trabajar con varias funcionalidades en vuelo.
- Paralelizar los ciclos de `/plan-ejecutar`: son secuenciales por diseño. Se
  quita de su texto la mención a «correr esto en paralelo».
- Subagentes en segundo plano o asíncronos, modo cadena y streaming de progreso.
- Agentes definidos por proyecto (`.pi/agents/`).

## Criterios de aceptación

- [ ] **V1**: `/skill:revisar` sobre un diff no vacío hace una sola llamada `subagent` con dos tareas `revisor`, y los dos hijos corren a la vez (tiempo total ≈ el del más lento, no la suma).
- [ ] **V2**: el informe final tiene secciones separadas de Spec y de Estándares, sin un ranking que las mezcle.
- [ ] **V3**: `explorar` sobre una tarea con dos zonas independientes lanza dos `explorador` en paralelo y la salida de cada uno llega truncada a un tope fijo (`agentes-resultados-acotados`).
- [ ] **V3**: una llamada con más de 4 tareas o con un agente inexistente falla antes de lanzar ningún hijo, con motivo.
- [ ] **V4**: un `revisor` al que se le pide «lanza un subagente» no puede hacerlo: la tool no está en su lista.
- [ ] **V5**: un `explorador` al que se le pide editar un fichero no puede: `write`/`edit` no están en su lista y el fichero queda intacto.
- [ ] **V6**: Ctrl+C durante un fan-out no deja procesos `pi` hijos vivos (`pgrep`).
- [ ] **V7**: en Linux y en macOS, tras `stow -R pi`, pi arranca sin errores de extensión y `subagent` aparece entre las tools.
- [ ] **Invariante**: `settings.json` no cambia, no se añade ninguna dependencia npm y la extensión no pasa de ~120 líneas.

## Preguntas abiertas

—

## Referencias

- Doc de pi: `docs/extensions.md` § `pi.exec` y § Custom Tools; `docs/cli.md`
  § Tools y `--print`; referencia de diseño (no se copia):
  `examples/extensions/subagent/`.
- Spike que valida el enfoque: `docs/design/parallel-subagents/spike-pi-print.md`.
- `pi/.pi/agent/skills/flujo/revisar/SKILL.md` § Dos ejes;
  `prompts/plan-ejecutar.md` § 2.
- Inspiración: `mattpocock/skills` → `skills/engineering/code-review` y
  `.out-of-scope/subagent-recursion.md`.
- Principios: `agentes-least-power`, `agentes-topologia-por-dependencia`,
  `agentes-resultados-acotados`, `ddia-coste-como-metrica-01` (propuestos).

## Revisiones

- **2026-11-24** — nace.
- **2026-11-24** — debe funcionar en Linux y macOS: el ejemplo se vendoriza en vez de cargarse por ruta (D1, V7, riesgos).
- **2026-11-24** — vendorizar es demasiado: extensión propia mínima sobre `pi -p` (D1, apetito, alternativas, riesgos, V1, V3, invariante).
- **2026-11-24** — aprobada.
