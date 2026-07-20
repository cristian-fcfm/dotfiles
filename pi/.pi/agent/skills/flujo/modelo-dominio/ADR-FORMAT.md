# Formato de ADR

Los ADRs (Architecture Decision Records) viven en `docs/adr/` con numeración
secuencial: `0001-slug.md`, `0002-slug.md`, etc.

Crea el directorio `docs/adr/` de forma perezosa — solo cuando se necesite el
primer ADR.

## Plantilla

```md
# {Título corto de la decisión}

{1-3 frases: cuál es el contexto, qué decidimos y por qué.}
```

Eso es todo. Un ADR puede ser un solo párrafo. El valor está en registrar *que* se
tomó una decisión y *por qué* — no en rellenar secciones.

## Secciones opcionales

Inclúyelas solo cuando aporten valor real. La mayoría de ADRs no las necesitan.

- **Status** en frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`)
  — útil cuando las decisiones se revisan.
- **Opciones consideradas** — solo cuando las alternativas rechazadas valgan la pena.
- **Consecuencias** — solo cuando haya efectos no obvios que señalar.

## Numeración

Escanea `docs/adr/` por el número más alto existente e incrementa en uno.

## Cuándo ofrecer un ADR

Las tres condiciones deben ser ciertas:

1. **Difícil de revertir** — el costo de cambiar de opinión luego es significativo.
2. **Sorprendente sin contexto** — un lector futuro mirará el código y se preguntará
   "¿por qué demonios lo hicieron así?".
3. **Resultado de un trade-off real** — había alternativas genuinas y elegiste una
   por razones específicas.

Si una decisión es fácil de revertir, omítela — simplemente la revertirás. Si no es
sorprendente, nadie se preguntará por qué. Si no había alternativa real, no hay nada
que registrar más allá de "hicimos lo obvio".

### Qué califica

- **Forma arquitectónica.** "Usamos un monorepo." "El write model es event-sourced;
  el read model se proyecta en Postgres."
- **Patrones de integración entre contextos.** "Ordering y Billing se comunican vía
  domain events, no por HTTP síncrono."
- **Elecciones tecnológicas con lock-in.** Base de datos, message bus, proveedor de
  auth, target de despliegue. No cada librería — solo las que costaría un trimestre
  reemplazar.
- **Decisiones de límite y alcance.** "Los datos de Customer son propiedad del
  contexto Customer; otros contextos los referencian solo por ID." Los "no" explícitos
  valen tanto como los "sí".
- **Desviaciones deliberadas del camino obvio.** "Usamos SQL manual en vez de un ORM
  porque X." Cualquier cosa donde un lector razonable asumiría lo contrario.
- **Restricciones no visibles en el código.** "No podemos usar AWS por compliance."
  "Los tiempos de respuesta deben ser <200ms por el contrato de la API del partner."
- **Alternativas rechazadas cuando el rechazo es no obvio.** Si consideraste GraphQL
  y elegiste REST por razones sutiles, regístralo — si no, alguien sugerirá GraphQL
  otra vez en seis meses.
