---
description: Cerrar un worktree de funcionalidad e integrarlo en la rama base
argument-hint: [slug del worktree; por defecto, en el que estoy]
---

Cierra la funcionalidad: intégrala en la rama base y limpia worktree y rama. Enséñame
qué vas a integrar y espera mi OK antes de tocar nada.

**No hagas push. Nunca, hasta que yo lo pida explícitamente** — tampoco borrar la rama
en `origin`, que también es un push. Si la rama está publicada, dímelo al final y ya
decidiré yo.

## 1. Situarte

`git worktree list`. El objetivo es el slug del argumento; si no lo doy, el worktree
donde estoy. `<base>` es `dev`, siempre.

## 2. Puertas: si alguna falla, párate y dímelo

Ninguna se salta por tu cuenta. Ante una que falle, informa y espera; no improvises un
arreglo.

- **Árbol limpio**: `git status --short` en el worktree, vacío. Si hay cambios sin
  commitear, no integres: o los commiteamos con `/commit` o me dices qué son. Nunca los
  descartes.
- **Hay algo que integrar**: `git log --oneline <base>..feat/<slug>`. Si sale vacío,
  no hay nada que fusionar; pregúntame si lo que quiero es descartar (ver el final).
- **Plan cumplido**: en `PLAN.md`, ¿queda algún ciclo sin cerrar, o alguna puerta
  humana sin pasar? Si queda, dímelo y espera: cerrar con el plan a medias es
  exactamente lo que este flujo evita.
- **Verde**: ejecuta en el worktree los comandos de la sección «Verificación» del plan
  (tests y linters). Si fallan, se acabó el cierre.
- **Commits atómicos**: repasa `git log <base>..feat/<slug>` contra las reglas de
  `/commit`. Si algún commit hace dos cosas, dímelo — aún estamos a tiempo, la rama no
  está publicada.

## 3. Enséñame qué entra

- `git log --oneline <base>..feat/<slug>` — la lista exacta de commits.
- `git diff --stat <base>...feat/<slug>` — la superficie tocada (tres puntos: solo
  lo de la rama, no lo que avanzó `<base>` mientras tanto).
- Si el plan dejó una decisión difícil de revertir sin registrar, dímelo ahora: su
  sitio es un ADR y se commitea antes de integrar, no después.

Espera mi OK.

## 4. Integrar

Primero, poner `<base>` al día: `git fetch origin` (solo lee) y, si va por detrás,
`git merge --ff-only origin/<base>` en el checkout principal. Si eso no es fast-forward,
párate: `<base>` ha divergido y eso lo miramos juntos.

Luego, según esté publicada la rama o no — compruébalo con
`git ls-remote --exit-code --heads origin feat/<slug>`:

**No publicada** (el caso normal, porque no hacemos push): rebase y fast-forward. Deja
historia lineal y **conserva cada commit atómico por separado**, que es justo lo que
`/commit` se molestó en construir.

```
git -C .worktrees/<slug> rebase <base>     # dentro del worktree
git switch <base>                           # en el checkout principal
git merge --ff-only feat/<slug>
```

**Publicada**: nada de rebase, no se reescribe lo que ya salió de aquí.

```
git merge --no-ff feat/<slug>
```

Si el rebase o el merge entran en conflicto, no me des solo la lista de ficheros:
**diagnostícalo por intención**. Con varios worktrees en vuelo esto deja de ser raro y
pasa a ser lo normal, y el texto en conflicto casi nunca dice quién tiene razón.

Para cada fichero en conflicto, dime qué quería cada lado y de dónde lo sacas: el
`PLAN.md` de esta rama (su objetivo y su bitácora) y el mensaje del commit del otro
lado. Con eso propón una resolución y su porqué — casi siempre es «ambas intenciones
sobreviven, así», no «me quedo con una». Si las dos intenciones son de verdad
incompatibles, eso no es un conflicto de git: es una decisión de diseño y la tomo yo.

**Espera mi OK antes de escribir la resolución.** Nada de `--abort` sin avisar, y nada
de quedarte con un lado entero (`--ours`/`--theirs`) para salir del paso.

**Nunca `--squash`**: fundiría en un commit los ciclos que el plan mantuvo separados.

## 5. Limpiar

Solo después de que la integración haya salido bien:

```
git worktree remove .worktrees/<slug>
git branch -d feat/<slug>
git worktree prune
```

Los dos primeros están pensados para fallar si algo se pierde: `remove` protesta si el
worktree está sucio, `-d` si la rama no está fusionada. **No pases a `--force` ni a
`-D`**; si alguno protesta, es que la puerta 2 se saltó algo. Dímelo.

`PLAN.md` desaparece con el worktree — es andamiaje y ese es su final. Si algo suyo
debía sobrevivir, ya se registró en el paso 3.

## 6. Cerrar

- `git log --oneline -5` de `<base>` y `git worktree list`.
- Si la rama existe en `origin`, recuérdamelo: queda viva ahí y limpiarla es un push
  que decido yo.
- **Cierra la propuesta** que el plan referencia: su estado pasa a `construida`
  (edita `docs/proposals/<slug>.md` en el checkout principal; ese cambio queda pendiente
  para el próximo `/commit`). Si la funcionalidad se descartó en vez de integrarse,
  `descartada` con motivo en «Revisiones».
- Si el plan dejó gaps de aprendizaje detectados, recuérdame registrarlos en
  `aprendizaje.yaml` (AGENTS.md).

## Descartar en vez de integrar

Solo si te lo digo con esas palabras. Antes de borrar nada, enséñame
`git log --oneline <base>..feat/<slug>` y dime qué trabajo se pierde exactamente.
Con mi confirmación explícita, y no antes:

```
git worktree remove --force .worktrees/<slug>
git branch -D feat/<slug>
```
