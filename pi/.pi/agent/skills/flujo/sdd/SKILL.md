---
name: sdd
description: 'Desarrollo Dirigido por Software (SDD) estilo Uncle Bob para features complejas. Incluye spec conversada, contrato Gherkin, TDD estricto y review. Triggers: "feature nueva", "sdd", "uncle bob", "desarrollo dirigido por software", "contrato gherkin".'
---

# SDD (Desarrollo Dirigido por Software)

Fase de construcción robusta para features no triviales. El código es secundario; el proceso es lo principal.

## Pipeline

1. **Spec conversada**: Debate casos límite y decisiones. Escribe/amplía `project-spec.md` (o ADRs).
2. **Contrato Gherkin**: Destila la spec en escenarios `.feature` ejecutables (`Given/When/Then`).
   - ⏸ **PUERTA HUMANA**: Espera mi aprobación explícita del contrato antes de escribir código.
3. **TDD estricto**: Un test a la vez (Rojo → Verde → Refactor). Nada de código de producción sin un test rojo que lo pida.
4. **Review (Judge)**: El juego entero. Aprueba o poda. Si hay código que nadie pidió o escenarios sin test, rechaza.

## Reglas

- Una sola feature a la vez.
- Estado en disco, no en chat: usa archivos (`features/`, `progress/`) para que sobreviva a reinicios de contexto.
- Respeta la REGLA DE PRECEDENCIA de `AGENTS.md`.

## Cierre

Cuando el review esté aprobado y el TDD completado, lista los artefactos generados y sugiere `/skill:revisar` o el commit.
