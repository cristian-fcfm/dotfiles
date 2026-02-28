#!/usr/bin/env bash
# Script para cambiar el tema de Waybar

DOTFILES="${DOTFILES:-$HOME/Documents/development/personal/dotfiles}"
THEMES_DIR="$DOTFILES/waybar/.config/waybar/themes"
COLORS_LINK="$DOTFILES/waybar/.config/waybar/colors.css"

list_themes() {
    echo "Temas disponibles:"
    for theme in "$THEMES_DIR"/*.css; do
        if [[ -f "$theme" ]]; then
            basename "$theme" .css
        fi
    done
}

get_current_theme() {
    if [[ -L "$COLORS_LINK" ]]; then
        local target=$(readlink -f "$COLORS_LINK")
        basename "$target" .css
    else
        echo "none"
    fi
}

set_theme() {
    local theme="$1"
    local theme_file="$THEMES_DIR/${theme}.css"

    if [[ ! -f "$theme_file" ]]; then
        echo "Error: Tema '$theme' no encontrado"
        echo ""
        list_themes
        return 1
    fi

    ln -sf "$theme_file" "$COLORS_LINK"
    echo "Tema cambiado a: $theme"

    # Recargar waybar si está corriendo
    if pgrep -x waybar > /dev/null; then
        pkill -SIGUSR1 waybar
        echo "Waybar recargado"
    fi
}

case "$1" in
    list|ls)
        list_themes
        ;;
    current)
        echo "Tema actual: $(get_current_theme)"
        ;;
    set)
        if [[ -z "$2" ]]; then
            echo "Uso: $0 set <tema>"
            echo ""
            list_themes
            exit 1
        fi
        set_theme "$2"
        ;;
    *)
        echo "Uso: $0 {list|current|set <tema>}"
        echo ""
        echo "Comandos:"
        echo "  list       - Lista los temas disponibles"
        echo "  current    - Muestra el tema actual"
        echo "  set <tema> - Cambia al tema especificado"
        exit 1
        ;;
esac
