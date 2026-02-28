#!/usr/bin/env bash
# Convierte temas JSON de .themes/colors/ a CSS para Waybar

convert_json_to_css() {
    local json="$1"
    local output="$2"

    # Extraer colores del JSON
    bg=$(jq -r '."background-color"' "$json")
    fg=$(jq -r '."foreground-color"' "$json")
    highlight_bg=$(jq -r '."highlight-background-color"' "$json")

    # Extraer paleta completa
    readarray -t palette < <(jq -r '.palette[]' "$json")

    # Generar archivo CSS
    cat > "$output" <<EOF
/* Tema generado desde: $(basename "$json") */
@define-color background ${bg};
@define-color foreground ${fg};
@define-color surface alpha(${bg}, 0.85);
@define-color surface-alpha alpha(${bg}, 0.6);
@define-color border alpha(${fg}, 0.15);
@define-color border-hover alpha(${fg}, 0.25);

/* Colores de acento desde paleta */
@define-color accent ${palette[4]};
@define-color blue ${palette[4]};
@define-color green ${palette[2]};
@define-color yellow ${palette[3]};
@define-color orange ${palette[3]};
@define-color red ${palette[1]};
@define-color mauve ${palette[5]};
@define-color teal ${palette[6]};
@define-color sky ${palette[7]};

/* Estados */
@define-color critical ${palette[1]};
@define-color warning ${palette[3]};
@define-color success ${palette[2]};
@define-color info ${palette[4]};

/* Gradientes */
@define-color gradient-1 ${palette[2]};
@define-color gradient-2 ${palette[4]};
@define-color gradient-3 ${palette[5]};
@define-color gradient-4 ${palette[6]};
@define-color gradient-5 ${palette[7]};
EOF

    echo "Convertido: $(basename "$json") → $output"
}

# Directorios
JSON_DIR="$HOME/.themes/colors"
THEMES_DIR="$HOME/.config/waybar/themes"

# Crear directorio de temas si no existe
mkdir -p "$THEMES_DIR"

# Convertir todos los JSON
for json_file in "$JSON_DIR"/*.json; do
    if [[ -f "$json_file" ]]; then
        theme_name=$(basename "$json_file" .json)
        css_file="$THEMES_DIR/${theme_name}.css"
        convert_json_to_css "$json_file" "$css_file"
    fi
done

echo "Conversión completada. Temas disponibles en: $THEMES_DIR"
