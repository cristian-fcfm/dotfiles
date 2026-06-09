---
name: kaizen
description: 'Flujo ligero para cambios aislados de mejora de código o infra (deuda técnica, refactor pequeño, ajustes). Úsala cuando la tarea NO sea una feature nueva ni un bug complejo. Triggers: "refactorizar", "mejorar infra", "limpiar código", "deuda técnica", "micro-refactor".'
---

# Kaizen (Micro-Refactor)

Fase de mejora continua ligera. Para cambios aislados donde el flujo TDD/SDD completo es excesivo.

## Pasos

1. **Aislar**: Define el cambio en 1 frase (ej: "extraer función X", "actualizar dep Y"). Sin specs ni Gherkin.
2. **Red de seguridad**: Ejecuta tests/linters actuales. Si no existen o el área no está cubierta, crea 1 test de regresión mínimo o de comportamiento *antes* de tocar el código.
3. **Ejecutar**: Haz el cambio atómico (un solo propósito). No mezcles con otras mejoras.
4. **Verificar**: Tests, linters y validación de infra deben quedar en verde.
5. **Principios**: Si el refactor aplica un principio tuyo (`confirmado` o `propuesto`), cítalo por `id`. Si detectas un gap, márcalo.
6. **No commitees** ni hagas push salvo que te lo pida.

## Cierre

Lista qué cambiaste (con `archivo:línea`), confirma que la red de seguridad pasó, y sugiere pasar a `/skill:revisar`.
