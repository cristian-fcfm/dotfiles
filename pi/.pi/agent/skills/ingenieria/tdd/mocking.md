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

```python
# Fácil de mockear
def process_payment(order, payment_client):
    return payment_client.charge(order.total)

# Difícil de mockear
def process_payment(order):
    client = StripeClient(os.environ["STRIPE_KEY"])
    return client.charge(order.total)
```

**2. Prefiere interfaces estilo SDK sobre fetchers genéricos**

Crea funciones específicas para cada operación externa en vez de una función genérica
con lógica condicional:

```python
# BIEN: cada método es mockeable de forma independiente
class Api:
    def get_user(self, id):
        return self._client.get(f"/users/{id}")

    def get_orders(self, user_id):
        return self._client.get(f"/users/{user_id}/orders")

    def create_order(self, data):
        return self._client.post("/orders", json=data)

# MAL: mockear requiere lógica condicional dentro del mock
class Api:
    def fetch(self, endpoint, **options):
        return self._client.request(endpoint, **options)
```

El enfoque SDK significa:
- Cada mock devuelve una forma específica
- Sin lógica condicional en el setup del test
- Más fácil ver qué endpoints ejercita un test
- Tipos claros por endpoint (con type hints)
