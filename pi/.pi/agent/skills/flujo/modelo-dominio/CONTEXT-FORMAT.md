# Formato de CONTEXT.md

## Estructura

```md
# {Nombre del contexto}

{Una o dos frases sobre qué es este contexto y por qué existe.}

## Lenguaje

**Order (Orden)**:
{Una o dos frases describiendo el término}
_Evitar_: Compra, transacción

**Invoice (Factura)**:
Una solicitud de pago enviada a un cliente tras la entrega.
_Evitar_: Bill, recibo

**Customer (Cliente)**:
Una persona u organización que coloca órdenes.
_Evitar_: Client, comprador, cuenta
```

## Reglas

- **Sé opinado.** Cuando existan varias palabras para el mismo concepto, elige la
  mejor y lista las demás bajo `_Evitar_`.
- **Definiciones tensas.** Una o dos frases máximo. Define lo que ES, no lo que hace.
- **Solo términos específicos del dominio de este proyecto.** Los conceptos generales
  de programación (timeouts, tipos de error, patrones de utilidad) no van aquí aunque
  el proyecto los use mucho. Antes de añadir un término pregunta: ¿es único de este
  contexto o es un concepto general de programación? Solo lo primero pertenece.
- **Bilingüe:** mantén el término técnico canónico en inglés (Order, Invoice…) con su
  glosa en español, para que el código y el lenguaje compartido sean consistentes.
- **Agrupa términos bajo subtítulos** cuando emerjan clusters naturales. Si todos
  pertenecen a un área cohesiva, una lista plana está bien.

## Repos de uno vs múltiples contextos

**Un contexto (la mayoría):** un solo `CONTEXT.md` en la raíz.

**Múltiples contextos:** un `CONTEXT-MAP.md` en la raíz lista los contextos, dónde
viven y cómo se relacionan:

```md
# Context Map

## Contextos

- [Ordering](./src/ordering/CONTEXT.md) — recibe y rastrea órdenes de clientes
- [Billing](./src/billing/CONTEXT.md) — genera facturas y procesa pagos
- [Fulfillment](./src/fulfillment/CONTEXT.md) — gestiona picking y envío en bodega

## Relaciones

- **Ordering → Fulfillment**: Ordering emite eventos `OrderPlaced`; Fulfillment los
  consume para iniciar el picking.
- **Fulfillment → Billing**: Fulfillment emite `ShipmentDispatched`; Billing los
  consume para generar facturas.
- **Ordering ↔ Billing**: tipos compartidos para `CustomerId` y `Money`.
```

La skill infiere qué estructura aplica:

- Si existe `CONTEXT-MAP.md`, léelo para encontrar los contextos.
- Si solo existe un `CONTEXT.md` raíz, es un solo contexto.
- Si no existe ninguno, crea un `CONTEXT.md` raíz de forma perezosa al resolver el
  primer término.

Cuando haya múltiples contextos, infiere a cuál se refiere el tema actual. Si no
está claro, pregunta.
