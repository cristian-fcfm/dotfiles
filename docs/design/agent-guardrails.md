# agent-guardrails — diseño

- **Propuesta**: `docs/proposals/agent-guardrails.md` (aprobada el 2026-11-24)
- **Fecha**: 2026-11-24

Lector: un agente. Deriva de la propuesta y no amplía su alcance, criterios ni
riesgos. Lo que ya dice la propuesta se enlaza, no se repite.

## Mapa

- **Decisiones**: D1–D9; las clave de la propuesta (1–6) y las de detalle.
- **Componentes y datos**: tres ficheros, el contrato de `classify` y la tabla de reglas.
- **Comportamiento ante fallos**: todo error falla cerrado.
- **Criterios técnicos**: T1–T9, cada uno con su V#.
- **Notas para el plan**: orden, tracer bullet y cómo verificar sin riesgo.

## Decisiones

- **D1** (clave 1) — Subdirectorio `pi/.pi/agent/extensions/guardrails/` con
  `index.ts`. Pi carga como extensión **cada** `*.ts` suelto de `extensions/`,
  pero de un subdirectorio solo `index.ts`; así `rules.ts` y su test no se cargan
  como extensiones. Fuente: `docs/extensions.md` § Extension Locations.
- **D2** (clave 2) — Un solo handler `pi.on("tool_call")`. Cubre `bash`, `read`,
  `write` y `edit`; el resto de tools se permite sin mirar (V5).
- **D3** (clave 3) — `confirm` usa `ctx.ui.confirm(título, detalle)`; el detalle
  es el comando o la ruta completa, para decidir viendo lo que se ejecuta.
- **D4** (clave 4) — `!ctx.hasUI` (modos `-p` y `json`) convierte todo `confirm`
  en `block`. `ctx.hasUI` es `true` en TUI y RPC (`docs/extensions.md` § Mode
  Behavior).
- **D5** (clave 5) — Escritura de secretos y `.git/` → `block` incluso con UI.
- **D6** (clave 6) — Reglas en `rules.ts`, una función pura sin imports de pi;
  test con `node:test` ejecutable con `node --test` (Node ≥ 22.18 quita los tipos
  de forma nativa). Solo sintaxis TS borrable: sin `enum`, sin `namespace`.
  Imports con extensión `.ts` (jiti y Node los aceptan).
- **D7** (detalle) — Los patrones de bash se buscan en **todo** el comando, no solo
  al principio, para cazar `cd x && git push`. El precio son falsos positivos
  (`git log --grep push`): una confirmación de más, riesgo ya aceptado.
- **D8** (detalle) — «`rm -rf`» de la propuesta se lee como **borrado recursivo**:
  `-r`, `-R`, `--recursive`, con o sin `-f` y en cualquier orden (`-fr`,
  `-r -f`). Un `rm` sin recursión no pide nada (V5).
- **D9** (detalle) — El motivo de bloqueo que ve el agente termina con «No lo
  reintentes por otra vía; pídeselo al usuario». Desalienta rodear el hook con
  `sh -c`; no lo impide (riesgo aceptado en la propuesta).

## Componentes y datos

```
pi/.pi/agent/extensions/guardrails/
├── index.ts       # handler tool_call → classify → confirm/block (~25 líneas)
├── rules.ts       # classify() y patrones (~45 líneas)
└── rules.test.ts  # tabla de casos con node:test
```

Contrato de `rules.ts`:

```ts
export type Verdict =
  | { action: "allow" }
  | { action: "confirm" | "block"; reason: string };

export function classify(
  tool: string,
  input: Record<string, unknown>,
  env: { cwd: string; home: string },
): Verdict;
```

`env` se inyecta para que el test no dependa de la máquina; `index.ts` pasa
`ctx.cwd` y `os.homedir()`.

Reglas:

| Tool | Condición | Veredicto |
|---|---|---|
| `bash` | `git … push` | confirm |
| `bash` | `gh pr create` / `gh pr merge` | confirm |
| `bash` | `git … reset … --hard` | confirm |
| `bash` | `git … clean` con `-f` en sus flags | confirm |
| `bash` | `git … branch … -D` | confirm |
| `bash` | `git … checkout .` / `git … restore .` (con o sin `--`) | confirm |
| `bash` | `sudo` como palabra | confirm |
| `bash` | `rm` recursivo (D8) | confirm |
| `write`, `edit` | ruta secreta o dentro de `.git/` | block |
| `read` | ruta secreta | confirm |
| resto | — | allow |

