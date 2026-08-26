# Dotfiles

Repo de **configuración viva** gestionado con GNU stow: los symlinks de `~` apuntan
al checkout principal, así que aquí no se usan worktrees (excepción ya recogida en mi
AGENTS.md global). Se trabaja sobre la rama base y se prueba en vivo.

## Commits

- **scope** = el paquete stow tocado: `cava`, `fastfetch`, `hypr`, `kitty`, `nvim`,
  `pi`, `scripts`, `starship`, `systemd`, `waybar`, `yazi`, `zsh`.
- Señal para partir un commit: toca dos paquetes stow sin dependencia entre ellos
  (`waybar` y `zsh`).

## Estructura

- `pi/.pi/agent/` — skills, prompts y `AGENTS.md` global del agente (stow → `~/.pi/agent`).
  Los cambios aquí afectan a todos los repos donde trabajo, no solo a este.
