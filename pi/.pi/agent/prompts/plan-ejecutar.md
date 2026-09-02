---
description: Ejecutar el siguiente ciclo pendiente del PLAN.md de esta rama
argument-hint: [nº de ciclo, si quiero uno concreto]
---

Ejecuta **un** ciclo del plan y para. Nada más.

Este comando está pensado para que lo corra un agente que no estuvo en la
conversación de diseño. Todo lo que necesita saber está en `PLAN.md` y en el repo; si
algo no está ahí, no lo adivines: es un fallo del plan y hay que decirlo.

## 1. Cargar el estado

Lee `PLAN.md` desde la raíz del repo. Si no existe, para: este comando no se usa fuera
de una rama abierta con `/rama`.

Comprueba que la rama de la cabecera del plan es la actual (`git branch --show-current`).
Si no coinciden, para y dímelo: `PLAN.md` no está rastreado, así que sobrevive a un
`git switch` y ejecutar sus ciclos sobre otra rama mezcla dos funcionalidades.

Léelo entero antes de tocar nada — «Fuera de alcance» y «Puertas humanas» son tan
vinculantes como el contrato. Después, la **bitácora**: es lo que pasó en los ciclos
anteriores y a menudo explica por qué el código no está como el contrato haría esperar.

Si la cabecera del plan referencia una **propuesta** (`docs/proposals/<slug>.md`),
léela también del disco: es el porqué de lo que vas a ejecutar, y aclara los trade-offs
que el plan da por sabidos. Leerla no es opcional; adivinar, sí lo es.

El ciclo a ejecutar es el del argumento; si no lo doy, **el primero en estado
`pendiente`**. Si no queda ninguno, dilo y sugiere `/rama-cerrar`. No te adelantes
a ciclos posteriores aunque «se vea claro» cómo van: cada ciclo se diseñó para
responder a lo aprendido en el anterior.

## 2. Ejecutar el ciclo

Un ciclo es un red-green-refactor de la skill `tdd`, aplicado a **un** comportamiento:

1. **Rojo**: escribe el test de ese comportamiento y míralo fallar. Comportamiento
   observable por la interfaz pública, no implementación.
2. **Verde**: el código mínimo que lo pasa. Nada especulativo, nada de los ciclos
   siguientes.
3. **Refactor**: solo en verde, y corriendo los tests después de cada paso.
4. Corre los comandos de «Verificación» del plan enteros, no solo el test nuevo.

Las aprobaciones que la sección «Puertas humanas» marca como **ya aprobadas** no se
vuelven a pedir — se concedieron al escribir el plan, y volver a preguntarlas es lo
que hace inútil correr esto en paralelo. Las de la otra lista se respetan siempre.

## 3. Guardar el estado

En `PLAN.md`, antes de terminar:

- La fila del ciclo pasa a `hecho`, con la ruta real del test si cambió.
- Una línea nueva en la bitácora: qué se hizo, y sobre todo **qué se aprendió** que el
  plan no sabía — una suposición que resultó falsa, un caso borde que apareció, una
  interfaz que no encajaba. Eso es lo que le sirve al siguiente ciclo.
- Si algo obliga a cambiar el contrato o a salirse de «Contexto», **no lo cambies**:
  anótalo en la bitácora, para, y dímelo.

El estado vive en el fichero, no en el chat. Escríbelo aunque vayas a seguir con otro
ciclo: es lo que permite que esto se retome tras un reinicio de contexto, o que lo
continúe otro agente.

## 4. Cerrar el turno

Dime: qué ciclo cerraste, el resultado de la verificación, qué anotaste en la bitácora
y cuál es el siguiente ciclo pendiente.

Un ciclo cerrado es un candidato a commit atómico, pero **no commitees tú**: eso es
`/commit`, y es puerta humana.

## Cuando pararte

Para y dime, en vez de improvisar:

- El plan no alcanza: falta contexto para ejecutar el ciclo sin inventarme decisiones.
- El test no se deja escribir en un seam razonable.
- Hay que tocar ficheros que «Contexto» no lista, o hacer algo de «Fuera de alcance».
- La verificación falla por algo ajeno a este ciclo (la rama ya venía en rojo).
- Dos ciclos seguidos revelan que el contrato estaba mal. Ahí el problema es el plan, y
  el plan se arregla conmigo, no sobre la marcha.
