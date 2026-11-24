# agent-guardrails

- **Estado**: aprobada
- **Fecha**: 2026-11-24
- **Diseño**: `docs/design/agent-guardrails.md`

## Problema

Mis reglas de seguridad para el agente («no hagas push», «no crees PRs», no toques
secretos) viven solo como texto en `AGENTS.md` y en los prompts `/commit`,
`/rama` y `/rama-cerrar`. Se cumplen casi siempre, pero dependen de que el modelo
las obedezca: basta con que una sesión larga pierda contexto, o con que un
subagente sin ese prompt ejecute `git push` o `git reset --hard`, para publicar o
perder trabajo sin que yo haya dicho nada. Hoy no hay nada entre la decisión del
modelo y la ejecución del comando.

## Apetito

Un kaizen: una extensión local de ~70 líneas más su test. Si crece más allá de
eso, recortar reglas, no añadir maquinaria.

## Viaje del usuario

| # | Actor | Hace | El sistema responde |
|---|-------|------|---------------------|
| V1 + | Agente (con UI) | Invoca bash con un comando de alto impacto (`git push`, `gh pr create`, `git reset --hard`, `git clean -f`, `git branch -D`, `git checkout .`/`restore .`, `sudo`, `rm -rf`) | Pausa y me pregunta Sí/No mostrando el comando; con No, el agente recibe el bloqueo y su motivo |
| V2 + | Agente (sin UI: `-p`, subagente) | Lo mismo que V1 | Lo bloquea sin preguntar, con motivo |
| V3 + | Agente | Intenta `write`/`edit` sobre `.env*`, `.git/`, `~/.ssh/` o `~/.pi/agent/auth.json` | Lo bloquea siempre, con motivo |
| V4 + | Agente | Intenta `read` de `.env*`, `~/.ssh/` o `~/.pi/agent/auth.json` | Igual que V1/V2: confirma con UI, bloquea sin ella |
| V5 | Agente | Cualquier otra llamada | Se ejecuta sin fricción ni aviso |
| V6 + | Yo | Abro pi en Linux o en macOS tras `stow -R pi` | La extensión se carga sola, sin tocar `settings.json` |

## Solución y patrón

Un hook determinista antes de ejecutar cada tool, que clasifica la llamada en
permitir / confirmar / bloquear. Patrón: **policy enforcement point** con
**fail-closed** cuando no hay humano para confirmar. Las reglas viven en una
función pura, separada del hook, para poder probarlas sin modelo.

## Decisiones clave

1. Extensión local en `pi/.pi/agent/extensions/`, no paquete npm — mínimo de plugins, código que leo entero.
2. Evento `tool_call` de pi, que puede bloquear antes de ejecutar — es el único punto que no depende del modelo (`agentes-decidir-01`).
3. Confirmar (no bloquear) lo publicable y destructivo — a veces se lo pido de verdad; la puerta soy yo (`agentes-confianza-01`).
4. Sin UI se bloquea — un subagente no puede pedir permiso, y en la duda se falla cerrado.
5. Escritura de secretos y de `.git/` se bloquea siempre — no hay caso legítimo para el agente.
6. Reglas como lista de patrones en un único sitio, probadas con `node --test` — determinismo verificable (`agentes-fiabilidad-01`).

## Alternativas descartadas

| Opción | Por qué no |
|---|---|
| No hacer nada | Las reglas siguen dependiendo de que el modelo obedezca, y los subagentes no las ven |
| Paquete `pi-guardrails` / `pi-steering-hooks` de npm | Más reglas y config de las que necesito; un plugin más que auditar |
| Contenedor / sandbox para pi | Barrera real, pero mucho más coste de setup y fricción diaria; lo dejo como gap de aprendizaje |
| Bloquear todo sin confirmar | Me obliga a salir de pi para cada push que sí quiero |

## Riesgos aceptados

- **No es un sandbox** (`docs/security.md` de pi): `sh -c`, alias, scripts o
  `cat .env` desde bash saltan los patrones. Protege de accidentes, no de un
  ataque ni de prompt injection decidida. Lo acepta Cristian.
- Falsos positivos de patrones (p. ej. `rm -rf` sobre `node_modules`): pago una
  confirmación de más. Lo acepta Cristian.

## Fuera de alcance

- Confirmar `git commit`: `/commit` ya tiene su puerta humana. Se reabre si el
  agente commitea alguna vez sin pedírmelo.
- Comandos que tecleo yo con `!` (evento `user_bash`): son míos.
- Límite de espacio de trabajo (bloquear rutas fuera del repo).
- Subagentes en paralelo: propuesta aparte, `parallel-subagents`.

## Criterios de aceptación

- [ ] **V1**: con UI, el agente pide `git push origin main`; aparece la pregunta con el comando y, respondiendo No, el comando no se ejecuta y el agente ve el motivo.
- [ ] **V1**: lo mismo con `gh pr create`, `git reset --hard`, `git clean -fd`, `git branch -D x`, `git restore .`, `sudo ls` y `rm -rf dir`.
- [ ] **V2**: `pi -p --no-session` pidiendo `git push` termina sin haber ejecutado el push y con el motivo del bloqueo en la salida.
- [ ] **V3**: `write` a `.env`, a `.git/config` y a `~/.pi/agent/auth.json` falla con motivo, con y sin UI.
- [ ] **V4**: `read` de `~/.pi/agent/auth.json` con UI pide confirmación; sin UI falla.
- [ ] **V5**: `git status`, `git diff`, `rm archivo.tmp` y `write` a `src/x.ts` se ejecutan sin pregunta.
- [ ] **V1–V5**: `node --test` sobre la función de reglas pasa con una tabla que cubre cada caso de arriba, sin red ni modelo.
- [ ] **V6**: tras `stow -R pi`, en Linux y en macOS, `~/.pi/agent/extensions/` existe y pi carga la extensión sin errores al arrancar.

## Preguntas abiertas

—

## Referencias

- Doc de pi: `docs/extensions.md` § `tool_call`; `docs/security.md`; ejemplos
  `examples/extensions/permission-gate.ts` y `protected-paths.ts`.
- Inspiración: `mattpocock/skills` → `skills/misc/git-guardrails-claude-code`.
- Reglas actuales en prosa: `pi/.pi/agent/AGENTS.md` (Convenciones),
  `prompts/rama-cerrar.md:9`.
- Principios: `agentes-decidir-01` (confirmado), `agentes-fiabilidad-01`
  (confirmado), `agentes-confianza-01` y `agentes-least-power` (propuestos).

## Revisiones

- **2026-11-24** — nace.
- **2026-11-24** — aprobada; `push --force` solo confirma, como cualquier push; V6 exige Linux y macOS.
