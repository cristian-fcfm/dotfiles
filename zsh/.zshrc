# =============================================================================
# ZSH configuration
# =============================================================================

# =============================================================================
# PATH configuration
# =============================================================================
# Homebrew debe cargarse PRIMERO para que sus binarios estén disponibles
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Contexto de trabajo (proyecto, credenciales): específico de cada máquina,
# vive fuera del repo
[[ -f "$HOME/.config/zsh/work.zsh" ]] && source "$HOME/.config/zsh/work.zsh"

# Cargar paths del sistema (incluye /Library/TeX/texbin en macOS)
if [[ -x "/usr/libexec/path_helper" ]]; then
    eval "$(/usr/libexec/path_helper -s)"
fi

# =============================================================================
# Oh My Zsh Configuration
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"

# ─── Lazy loading para mejor performance ───────────────────────────────────
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# Plugins - Los esenciales para productividad
plugins=(
    git                      # Aliases útiles para git
    zsh-autosuggestions      # Sugerencias basadas en historial
    zsh-syntax-highlighting  # Resaltado de sintaxis en la terminal
    sudo                     # Doble ESC para anteponer sudo
    command-not-found        # Sugerencias cuando comando no existe
    colored-man-pages        # Man pages con colores
    dirhistory              # Alt+Left/Right para navegar directorios
)

# Configuración de actualizaciones
zstyle ':omz:update' mode reminder  # Solo recordatorios de actualización
zstyle ':omz:update' frequency 13   # Cada 13 días

# Performance optimizations
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Más rápido en repos grandes
COMPLETION_WAITING_DOTS="true"         # Feedback visual al completar

# Cargar Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# Environment Variables
# =============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export TERMINAL=kitty

# Para mejor integración con herramientas
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'

export FZF_DEFAULT_OPTS='
--height 60%
--layout=reverse
--border rounded
--info=inline
--preview "bat --style=numbers --color=always --line-range :500 {}"
--preview-window=right:50%:wrap
--bind "ctrl-/:toggle-preview"
--bind "ctrl-u:preview-half-page-up"
--bind "ctrl-d:preview-half-page-down"
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
'

# =============================================================================
# Starship Prompt
# =============================================================================
eval "$(starship init zsh)"

# =============================================================================
# Yazi Integration
# =============================================================================
# Función mejorada para Yazi con cd al salir
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# =============================================================================
# Aliases
# =============================================================================

# ─── Yazi ───────────────────────────────────────────────────────────────────
alias yy='y .'                  # Abrir Yazi en directorio actual
alias yc='y ~/.config'          # Abrir Yazi en config
alias yn='y ~/.config/nvim'     # Abrir Yazi en config de Neovim

# ─── Listado de archivos ────────────────────────────────────────────────────
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltr'              # Ordenar por fecha de modificación
alias lh='ls -lh'               # Tamaños legibles

# Eza aliases (herramienta moderna de ls)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first --header'
    alias la='eza -la --icons --group-directories-first --header'
    alias lt='eza -l --sort=modified --icons --group-directories-first --header'
    alias lsize='eza -l --sort=size --icons --group-directories-first --header'
    alias tree='eza --tree --icons --level=3'
    alias tree2='eza --tree --icons --level=2'
    alias ltree='eza --tree --icons --long --level=2'
else
    # GNU ls y BSD ls no comparten el flag de color
    case "$(uname -s)" in
        Darwin*) alias ls='ls -G' ;;
        *) alias ls='ls --color=auto' ;;
    esac
fi

# ─── Git ────────────────────────────────────────────────────────────────────
# gst, gco, gp, gl y glog ya los define el plugin git de Oh My Zsh. gcm se
# sobreescribe a propósito: OMZ lo define como checkout de la rama main.
alias gcm='git commit -m'

# ─── Lazygit ────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ─── Tmux (for remote SSH sessions only) ─────────────────────────────────────
alias t='tmux'
alias ta='tmux attach-session -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tkill='tmux kill-session -t'

