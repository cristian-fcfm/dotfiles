# Diseño de interfaces para testability

Las buenas interfaces hacen que testear sea natural:

1. **Acepta dependencias, no las crees**

   ```python
   # Testeable
   def process_order(order, payment_gateway): ...

   # Difícil de testear
   def process_order(order):
       gateway = StripeGateway()
   ```

2. **Devuelve resultados, no produzcas side effects**

   ```python
   # Testeable
   def calculate_discount(cart) -> Discount: ...

   # Difícil de testear
   def apply_discount(cart) -> None:
       cart.total -= discount
   ```

3. **Superficie pequeña (small surface area)**
   - Menos métodos = menos tests necesarios
   - Menos params = setup de test más simple
