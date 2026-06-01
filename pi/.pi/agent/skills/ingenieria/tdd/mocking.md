# Cuándo usar mocks

Mockea solo en los **límites del sistema** (system boundaries):

- APIs externas (payment, email, etc.)
- Bases de datos (a veces — prefiere una test DB)
- Tiempo/aleatoriedad (time/randomness)
- Sistema de archivos (a veces)

No mockees:

- Tus propias clases/módulos
- Colaboradores internos
- Cualquier cosa que tú controles

## Diseñar para mockability

En los límites del sistema, diseña interfaces fáciles de mockear:

**1. Usa dependency injection**

Pasa las dependencias externas en vez de crearlas internamente:

```typescript
// Fácil de mockear
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Difícil de mockear
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefiere interfaces estilo SDK sobre fetchers genéricos**

Crea funciones específicas para cada operación externa en vez de una función genérica
con lógica condicional:

```typescript
// BIEN: cada función es mockeable de forma independiente
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// MAL: mockear requiere lógica condicional dentro del mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

El enfoque SDK significa:
- Cada mock devuelve una forma específica
- Sin lógica condicional en el setup del test
- Más fácil ver qué endpoints ejercita un test
- Type safety por endpoint
