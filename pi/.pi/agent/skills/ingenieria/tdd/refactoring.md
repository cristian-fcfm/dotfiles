# Candidatos de refactor

Tras el ciclo TDD, busca:

- **Duplicación** → Extraer función/clase
- **Métodos largos** → Partir en helpers privados (mantén los tests sobre la interfaz pública)
- **Shallow modules** → Combinar o profundizar
- **Feature envy** → Mover la lógica a donde viven los datos
- **Primitive obsession** → Introducir value objects
- **Código existente** que el código nuevo revela como problemático