**Ruta secreta**: basename que casa `^\.env(\..+)?$` (`.env`, `.env.local`; no
`.envrc`), cualquier ruta bajo `<home>/.ssh/`, o exactamente
`<home>/.pi/agent/auth.json`. **Dentro de `.git/`**: algún segmento de la ruta es
exactamente `.git` (`.gitignore` no cuenta).

Normalización de rutas antes de comparar: `~` inicial → `home`; relativa →
`path.resolve(cwd, ruta)`. El campo es `input.path` en las tres tools.

`git …` significa «`git` como palabra y, antes del siguiente `;`, `&`, `|` o salto
de línea, el subcomando»: así casa `git -C dir push` y no salta a otro comando de
la cadena.

## Comportamiento ante fallos

- `classify` lanza una excepción (bug, input raro) → `block` con motivo «error
  interno de guardrails». Falla cerrado.
- `input.command` o `input.path` no son string → `allow`: pi valida los
  argumentos de sus tools antes, así que no llega a ejecutarse nada raro.
- Diálogo cancelado (Esc) → `confirm` devuelve `false` → `block`.
- Sin UI → `block` (D4), con motivo «requiere confirmación y no hay UI».

## Criterios técnicos

- **T1** (V1) — `classify("bash", {command: c})` da `confirm` para cada comando
  del criterio V1 de la propuesta, más `cd x && git push` y `git -C . push`.
- **T2** (V1) — `index.ts` con UI: `confirm` → diálogo; `false` →
  `{ block: true, reason }`; `true` → no devuelve nada (sigue la ejecución).
- **T3** (V2) — Sin UI, todo `confirm` sale como `{ block: true }`. Manual:
  `pi -p --no-session "ejecuta git push --dry-run"` informa del bloqueo.
- **T4** (V3) — `write`/`edit` a `.env`, `sub/.env.local`, `.git/config`,
  `~/.pi/agent/auth.json` y `~/.ssh/id_ed25519` → `block`.
- **T5** (V4) — `read` de esas mismas rutas secretas → `confirm`; `read` de
  `.git/config` → `allow` (leer el repo no es secreto).
- **T6** (V5) — `allow` para `git status`, `git diff`, `git log --oneline`,
  `rm archivo.tmp`, `write` a `src/x.ts`, `read` de `.envrc` y `.gitignore`.
- **T7** (V1–V5) — `node --test pi/.pi/agent/extensions/guardrails/rules.test.ts`
  pasa, sin red ni modelo.
- **T8** (V6) — En Linux y macOS: `stow -R pi` crea `~/.pi/agent/extensions` y
  `pi --list-models` arranca sin errores de extensión.
- **T9** (invariante) — Una excepción dentro de `classify` produce `block`: el
  `try/catch` vive en `index.ts` y se comprueba en `revisar` leyendo el handler
  (son tres líneas; un test necesitaría simular la API de pi).

## Alternativas (detalle)

- **Parser de shell** (`shell-quote`, tree-sitter-bash) en vez de regex: más
  preciso con comillas y subshells, pero una dependencia npm. Se reabre si los
  falsos positivos molestan de verdad.
- **Lista de permitidos** (solo lo conocido pasa): más segura, pero inviable con
  bash libre. Es terreno del gap de aislamiento en `aprendizaje.yaml`.
- **`ctx.ui.select` con «Sí/No»** como el ejemplo `permission-gate`: `confirm` ya
  es Sí/No y más corto.

## Evidencia

- `docs/extensions.md` de pi: § Extension Locations, § `tool_call`, § `ctx.hasUI`,
  § Mode Behavior.
- Ejemplos de pi: `examples/extensions/permission-gate.ts`,
  `protected-paths.ts`.
- `mattpocock/skills`: `skills/misc/git-guardrails-claude-code` (lista de
  comandos git).

## Notas para el plan

1. **Tracer bullet**: `rules.ts` con una sola regla (`git push` → confirm), su test
   en rojo → verde, e `index.ts` cableado; probar en TUI con
   `git push --dry-run` (no publica nada aunque el hook fallara).
2. Resto de reglas de bash, una por ciclo de test (T1, T6).
3. Rutas: normalización + reglas de `write`/`edit`/`read` (T4, T5).
4. Fallo cerrado (T9) y modo sin UI (T3).
5. `stow -R pi` en Linux; anotar en la bitácora que falta verificar en macOS (T8).

- Un solo paquete stow tocado: `pi` → commits con scope `pi`.
- Sin `CONTEXT.md` en el repo; ningún ADR que tocar.
- Gap registrado: «Aislamiento de agentes locales» en `aprendizaje.yaml`.