# ─── Neovim ─────────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'
alias nvconfig='nvim ~/.config/nvim/'

# ─── Kitty ──────────────────────────────────────────────────────────────────
alias icat='kitty +kitten icat'
alias kssh='kitty +kitten ssh'
alias kdiff='kitty +kitten diff'

# ─── UV shortcuts ──────────────────────────────────────────────────────────
alias uvlist='uv python list'
alias uvinfo='uv --version'
alias uvclean='uv cache clean'
alias ds='source .venv/bin/activate'  # Activar entorno virtual rápidamente

# ─── Sistema ────────────────────────────────────────────────────────────────
alias df='df -h'                # Tamaños legibles
alias du='du -h'                # Tamaños legibles
alias free='free -h'            # Memoria en formato legible
alias ps='ps aux'               # Procesos detallados

# ─── Seguridad ──────────────────────────────────────────────────────────────
alias rm='rm -i'                # Confirmación antes de borrar
alias cp='cp -i'                # Confirmación antes de sobrescribir
alias mv='mv -i'                # Confirmación antes de mover

# ─── Utilidades ─────────────────────────────────────────────────────────────
alias h='history'
alias j='jobs -l'
alias jp='jobs -p'
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'

# =============================================================================
# Custom Functions
# =============================================================================

# Crear directorio y entrar en él
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos con fzf y abrir en Neovim
fv() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {}') && nvim "$file"
}

# Git branch con fzf
fbr() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# ─── Gestion de trabajos (jobs) ─────────────────────────────────────────────
# fj [n]  - Traer job a foreground       (default: el mas reciente)
# bj [n]  - Reanudar job en background   (default: el mas reciente)
# kj [n]  - Matar job                    (default: el mas reciente)
# dj [n]  - Desacoplar job de la terminal (default: el mas reciente)
fj() { fg "%${1:-+}"; }
bj() { bg "%${1:-+}"; }
kj() { kill "%${1:-+}"; }
dj() { disown "%${1:-+}"; }

# =============================================================================
# Keybindings
# =============================================================================
# Ctrl+Z mejorado: Si la linea esta vacia, ejecuta 'fg' (trae ultimo job).
#                  Si no esta vacia, funciona como siempre (push-input).
ctrl-z() {
    if [[ -z $BUFFER ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
    fi
}
zle -N ctrl-z
bindkey '^Z' ctrl-z

# =============================================================================
# OS-Specific Settings
# =============================================================================

# Detectar el sistema operativo
case "$(uname -s)" in
    Darwin*)
        # macOS específico
        alias updatedb='/usr/libexec/locate.updatedb'
        ;;
    Linux*)
        # Linux específico
        # Para Arch Linux con yay
        if command -v yay &> /dev/null; then
            alias update='yay -Syu'
            alias install='yay -S'
            alias search='yay -Ss'
            alias remove='yay -R'
        fi
        ;;
esac

# =============================================================================
# Additional Tool Loading
# =============================================================================

# Zoxide (mejor cd) - navegación inteligente
# Todos los aliases que dependen de `z` viven aquí: si zoxide falta,
# desaparecen juntos en vez de quedarse apuntando a un comando inexistente.
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias zz='z -'        # Ir al directorio anterior
    alias ..='z ..'
    alias ...='z ../..'
    alias ....='z ../../..'
    alias .....='z ../../../..'
    alias home='z ~'
    alias config='z ~/.config'
    alias downloads='z ~/Downloads'
    alias documents='z ~/Documents'
    alias projects='z ~/Documents/development/'
    alias dots='z ~/Documents/development/personal/dotfiles/'
    alias proj='z ~/Documents/development/ && ll'
    alias dotslg='z ~/Documents/development/personal/dotfiles/ && lg'
fi

# fzf keybindings y completion - si está instalado
if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
fi
if [ -f /usr/share/fzf/completion.zsh ]; then
    source /usr/share/fzf/completion.zsh
fi

# Para macOS con Homebrew
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

# =============================================================================
# End of Configuration
# =============================================================================
