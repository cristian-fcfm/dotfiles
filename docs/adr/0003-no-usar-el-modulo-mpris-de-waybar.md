# 3. No usar el módulo nativo `mpris` de waybar

Fecha: 2026-08-12 · Estado: aceptado

## Contexto

`scripts/mediaplayer.py` (219 líneas, pygobject + Playerctl) hace lo mismo
que el módulo nativo `mpris`, que está compilado en el paquete de Arch. Se
sustituyó por el nativo para quitar código y un proceso.

Horas después waybar desapareció entera:

    SIGSEGV  #0 Glib::DispatchNotifier::send_notification
             #6 libplayerctl.so.2

Es un bug conocido de waybar (upstream #2065, #4450, #5124) que se dispara
con Firefox como reproductor activo. El fix está en master, no en 0.15.0.

## Decisión

Volver a `mediaplayer.py` y no usar `mpris` mientras la versión empaquetada
sea 0.15.0.

## Consecuencias

- Se mantienen 219 líneas de Python y un proceso extra.
- A cambio, el fallo queda aislado: si el script muere, la barra sigue viva y
  solo pierde el título de la canción. Con el módulo nativo, un fallo del
  reproductor se lleva toda la barra.
- Criterio general: menos líneas no compensa convertir un fallo parcial en
  uno total.
