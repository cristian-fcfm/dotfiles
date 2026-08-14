---
description: Preparar un commit siguiendo Conventional Commits
argument-hint: [contexto o matiz que deba tener en cuenta]
---

Prepara un commit con los cambios actuales. Invocar este comando **es** la petición
explícita de commitear que pide mi AGENTS.md, pero enséñame el mensaje y espera mi OK
antes de ejecutar `git commit`. No hagas push ni crees PRs.

## Qué mirar

`git status` y `git diff --cached`. Si no hay nada staged, dime qué vas a incluir antes
de hacer `git add`.

## Formato

[Conventional Commits](https://www.conventionalcommits.org): `tipo(scope): descripcion`

- **tipo**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`,
  `chore`.
- **scope**: opcional; el paquete stow tocado (`waybar`, `hypr`, `nvim`, `pi`,
  `systemd`, `scripts`, `yazi`, `kitty`, `zsh`). Omítelo si el cambio es transversal.
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
- Si el commit toca varios ficheros y separarlos rompería un estado intermedio, dilo en
  una línea.

No narres el diff ni repitas el asunto en prosa. Si una frase no aporta un dato que el
diff no tiene, sobra.

## Antes de proponer

- ¿El commit hace **una** cosa? Si mezcla temas, propón dividirlo y espera mi decisión.
- ¿Hay secretos, tokens o rutas de otra máquina en el diff?

Muéstrame el mensaje en un bloque de código y espera confirmación.
