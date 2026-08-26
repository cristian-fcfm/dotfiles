---
name: revisar
description: 'Checklist de calidad antes de dar una tarea por terminada (correctitud, errores, tests, seguridad, principios, mantenibilidad). Úsala al final de una implementación o sobre cambios git pendientes. Triggers: "revisar", "review", "checklist", "antes de terminar", "revisa estos cambios".'
---

# Revisar

Fase REVISAR. Revisa lo indicado; si no se especifica, revisa los cambios actuales
(`git diff` / `git diff --cached`).

Revisas el árbol de trabajo, no el índice: aquí no se stagea, ni se commitea, ni se
integra nada. De eso se encargan `/commit` y `/worktree-cerrar` **después**, con el
checklist en verde. Esta skill produce hallazgos, no cambios en git.

## Dos ejes

La revisión son dos preguntas distintas y **no se contaminan**: el eje Spec no opina
sobre calidad, el eje Estándares no opina sobre alcance. Al ser independientes se
pueden correr en paralelo, un agente por eje, y luego juntar los hallazgos.

## Eje Spec — ¿es lo que se acordó?

Contra el `PLAN.md` de la rama y, si el plan la referencia, la propuesta
(`docs/proposals/<slug>.md`) — no contra tu criterio:

1. **Cobertura del contrato**: cada comportamiento o escenario del contrato tiene su
   test. Nombra los que no.
2. **Nada de más**: código que ningún ciclo pidió. Aunque sea bueno, aquí sobra.
3. **Fuera de alcance**: lo que el plan excluyó sigue sin tocarse.
4. **Desvíos**: si el código se apartó del contrato, ¿está en la bitácora y lo aprobé?
   Un desvío no registrado es un hallazgo, aunque el código sea correcto.
5. **Tabla de ciclos**: lo marcado como `hecho` está de verdad hecho, y lo `pendiente`
   no está a medio hacer.
6. **Problema resuelto y criterios**: si hay propuesta, ¿lo construido ataca su
   «Problema» y cumple sus «Criterios de aceptación» punto por punto? Cumplir el
   contrato de un plan que no resuelve el problema de la propuesta es fallar
   más fino.

**Si no hay `PLAN.md`** —un kaizen sobre la rama base, un fix suelto— juzga contra
la propuesta si existe; si tampoco la hay, este eje **no aplica**. Dilo y pasa al
otro. No lo sustituyas por tu propia idea de qué debería hacer el cambio: juzgar
contra un contrato que te acabas de inventar es exactamente lo que este eje existe
para evitar.

## Eje Estándares — ¿está bien hecho?

1. **Correctitud**: ¿hace lo que debe? ¿casos borde (edge cases) cubiertos?
2. **Errores y fallos**: manejo de errores, validación de entradas, idempotencia
   donde cruce red (ver `ddia-idempotencia-01`).
3. **Tests**: ¿hay tests? ¿prueban comportamiento (behavior) y no implementación?
   Si dudas del nivel adecuado, apóyate en la skill `tdd` y propón/explícame.
4. **Seguridad**: secretos, inyección (injection), permisos, datos sensibles en logs.
5. **Principios míos**: contrasta contra `principios.yaml` (vía `consultar-notas`)
   los que apliquen; di cuáles se cumplen y cuáles no (por `id`).
6. **Contexto del repo**: si hay `CONTEXT.md`/ADRs, ¿el cambio respeta el glosario
   y las decisiones registradas?
7. **Mantenibilidad**: simplicidad, nombres consistentes con el dominio,
   ¿lo entenderé en 3 meses? (`ddia-mantenibilidad-01`); busca módulos profundos
   (deep modules: interfaz simple, implementación rica).
8. **Sobre-ingeniería (over-engineering)**: pasada de poda. Devuelve una
   *delete-list* de lo que sobra (principio `simplicidad-escalera-01`):
   abstracciones con una sola implementación, factories de un solo producto,
   config para valores que nunca cambian, dependencias nuevas que unas líneas
   cubrían, boilerplate "para después", código que nadie pidió. Para cada ítem:
   `archivo:línea` y qué borrar o colapsar. No cuentes como sobra las salvaguardas
   (`simplicidad-salvaguardas-01`).
9. **Deuda marcada**: busca comentarios `YAGNI:` (`rg YAGNI:`). Cada uno es
   un atajo con techo conocido; si alguno ya alcanzó su techo o es relevante para
   esta tarea, recuérdame registrarlo como gap en `aprendizaje.yaml`.

## Cierre

Para cada hallazgo: **eje**, severidad, `archivo:línea` y arreglo propuesto. Si el eje
Spec no aplicó, dilo en una línea en vez de callártelo. Si trabajaste en un área sin
principios, recuérdame registrar el gap en `aprendizaje.yaml`.

Con los hallazgos resueltos, sigue `/commit`, y `/worktree-cerrar` si el trabajo vive
en un worktree.
