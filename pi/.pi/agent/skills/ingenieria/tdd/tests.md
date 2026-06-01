# Buenos y malos tests

## Buenos tests

**Estilo integration**: testean a través de interfaces reales, no de mocks de partes
internas.

```typescript
// BIEN: testea comportamiento observable
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

Características:

- Testea comportamiento (behavior) que importa a usuarios/llamadores
- Usa solo la API pública
- Sobrevive a refactors internos
- Describe QUÉ, no CÓMO
- Una aserción lógica por test

## Malos tests

**Tests de detalle de implementación**: acoplados a la estructura interna.

```typescript
// MAL: testea detalles de implementación
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Señales de alarma (red flags):

- Mockear colaboradores internos
- Testear métodos privados
- Asertar sobre conteo/orden de llamadas
- El test se rompe al refactorizar sin cambio de comportamiento
- El nombre del test describe CÓMO, no QUÉ
- Verificar por medios externos en vez de la interfaz

```typescript
// MAL: salta la interfaz para verificar
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// BIEN: verifica a través de la interfaz
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
