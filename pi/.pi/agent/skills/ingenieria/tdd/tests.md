# Buenos y malos tests

## Buenos tests

**Estilo integration**: testean a través de interfaces reales, no de mocks de partes
internas.

```python
# BIEN: testea comportamiento observable
async def test_user_can_checkout_with_valid_cart():
    cart = create_cart()
    cart.add(product)
    result = await checkout(cart, payment_method)
    assert result.status == "confirmed"
```

Características:

- Testea comportamiento (behavior) que importa a usuarios/llamadores
- Usa solo la API pública
- Sobrevive a refactors internos
- Describe QUÉ, no CÓMO
- Una aserción lógica por test

## Malos tests

**Tests de detalle de implementación**: acoplados a la estructura interna.

```python
# MAL: testea detalles de implementación
async def test_checkout_calls_payment_service_process(mocker):
    mock_payment = mocker.patch("checkout.payment_service")
    await checkout(cart, payment)
    mock_payment.process.assert_called_once_with(cart.total)
```

Señales de alarma (red flags):

- Mockear colaboradores internos
- Testear métodos privados
- Asertar sobre conteo/orden de llamadas
- El test se rompe al refactorizar sin cambio de comportamiento
- El nombre del test describe CÓMO, no QUÉ
- Verificar por medios externos en vez de la interfaz

```python
# MAL: salta la interfaz para verificar
async def test_create_user_saves_to_database():
    await create_user(name="Alice")
    row = await db.fetch_one("SELECT * FROM users WHERE name = :n", {"n": "Alice"})
    assert row is not None

# BIEN: verifica a través de la interfaz
async def test_create_user_makes_user_retrievable():
    user = await create_user(name="Alice")
    retrieved = await get_user(user.id)
    assert retrieved.name == "Alice"
```
