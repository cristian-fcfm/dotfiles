---
name: tdd
description: 'Desarrollo guiado por tests (Test-Driven Development) con loop red-green-refactor. Úsala para construir features o arreglar bugs con TDD, cuando se mencione "red-green-refactor", se quieran integration tests, o desarrollo test-first. Triggers: "tdd", "red-green-refactor", "test primero", "test-first", "integration tests".'
---

<!-- Adaptado (ES/bilingüe) de mattpocock/skills (MIT). Ver LICENSE en esta carpeta. -->

# Test-Driven Development (TDD)

## Filosofía

**Principio central**: los tests deben verificar el _comportamiento_ (behavior) a
través de interfaces públicas, no los detalles de implementación. El código puede
cambiar por completo; los tests no.

**Buenos tests** son de estilo integration: ejercitan rutas reales de código a través
de APIs públicas. Describen _qué_ hace el sistema, no _cómo_ lo hace. Un buen test se
lee como una especificación — "user can checkout with valid cart" te dice exactamente
qué capacidad existe. Estos tests sobreviven a los refactors porque no les importa la
estructura interna.

**Malos tests** están acoplados a la implementación. Mockean colaboradores internos,
prueban métodos privados, o verifican por medios externos (como consultar la base de
datos directamente en vez de usar la interfaz). La señal de alarma: tu test se rompe
al refactorizar, pero el comportamiento no cambió. Si renombras una función interna y
los tests fallan, esos tests probaban implementación, no comportamiento.

Ver [tests.md](tests.md) para ejemplos y [mocking.md](mocking.md) para guías de mocking.

## Anti-patrón: Horizontal Slices

**NO escribas todos los tests primero y luego toda la implementación.** Eso es
"horizontal slicing" — tratar RED como "escribir todos los tests" y GREEN como
"escribir todo el código".

Esto produce **tests basura**:

- Los tests escritos en bloque prueban comportamiento _imaginado_, no _real_.
- Terminas probando la _forma_ de las cosas (estructuras de datos, signatures) en vez
  del comportamiento que ve el usuario.
- Los tests se vuelven insensibles a cambios reales — pasan cuando el comportamiento se
  rompe, fallan cuando está bien.
- Te adelantas a tus faros (outrun your headlights), comprometiéndote con una
  estructura de tests antes de entender la implementación.

**Enfoque correcto**: vertical slices vía tracer bullets. Un test → una implementación
→ repetir. Cada test responde a lo aprendido en el ciclo anterior. Como acabas de
escribir el código, sabes exactamente qué comportamiento importa y cómo verificarlo.

```
MAL (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

BIEN (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
  ...
```

## Workflow

### 1. Planning

Al explorar el codebase, usa el glosario de dominio del proyecto (`CONTEXT.md`) para
que los nombres de tests y el vocabulario de interfaces coincidan con el lenguaje del
proyecto, y respeta los ADRs del área que tocas.

Antes de escribir código:

- [ ] Confirmar conmigo qué cambios de interfaz se necesitan
- [ ] Confirmar conmigo qué comportamientos testear (priorizar)
- [ ] Identificar oportunidades de [deep modules](deep-modules.md) (interfaz pequeña,
      implementación profunda)
- [ ] Diseñar interfaces para [testability](interface-design.md)
- [ ] Listar los comportamientos a testear (no los pasos de implementación)
- [ ] Obtener mi aprobación del plan

Pregunta: "¿Cómo debería verse la interfaz pública? ¿Qué comportamientos son más
importantes de testear?"

**No puedes testear todo.** Confirma conmigo exactamente qué comportamientos importan
más. Enfoca el esfuerzo en critical paths y lógica compleja, no en cada edge case.

### 2. Tracer Bullet

Escribe UN test que confirme UNA cosa sobre el sistema:

```
RED:   Escribe test del primer comportamiento → falla
GREEN: Escribe el código mínimo para pasar → pasa
```

Este es tu tracer bullet — prueba que la ruta funciona end-to-end.

### 3. Loop incremental

Para cada comportamiento restante:

```
RED:   Escribe el siguiente test → falla
GREEN: Código mínimo para pasar → pasa
```

Reglas:

- Un test a la vez
- Solo el código suficiente para pasar el test actual
- No anticipes tests futuros
- Mantén los tests enfocados en comportamiento observable

### 4. Refactor

Cuando todos los tests pasen, busca [candidatos de refactor](refactoring.md):

- [ ] Extraer duplicación
- [ ] Profundizar módulos (mover complejidad detrás de interfaces simples)
- [ ] Aplicar principios SOLID donde sea natural
- [ ] Considerar qué revela el código nuevo sobre el existente
- [ ] Correr los tests después de cada paso de refactor

**Nunca refactorices en RED.** Llega a GREEN primero.

## Checklist por ciclo

```
[ ] El test describe comportamiento, no implementación
[ ] El test usa solo la interfaz pública
[ ] El test sobreviviría a un refactor interno
[ ] El código es mínimo para este test
[ ] No se añadieron features especulativas
```
