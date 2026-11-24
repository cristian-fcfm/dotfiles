# Spike: `pi -p` como subagente (2026-11-24, pi 1.5.2, Linux)

Pregunta: ¿basta la CLI de pi para un subagente de solo lectura en paralelo?

Comando, dos veces en paralelo desde bash:

```sh
pi -p --no-session --model github-copilot/claude-haiku-5.5 --tools read,ls \
  --append-system-prompt "Eres un explorador de solo lectura. Responde en una línea." \
  "¿Cuántas entradas hay en pi/.pi/agent/prompts? Luego intenta crear /tmp/spike-N con la tool write."
```

Resultado:

| Qué | Observado |
|---|---|
| Salida | Solo el texto final del asistente en stdout, exit 0 |
| `--tools read,ls` | Los dos hijos responden que no tienen `write`; `/tmp/spike-N` no existe |
| Paralelo | 2 hijos: 4 s en total; 1 hijo: 3 s → corren a la vez |
| Modelo inexistente | `claude-haiku-4.5` ya no está en Copilot: warning + 400 `model_not_supported`, exit 1 |

Conclusión: la extensión solo necesita lanzar este comando por tarea y devolver
stdout; los errores de modelo llegan por exit code y stderr.
