# 2. systemd es el dueño de los daemons de sesión

Fecha: 2026-08-12 · Estado: aceptado

## Contexto

Los daemons (waybar, swaync, portal) se lanzaban con `hl.exec_cmd` desde el
autostart de Hyprland, pero sus units de systemd también existían y se
activaban por D-Bus. Resultado observado:

- `swaync.service`: *"An instance is already running"*, fallo permanente.
- `xdg-desktop-portal-hyprland.service`: arrancaba antes que el compositor,
  agotaba el límite de reintentos y quedaba muerto — compartir pantalla roto
  sin ningún aviso.
- `graphical-session.target` nunca llegaba a activarse, así que nada de lo
  que cuelga de él arrancaba.

## Decisión

Un solo dueño: systemd. Hyprland solo exporta el entorno y activa el target.

- `hyprland-session.target` (versionado en este repo) hace `BindsTo` de
  `graphical-session.target`.
- El autostart ejecuta `dbus-update-activation-environment --systemd` y luego
  `systemctl --user start hyprland-session.target`.
- Los daemons se enganchan con `systemctl --user enable`; sus units ya traen
  `WantedBy=graphical-session.target`.

## Consecuencias

- Orden de arranque garantizado: el portal ya no busca un compositor que no
  existe.
- waybar recupera `Restart=on-failure` gratis; se eliminó el wrapper de
  respawn propio que hacía ese trabajo a mano.
- Listar los daemons en `Wants=` del target propio provoca un ciclo de orden
  y systemd cancela su arranque. Deben colgar de `graphical-session.target`.
- Al añadir un daemon nuevo hay que hacer `enable` una vez; ese symlink vive
  en `~`, no en el repo.
