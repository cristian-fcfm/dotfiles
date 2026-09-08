---
description: Abrir una rama para una funcionalidad, con su plan ejecutable
argument-hint: [la funcionalidad que voy a construir]
---

Abre una rama para la funcionalidad que te describo en el argumento. Una
funcionalidad = una rama = un plan. Enséñame el plan y espera mi OK antes de crear
nada. No hagas push.

La idea: el trabajo de cada funcionalidad vive en su rama, y su plan vive en disco
(`PLAN.md`) en vez de en el chat. Eso hace la historia de git legible —una rama, una
serie de commits atómicos, un merge— y deja que retome el trabajo otro agente que no
estuvo en la conversación de diseño, solo leyendo el plan y el repo.

**Una cosa en vuelo a la vez.** Este flujo no persigue paralelismo: persigue que la
historia se entienda dentro de tres meses.

## 1. Comprobaciones previas

- **Rama base**: `dev`, siempre. Llámala `<base>`.
- **¿Dónde estoy?** `git branch --show-current`. Si ya estás en una rama de
  funcionalidad, no anides otra encima: vuelve a `<base>` antes de crear.
- **¿Hay un `PLAN.md` en la raíz?** Es andamiaje no rastreado, así que sobrevive a un
  `git switch` y puede ser de otra funcionalidad. Si existe, léele la cabecera: si su
  rama sigue viva y con ciclos pendientes, párate y dímelo — hay trabajo a medias y
  decido yo si se cierra antes o se aparca.
- **¿Está `<base>` al día?** `git fetch origin` (solo lee, no publica nada). Si va por
  detrás de `origin/<base>`, avísame: partir de una base vieja se paga al integrar.
  Actualiza con `git merge --ff-only` si te lo confirmo.
- **¿Hay cambios sin commitear?** `git switch -c` se los lleva a la rama nueva sin
  avisar, y eso ensucia el primer commit con cosas de otro motivo. Si los hay, dime qué
  son y espera: o se commitean donde están (con `/commit`), o `git stash` aquí y
  `git stash pop` ya en la rama nueva. Nunca los descartes ni los arrastres por tu
  cuenta.

## 2. Nombre

Del argumento sacas un slug corto en inglés y en kebab-case (tradúcelo si te lo
describo en español): la funcionalidad, no el mecanismo (`toggle-monitors`, no
`fix-bash-script`).

- **Rama**: `<tipo>/<slug>` (en inglés), con el mismo `tipo` de Conventional Commits que
  usarás al commitear: `feat/`, `fix/`, `refactor/`, `docs/`, `chore/`. Si no tienes claro
  cuál es, es que la funcionalidad no está clara: pregúntame antes de crear.
- Si `PLAN.md` no está en `.gitignore`, añádelo y dímelo. Ese cambio es un `chore`
  suyo: no lo mezcles con la funcionalidad.

## 3. Crear

```
git switch -c <tipo>/<slug> <base>
```

Si la rama ya existe, no la recrees: `git switch <tipo>/<slug>`.

## 4. El plan: `PLAN.md`

En la raíz del repo escribe `PLAN.md` con el plan **ya acordado** de esta
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
es la única fuente del formato, no la recrees de memoria. Si el repo de turno no
puede leer esa ruta, dímelo en vez de improvisar una estructura nueva.

La cabecera lleva la **rama** a la que pertenece el plan. No es decorativo: como
`PLAN.md` no está rastreado, es lo único que delata que el plan y la rama actual no
son la misma cosa.

Reglas del plan mientras se ejecuta:

- **El estado vive en el fichero, no en el chat** (regla de `sdd`): al cerrar un ciclo
  se actualiza su fila y se añade una línea a la bitácora. Así sobrevive a un reinicio
  de contexto y lo puede retomar otro agente.
- Un ciclo = un candidato a commit atómico. No fundas ciclos al commitear.
- `PLAN.md` es andamiaje: va en `.gitignore` y se borra al integrar la rama. Si algo de
  ahí merece sobrevivir (una decisión difícil de revertir), su sitio es un ADR, y eso se
  commitea aparte.

## 5. Después de crear, dime

- Rama creada, commit base y ruta del `PLAN.md`.
- Que de aquí se construye con `/plan-ejecutar`, un ciclo por vez — y que eso ya no
  necesita este contexto, así que lo puede correr cualquier agente.

## Mientras dure

Una rama, una funcionalidad. Si a mitad aparece otra cosa —un bug de paso, una mejora
que no venía a cuento— no la metas aquí: dímelo y la anotamos en «Fuera de alcance»
para abrirle su propia rama después. Mezclar es lo que este flujo evita, y es justo lo
que luego hace imposible commitear en unidades atómicas y leer la historia.

Si de verdad hay que aparcar esto y saltar a otra cosa, se aparca entero: árbol limpio
(commit o `stash`) y el `PLAN.md` de esta rama a un lado. Nunca dejes dos planes a
medias compitiendo por la misma raíz.

Para cerrar e integrar: `/rama-cerrar`.
