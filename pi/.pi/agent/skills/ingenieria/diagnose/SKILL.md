---
name: diagnose
description: Loop disciplinado de diagnóstico para bugs difíciles y regresiones de rendimiento. Reproducir → minimizar → hipótesis → instrumentar → arreglar → regression-test. Úsala cuando se diga "diagnostica esto"/"debuggea esto", se reporte un bug, algo esté roto/lanzando errores/fallando, o se describa una regresión de performance. Triggers: "diagnose", "debug", "bug", "está roto", "falla", "regresión de rendimiento".
---

<!-- Adaptado (ES/bilingüe) de mattpocock/skills (MIT). Ver LICENSE en esta carpeta. -->

# Diagnose

Una disciplina para bugs difíciles. Salta fases solo cuando esté explícitamente
justificado.

Al explorar el codebase, usa el glosario de dominio del proyecto (`CONTEXT.md`) para
tener un modelo mental claro de los módulos relevantes, y revisa los ADRs del área que
tocas.

## Fase 1 — Construye un feedback loop

**Esto es la skill.** Todo lo demás es mecánico. Si tienes una señal pass/fail rápida,
determinística y ejecutable por el agente para el bug, encontrarás la causa —
bisección, prueba de hipótesis e instrumentación solo consumen esa señal. Si no la
tienes, ninguna cantidad de mirar el código te salvará.

Invierte un esfuerzo desproporcionado aquí. **Sé agresivo. Sé creativo. Niégate a
rendirte.**

### Formas de construir uno — pruébalas más o menos en este orden

1. **Test que falla** en el seam que alcance el bug — unit, integration, e2e.
2. **Script curl / HTTP** contra un dev server corriendo.
3. **Invocación CLI** con un input de fixture, comparando (diff) stdout contra un
   snapshot conocido-bueno.
4. **Script de browser headless** (Playwright / Puppeteer) — maneja la UI, asierta
   sobre DOM/console/network.
5. **Replay de un trace capturado.** Guarda un request/payload/event log real a disco;
   re-ejecútalo por la ruta de código en aislamiento.
6. **Harness desechable.** Levanta un subconjunto mínimo del sistema (un servicio,
   deps mockeadas) que ejercite la ruta del bug con una sola llamada de función.
7. **Loop property / fuzz.** Si el bug es "a veces output incorrecto", corre 1000
   inputs aleatorios y busca el modo de falla.
8. **Harness de bisección.** Si el bug apareció entre dos estados conocidos (commit,
   dataset, versión), automatiza "arranca en estado X, chequea, repite" para poder
   `git bisect run`.
9. **Loop diferencial.** Corre el mismo input por versión-vieja vs versión-nueva (o
   dos configs) y compara (diff) outputs.
10. **Script bash HITL.** Último recurso. Si un humano debe hacer clic, manéjalo _a él_
    con `scripts/hitl-loop.template.sh` para que el loop siga estructurado. El output
    capturado vuelve a ti.

Construye el feedback loop correcto y el bug está 90% arreglado.

### Itera sobre el loop mismo

Trata el loop como un producto. Una vez tengas _un_ loop, pregunta:

- ¿Puedo hacerlo más rápido? (Cachear setup, saltar init no relacionado, acotar el scope.)
- ¿Puedo hacer la señal más nítida? (Asertar sobre el síntoma específico, no "no crasheó".)
- ¿Puedo hacerlo más determinístico? (Fijar el tiempo, seed del RNG, aislar filesystem,
  congelar la red.)

Un loop flaky de 30 segundos es apenas mejor que ningún loop. Un loop determinístico de
2 segundos es un superpoder de debugging.

### Bugs no determinísticos

El objetivo no es un repro limpio sino una **tasa de reproducción más alta**. Repite el
trigger 100×, paraleliza, añade estrés, acota ventanas de timing, inyecta sleeps. Un bug
con 50% de flake es debuggeable; con 1% no — sigue subiendo la tasa hasta que lo sea.

### Cuando genuinamente no puedes construir un loop

Detente y dilo explícitamente. Lista lo que intentaste. Pídeme: (a) acceso al entorno
que lo reproduce, (b) un artefacto capturado (HAR file, log dump, core dump, grabación
con timestamps), o (c) permiso para añadir instrumentación temporal en producción. **No**
procedas a hipotetizar sin un loop.

