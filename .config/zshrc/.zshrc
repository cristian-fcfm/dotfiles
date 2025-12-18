# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                              ZSH Configuration                             ║
# ║                     Optimized for Neovim + Kitty + Yazi                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                              PATH Configuration                           │
# └───────────────────────────────────────────────────────────────────────────┘
# Homebrew debe cargarse PRIMERO para que sus binarios estén disponibles
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                           Oh My Zsh Configuration                         │
# └───────────────────────────────────────────────────────────────────────────┘
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
    extract                  # Función universal para extraer archivos
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

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                           Environment Variables                           │
# └───────────────────────────────────────────────────────────────────────────┘
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

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                              Starship Prompt                              │
# └───────────────────────────────────────────────────────────────────────────┘
eval "$(starship init zsh)"

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                             Yazi Integration                              │
# └───────────────────────────────────────────────────────────────────────────┘
# Función mejorada para Yazi con cd al salir
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                 Aliases                                    │
# └───────────────────────────────────────────────────────────────────────────┘

# ─── Yazi ───────────────────────────────────────────────────────────────────
alias yy='y .'                  # Abrir Yazi en directorio actual
alias yc='y ~/.config'          # Abrir Yazi en config
alias yn='y ~/.config/nvim'     # Abrir Yazi en config de Neovim

# ─── Navegación ─────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# ─── Listado de archivos (con colores) ─────────────────────────────────────
alias ls='ls --color=auto'
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
fi

# ─── Git (adicionales a los de Oh My Zsh) ──────────────────────────────────
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

# ─── Lazygit ────────────────────────────────────────────────────────────────
alias lg='lazygit'
alias lazygit='lazygit'

# ─── Tmux ───────────────────────────────────────────────────────────────────
alias t='tmux'
alias ta='tmux attach-session -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tkill='tmux kill-session -t'
alias tkillall='tmux kill-server'
alias tw='tmux new-session -As work -c ~/Documents/development/work'
alias tp='tmux new-session -As personal -c ~/Documents/development/personal'
alias tnotes='tmux new-session -As notes'
alias tconfig='tmux new-session -As config -c ~/Documents/development/personal/dotfiles'

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
alias which='type -a'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.zshrc'
alias zshconfig='nvim ~/.zshrc'

# ─── Directorios rápidos ────────────────────────────────────────────────────
alias config='z ~/.config'
alias downloads='z ~/Downloads'
alias documents='z ~/Documents'
alias projects='z ~/Documents/development/'
alias dots='z ~/Documents/development/personal/dotfiles/'

# ─── Navegación mejorada con zoxide ────────────────────────────────────────
alias ..='z ..'
alias ...='z ../..'
alias home='z ~'

# ─── Combinaciones útiles ───────────────────────────────────────────────────
alias proj='z ~/Documents/development/ && ll'           # Ir a proyectos y listar
alias dotslg='z ~/Documents/development/personal/dotfiles/ && lg'         # Ir a dotfiles y abrir lazygit

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                             Custom Functions                               │
# └───────────────────────────────────────────────────────────────────────────┘

# Crear directorio y entrar en él
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Buscar archivos con fzf y abrir en Neovim
fv() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {}') && nvim "$file"
}

# Buscar en el historial con fzf
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Cambiar a directorio con fzf
fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

# Git branch con fzf
fbr() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# ─── Funciones Git avanzadas ───────────────────────────────────────────────
# Función para abrir lazygit en el directorio del proyecto actual
lgp() {
    # Buscar el directorio raíz del repositorio git
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo " Abriendo Lazygit en: $(basename "$git_root")"
        cd "$git_root" && lazygit
    else
        echo " No estás en un repositorio Git"
        echo " ¿Quieres inicializar uno aquí? (git init)"
    fi
}

# Función para hacer commit rápido con lazygit
lgc() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        lazygit --filter='+refs/heads/'
    else
        echo "  No estás en un repositorio Git"
    fi
}

# Función para clonar y abrir en lazygit
clone_and_lg() {
    if [ -z "$1" ]; then
        echo "   Uso: clone_and_lg <url_del_repositorio>"
        return 1
    fi
    
    local repo_name
    repo_name=$(basename "$1" .git)
    
    echo " Clonando $repo_name..."
    git clone "$1" && cd "$repo_name" && lazygit
}

# ─── Funciones Tmux ─────────────────────────────────────────────────────────
# Función para crear sesión tmux con nombre del proyecto
tmux-new() {
    if [ -z "$1" ]; then
        local session_name=$(basename "$PWD")
    else
        local session_name="$1"
    fi
    tmux new-session -s "$session_name"
}

# Función para adjuntar a sesión tmux con fzf
tmux-attach() {
    if ! command -v fzf &> /dev/null; then
        echo " fzf no está instalado. Usa 'ta <nombre>' directamente."
        return 1
    fi

    local session
    session=$(tmux list-sessions -F "#S" 2>/dev/null | fzf --prompt="󱘖 Select tmux session: " --height 40% --border rounded) && tmux attach-session -t "$session"
}

# Función para matar sesión tmux con fzf
tmux-kill() {
    if ! command -v fzf &> /dev/null; then
        echo " fzf no está instalado. Usa 'tkill <nombre>' directamente."
        return 1
    fi

    local session
    session=$(tmux list-sessions -F "#S" 2>/dev/null | fzf --prompt=" Kill tmux session: " --height 40% --border rounded) && tmux kill-session -t "$session"
}

# Auto-attach a tmux si no estamos en una sesión (solo en SSH)
if [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    tmux attach-session -t default || tmux new-session -s default
fi

# ─── Funciones para Data Science ───────────────────────────────────────────
# Crear proyecto de data science con UV
create_ds_env() {
    uv init --python 3.11
    
    uv add numpy pandas matplotlib scikit-learn

    echo " Entorno virtual creado"
    echo " Actívalo con: source .venv/bin/activate"
}

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                          OS-Specific Settings                              │
# └───────────────────────────────────────────────────────────────────────────┘

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

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                         Additional Tool Loading                            │
# └───────────────────────────────────────────────────────────────────────────┘

# Zoxide (mejor cd) - navegación inteligente
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias zz='z -'        # Ir al directorio anterior
    alias zi='zi'         # Buscar directorio interactivamente
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

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                            End of Configuration                            ║
# ╚═══════════════════════════════════════════════════════════════════════════╝
