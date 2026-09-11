-- ============================================================================
-- Hyprland - punto de entrada
-- ============================================================================
-- Config en Lua en vez de hyprlang: docs/adr/0001-config-de-hyprland-en-lua.md
-- Referencia: https://wiki.hypr.land/Configuring/Start/

require("conf/appearance")
require("conf/input")
require("conf/monitors")
require("conf/rules")
require("conf/autostart")
require("conf/keybinds")
