# Dotfiles

Repo de **configuración viva** gestionado con GNU stow: los symlinks de `~` apuntan a
este checkout, así que lo que esté en el árbol de trabajo es lo que el sistema ejecuta.
Un `git switch` cambia la configuración activa de la máquina: no dejes ramas a medias
en sitios donde luego no recuerdes por qué algo se comporta raro.

## Commits

- **scope** = el paquete stow tocado: `cava`, `fastfetch`, `hypr`, `kitty`, `nvim`,
  `pi`, `scripts`, `starship`, `systemd`, `waybar`, `yazi`, `zsh`.
- Señal para partir un commit: toca dos paquetes stow sin dependencia entre ellos
  (`waybar` y `zsh`).

## Estructura

- `pi/.pi/agent/` — skills, prompts y `AGENTS.md` global del agente (stow → `~/.pi/agent`).
  Los cambios aquí afectan a todos los repos donde trabajo, no solo a este.
