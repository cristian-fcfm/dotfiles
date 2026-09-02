---
name: sdd
description: 'Construye una feature compleja con spec conversada, contrato Gherkin, puerta humana y TDD estricto.'
disable-model-invocation: true
---

# SDD (Desarrollo Dirigido por Software)

Fase de construcción robusta para features no triviales. El código es secundario; el proceso es lo principal.

## Pipeline

1. **Spec conversada**: Debate casos límite y decisiones. La salida es la propuesta
   (`docs/proposals/<slug>.md`, skill `propuesta`) y ADRs si aplican — no un fichero
   de spec aparte.
2. **Contrato Gherkin**: Destila la spec en escenarios `.feature` ejecutables (`Given/When/Then`).
   - ⏸ **PUERTA HUMANA**: Espera mi aprobación explícita del contrato antes de escribir código.
3. **TDD estricto**: Un test a la vez (Rojo → Verde → Refactor). Nada de código de producción sin un test rojo que lo pida.
4. **Review (Judge)**: El juego entero. Aprueba o poda. Si hay código que nadie pidió o escenarios sin test, rechaza.

## Reglas

- Una sola feature a la vez, en su propia rama (`/rama`).
- Estado en disco, no en chat, para que sobreviva a reinicios de contexto: ese estado es el `PLAN.md` de la rama — su tabla de ciclos y su bitácora se actualizan al cerrar cada ciclo. No crees ficheros de estado paralelos (`progress/` y demás).
- Distingue producto de andamiaje: la propuesta (`docs/proposals/`), los `.feature` y
  los ADRs se commitean; el `PLAN.md` es andamiaje y se borra al integrar la rama.
- Respeta la REGLA DE PRECEDENCIA de `AGENTS.md`.

## Cierre

Cuando el review esté aprobado y el TDD completado, lista los artefactos generados y encadena: `/skill:revisar` → `/commit` (un ciclo del plan = un commit atómico) → `/rama-cerrar`.