No pases a la Fase 2 hasta tener un loop en el que creas.

## Fase 2 — Reproducir

Corre el loop. Observa el bug aparecer.

Confirma:

- [ ] El loop produce el modo de falla que **yo** describí — no una falla distinta que
      casualmente está cerca. Bug equivocado = fix equivocado.
- [ ] La falla es reproducible en varias corridas (o, para bugs no determinísticos, a
      una tasa suficientemente alta para debuggear).
- [ ] Capturaste el síntoma exacto (mensaje de error, output incorrecto, timing lento)
      para que fases posteriores verifiquen que el fix realmente lo aborda.

No procedas hasta reproducir el bug.

## Fase 3 — Hipótesis

Genera **3–5 hipótesis rankeadas** antes de probar ninguna. Generar una sola hipótesis
te ancla a la primera idea plausible.

Cada hipótesis debe ser **falsable**: enuncia la predicción que hace.

> Formato: "Si <X> es la causa, entonces <cambiar Y> hará desaparecer el bug / <cambiar
> Z> lo empeorará."

Si no puedes enunciar la predicción, la hipótesis es un vibe — descártala o afínala.

**Muéstrame la lista rankeada antes de probar.** A menudo tengo conocimiento de dominio
que la re-rankea al instante ("acabamos de desplegar un cambio en la #3"), o sé hipótesis
ya descartadas. Checkpoint barato, gran ahorro de tiempo. No te bloquees en esto —
procede con tu ranking si estoy AFK.

## Fase 4 — Instrumentar

Cada probe debe mapear a una predicción específica de la Fase 3. **Cambia una variable a
la vez.**

Preferencia de herramientas:

1. **Debugger / inspección REPL** si el entorno lo soporta. Un breakpoint vale por diez logs.
2. **Logs dirigidos** en los límites que distinguen hipótesis.
3. Nunca "loguear todo y grep".

**Etiqueta cada debug log** con un prefijo único, ej. `[DEBUG-a4f2]`. La limpieza al
final se vuelve un solo grep. Los logs sin etiqueta sobreviven; los etiquetados mueren.

**Rama de performance.** Para regresiones de rendimiento, los logs suelen estar mal. En
cambio: establece una medición baseline (timing harness, `performance.now()`, profiler,
query plan), luego bisecta. Mide primero, arregla después.

## Fase 5 — Fix + regression test

Escribe el regression test **antes del fix** — pero solo si hay un **seam correcto** para él.

Un seam correcto es uno donde el test ejercita el **patrón real del bug** tal como ocurre
en el call site. Si el único seam disponible es demasiado superficial (test de un solo
caller cuando el bug necesita varios; unit test que no puede replicar la cadena que lo
disparó), un regression test ahí da falsa confianza.

**Si no existe un seam correcto, eso mismo es el hallazgo.** Anótalo. La arquitectura del
codebase está impidiendo que el bug se asegure. Marca esto para la siguiente fase.

Si existe un seam correcto:

1. Convierte el repro minimizado en un test que falla en ese seam.
2. Obsérvalo fallar.
3. Aplica el fix.
4. Obsérvalo pasar.
5. Re-corre el feedback loop de la Fase 1 contra el escenario original (no minimizado).

## Fase 6 — Cleanup + post-mortem

Requerido antes de declarar terminado:

- [ ] El repro original ya no reproduce (re-corre el loop de la Fase 1)
- [ ] El regression test pasa (o la ausencia de seam está documentada)
- [ ] Toda instrumentación `[DEBUG-...]` removida (`grep` del prefijo)
- [ ] Prototipos desechables borrados (o movidos a una ubicación de debug claramente marcada)
- [ ] La hipótesis que resultó correcta queda enunciada en el mensaje de commit / PR —
      para que el siguiente que debuggee aprenda

**Luego pregunta: ¿qué habría prevenido este bug?** Si la respuesta involucra cambio
arquitectónico (sin buen test seam, callers enredados, hidden coupling), registra un gap
en `aprendizaje.yaml` y/o propón abordar la arquitectura. Haz la recomendación **después**
de que el fix esté, no antes — ahora tienes más información que al empezar.
