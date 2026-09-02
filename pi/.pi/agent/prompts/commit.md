---
description: Preparar commits atómicos siguiendo Conventional Commits
argument-hint: [contexto o matiz que deba tener en cuenta]
---

Prepara los commits de los cambios actuales. Invocar este comando **es** la petición
explícita de commitear que pide mi AGENTS.md, pero enséñame cada mensaje y espera mi OK
antes de ejecutar `git commit`. No hagas push ni crees PRs. Aquí no se reescribe
historia: nada de `amend`, `rebase`, `reset --hard` ni `restore`. (El único `rebase`
que hacemos es el de una rama de funcionalidad propia y sin publicar, y vive en
`/rama-cerrar`.)

La regla no es cuántos commits salen, es que **cada commit sea atómico**. Cuántos hacen
falta lo decide el análisis del paso 2 sobre el diff que tengas delante: uno si el
cambio tiene un solo motivo, varios si tiene varios. Lo que no vale es empaquetar
motivos distintos en un commit porque venían en la misma tanda.

## 1. Inventario

- `git status --short`
- `git diff` y `git diff --cached` — el diff completo, no solo `--stat`.

Dos cosas que se comprueban aquí, antes de pensar en mensajes:

- ¿Hay secretos, tokens o rutas de otra máquina en el diff? Si sí, párate.
- ¿Hay basura de trabajo (prints de debug, ficheros temporales)? Dímelo en vez de
  repartirla entre commits.

Si ya hay algo staged y mezcla temas, avísame y propón `git reset` para volver a
repartir desde cero (solo vacía el índice, no toca tus cambios).

## 2. Partir en unidades atómicas

Una unidad = **un motivo de cambio**. La prueba: ¿puedo revertir esta unidad sola,
en tres meses, sin arrastrar nada que no tenga que ver? Si no, no es atómica.

Si aparece **una** de estas señales, parte:

- El asunto necesita "y", "también", "además" o una coma enumerando.
- Encajan dos `tipo` a la vez (un `feat` que además reformatea → `feat` + `style`).
- Toca dos módulos o paquetes sin dependencia entre ellos.
- El cuerpo tendría dos hechos independientes, sin causa común.
- Mezcla mover o renombrar código con cambiar su comportamiento.
- Un mismo fichero cambia por dos razones distintas en hunks distintos.

Y estas dicen lo contrario, que **no** hay que partir:

- Separar dejaría un commit intermedio roto: config que referencia un script que aún
  no existe, un módulo nuevo sin registrar en la barra.
- Docs, tests o config que describen *este mismo* cambio: van con él. Docs de otra
  cosa: fuera.
- Renombrado mecánico que cruza N ficheros: es un motivo, un commit.

Ordena la secuencia para que **cada commit deje el repo funcionando**: primero la base
que otros necesitan (el refactor, el fichero nuevo), después lo que se apoya en ella.
Si no existe ningún orden que lo cumpla, la partición estaba mal: junta esas unidades y
dilo en el cuerpo en una línea.

## 3. Enséñame el plan

Antes de tocar el índice, dame la lista completa: por cada unidad, el asunto propuesto
y los ficheros (o hunks) que entran. Una línea por unidad, en el orden en que las vas a
commitear. Repasa la lista contra el paso 2 antes de enseñármela: si alguna unidad
sigue haciendo dos cosas, vuelve a partirla.

Espera mi OK al plan antes de seguir.

## 4. Commitear una a una

Por cada unidad, en orden:

1. Stagea **solo lo suyo** con `git add <rutas>`. Nunca `git add -A`, `git add .` ni
   `git commit -a`. Si un fichero se reparte entre dos commits, extrae el parche,
   quédate con los hunks de esta unidad y aplícalo al índice:
   `git diff -- <fichero> > <tmp>.patch` → recorta → `git apply --cached <tmp>.patch`.
2. Verifica con `git diff --cached` que está lo que dijiste y nada más.
3. Muéstrame el mensaje en un bloque de código y espera confirmación.
4. `git commit`, y luego `git status --short` antes de pasar a la siguiente.

Si a mitad algo se desvía del plan (un hunk que no se deja separar, un cambio que no
compila suelto), párate y dímelo en vez de improvisar un reparto nuevo.

Al terminar, `git log --oneline` de lo que has creado.

## Formato del asunto

[Conventional Commits](https://www.conventionalcommits.org): `tipo(scope): descripcion`

- **tipo**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`,
  `chore`. Uno solo; si dudas entre dos, es que el commit hace dos cosas.
- **scope**: opcional; el paquete, módulo o componente del repo que se toca (si el repo
define scopes en su `AGENTS.md`, úsalos). Omítelo si el cambio es transversal.
- **descripcion**: español, imperativo, minúscula inicial, sin tildes, sin punto final,
  máximo 72 caracteres. El efecto, no el mecanismo:
  `fix(waybar): mostrar la ventana activa de cada monitor`.
- **breaking change**: `!` antes de los dos puntos (`feat(hypr)!: ...`).

## Cuerpo

Ponlo siempre, salvo en cambios de una línea evidentes. Separado del asunto por una
línea en blanco, envuelto a 80 columnas, **máximo 4-5 líneas**. Tildes permitidas aquí.

Sé preciso: nombra el mecanismo concreto, no la categoría.

- Un `fix` dice el síntoma y la condición que lo dispara: *"con `separate-outputs` en
  false, la barra de DP-1 anunciaba ventanas del HDMI"*, no *"corrige un problema de
  monitores"*.
- Un `refactor` nombra lo que sustituye y lo que desaparece: el script, el estado en
  `/tmp`, la señal, el hardcode.
- Cita versiones e issues upstream cuando la causa es de un tercero.
- Si tuviste que juntar varios ficheros porque separarlos rompía un estado intermedio,
  dilo en una línea.

No narres el diff ni repitas el asunto en prosa. Si una frase no aporta un dato que el
diff no tiene, sobra.
