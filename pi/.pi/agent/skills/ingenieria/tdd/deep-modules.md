# Deep Modules (módulos profundos)

De "A Philosophy of Software Design":

**Deep module** = interfaz pequeña + mucha implementación

```
┌─────────────────────┐
│   Interfaz pequeña  │  ← Pocos métodos, params simples
├─────────────────────┤
│                     │
│                     │
│ Implementación rica │  ← Complejidad oculta
│                     │
│                     │
└─────────────────────┘
```

**Shallow module** = interfaz grande + poca implementación (evitar)

```
┌─────────────────────────────────┐
│       Interfaz grande           │  ← Muchos métodos, params complejos
├─────────────────────────────────┤
│  Implementación delgada         │  ← Solo pasa los datos (pass-through)
└─────────────────────────────────┘
```

Al diseñar interfaces, pregunta:

- ¿Puedo reducir el número de métodos?
- ¿Puedo simplificar los parámetros?
- ¿Puedo ocultar más complejidad dentro?
