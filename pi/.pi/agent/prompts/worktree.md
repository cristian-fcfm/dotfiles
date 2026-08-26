---
description: Abrir un worktree aislado para una funcionalidad, con su plan ejecutable
argument-hint: [la funcionalidad que voy a construir]
---

Abre un worktree para la funcionalidad que te describo en el argumento. Una
funcionalidad = un worktree = una rama = un plan. Enséñame el plan y espera mi OK antes
de crear nada. No hagas push.

La idea: el checkout principal se queda siempre en la rama base, limpio y utilizable,
mientras el trabajo sucio vive aparte. Eso me deja saltar entre cosas sin `stash`, y
sobre todo me deja **lanzar otro agente por worktree**: si el plan está bien
escrito, ejecutarlo no necesita el contexto de la conversación en la que se diseñó.

## Dónde no aplica

En repos de **configuración viva** (dotfiles con stow) no uses este flujo: los symlinks
de `~` apuntan al checkout principal, así que un worktree no es la copia que el sistema
lee y no podría probar nada en vivo. Si detectas que el repo es de ese tipo, dímelo y
trabajamos sobre la rama base directamente.

## 1. Comprobaciones previas

- **¿Estoy ya dentro de un worktree?** Compara `git rev-parse --git-dir` con
  `--git-common-dir`: si difieren, estás en uno. No anides: vuelve al principal
  (el primero de `git worktree list`) antes de crear otro.
- **Rama base**: `dev`, siempre. Llámala `<base>`.
- **¿Está `<base>` al día?** `git fetch origin` (solo lee, no publica nada). Si va por
  detrás de `origin/<base>`, avísame: partir de una base vieja se paga al integrar.
  Actualiza con `git merge --ff-only` si te lo confirmo.
- **¿Hay cambios sin commitear en el principal?** No se mueven solos al worktree nuevo.
  Si son de esta funcionalidad, dime cuál de las dos:
  - commitearlos donde están (con `/commit`), o
  - `git stash` aquí y `git stash pop` dentro del worktree ya creado.
  Nunca los descartes ni los arrastres a la rama nueva por tu cuenta.
- **¿Choca con lo que ya está en vuelo?** Para cada worktree vivo (`git worktree list`),
  lee la sección «Contexto → ficheros a tocar» de su `PLAN.md` y crúzala con los
  ficheros que va a tocar esta funcionalidad. Si hay solape, dímelo **antes de crear**
  con la lista concreta: dos agentes editando el mismo fichero en paralelo se paga
  entero al integrar el segundo. Con solape, las salidas son esperar a que cierre el
  otro, o reducir el alcance de este para no pisarlo. La decisión es mía.

## 2. Nombre

Del argumento sacas un slug corto en kebab-case, sin tildes: la funcionalidad, no el
mecanismo (`toggle-monitores`, no `arreglar-script-bash`).

- **Rama**: `<tipo>/<slug>`, con el mismo `tipo` de Conventional Commits que usarás al
  commitear: `feat/`, `fix/`, `refactor/`, `docs/`, `chore/`. Si no tienes claro cuál
  es, es que la funcionalidad no está clara: pregúntame antes de crear.
- **Directorio**: `.worktrees/<slug>`, dentro del repo.
- Si `.worktrees/` y `PLAN.md` no están en `.gitignore`, añádelos y dímelo. Ese
  cambio es un `chore` suyo: no lo mezcles con la funcionalidad.

## 3. Crear

```
git worktree add -b feat/<slug> .worktrees/<slug> <base>
```

Si la rama ya existe, no la recrees: `git worktree add .worktrees/<slug> feat/<slug>`.

## 4. El plan: `PLAN.md`

En la raíz del worktree escribe `PLAN.md` con el plan **ya acordado** de esta
funcionalidad, destilado de donde venga:

- de la skill `propuesta` (lo normal) — el diseño ya vive en `docs/proposals/<slug>.md`;
  el plan transcribe el contrato y los ciclos, y **referencia** la propuesta en su
  cabecera sin copiarla: «Contexto» es un enlace más lo que la propuesta no puede saber;
- de `/skill:sdd` — la spec conversada, los escenarios Gherkin y los ciclos TDD;
- de `/skill:tdd` — la lista de comportamientos a testear, en orden;
- de `/skill:kaizen` — el cambio en una frase y su red de seguridad.

Si no hay plan todavía, **no lo inventes aquí**: dímelo y decidimos cuál teclear
primero (`propuesta` o `sdd` para features; `tdd` o `kaizen` para lo pequeño). Este
comando transcribe un plan, no lo diseña.

**Prueba de aceptación del plan**: un agente que no estuvo en la conversación de
diseño, y que solo lee `PLAN.md`, la propuesta que este referencia y el repo, ¿puede
ejecutarlo entero sin preguntarme nada que no esté marcado como puerta humana? Si no,
el plan está incompleto: le falta contexto, no formato.

Markdown plano: su lector principal es un agente, así que ni HTML incrustado ni adornos.
Cada sección existe porque alguien la va a usar; si una queda vacía, dilo en vez de
rellenarla.

La estructura vive en
`~/.pi/agent/skills/flujo/propuesta/templates/PLAN.md`: léela y rellénala tal cual —
es la única fuente del formato, no la recreen de memoria. Si el repo de turno no
puede leer esa ruta, dímelo en vez de improvisar una estructura nueva.

Reglas del plan mientras se ejecuta:

- **El estado vive en el fichero, no en el chat** (regla de `sdd`): al cerrar un ciclo
  se actualiza su fila y se añade una línea a la bitácora. Así sobrevive a un reinicio
  de contexto y lo puede retomar otro agente.
- Un ciclo = un candidato a commit atómico. No fundas ciclos al commitear.
- `PLAN.md` es andamiaje: va en `.gitignore` y muere con el worktree. Si algo de ahí
  merece sobrevivir (una decisión difícil de revertir), su sitio es un ADR, y eso se
  commitea aparte.

## 5. Después de crear, dime

- Ruta del worktree, rama, commit base y ruta del `PLAN.md`.
- **Qué falta ahí dentro**: un worktree nuevo no tiene los ficheros ignorados del
  principal. Si el repo necesita `node_modules`, `.venv`, `.env` o similares para
  arrancar, dilo y propón cómo resolverlo. En repos de Python con `uv.lock`: crea el
  propio del worktree con `uv sync` (usa la caché global, es rápido) — **nunca
  reutilices ni enlaces el `.venv` del base**: sus rutas editables apuntan al checkout
  principal y ejecutarían el código equivocado. No copies ficheros con secretos sin
  preguntarme.
- Que a partir de ahora se trabaja con el cwd en `.worktrees/<slug>`.
- Que de aquí se construye con `/plan-ejecutar`, un ciclo por vez — y que eso ya no
  necesita este contexto, así que lo puede correr cualquier agente.

## Mientras dure

Un worktree, una funcionalidad. Si a mitad aparece otra cosa —un bug de paso, una
mejora que no venía a cuento— no la metas aquí: dímelo y abrimos otro worktree, o la
anotamos en «Fuera de alcance». Mezclar es lo que este flujo evita, y es justo lo que
luego hace imposible commitear en unidades atómicas.

Para cerrar e integrar: `/worktree-cerrar`.
