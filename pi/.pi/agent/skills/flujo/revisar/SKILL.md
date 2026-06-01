---
name: revisar
description: 'Checklist de calidad antes de dar una tarea por terminada (correctitud, errores, tests, seguridad, principios, mantenibilidad). Úsala al final de una implementación o sobre cambios git pendientes. Triggers: "revisar", "review", "checklist", "antes de terminar", "revisa estos cambios".'
---

# Revisar

Fase REVISAR. Revisa lo indicado; si no se especifica, revisa los cambios actuales
(`git diff` / `git diff --cached`).

## Checklist

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

## Cierre

Para cada hallazgo: severidad, `archivo:línea` y arreglo propuesto. Si trabajaste
en un área sin principios, recuérdame registrar el gap en `aprendizaje.yaml`.
