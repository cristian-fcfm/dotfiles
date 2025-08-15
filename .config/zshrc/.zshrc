# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                              ZSH Configuration                              ║
# ║                     Optimized for Neovim + Kitty + Yazi                    ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                              PATH Configuration                            │
# └───────────────────────────────────────────────────────────────────────────┘
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                           Oh My Zsh Configuration                          │
# └───────────────────────────────────────────────────────────────────────────┘
export ZSH="$HOME/.oh-my-zsh"

# Tema - Comentado porque usas Starship
# ZSH_THEME="robbyrussell"

# Plugins - Los esenciales para productividad
plugins=(
    git                      # Aliases útiles para git
    zsh-autosuggestions      # Sugerencias basadas en historial
    zsh-syntax-highlighting  # Resaltado de sintaxis en la terminal
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
# │                           Environment Variables                            │
# └───────────────────────────────────────────────────────────────────────────┘
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export TERMINAL=kitty

# Para mejor integración con herramientas
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range :500 {}"'

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                          Conda/Mamba Configuration                         │
# └───────────────────────────────────────────────────────────────────────────┘

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/usr/local/Caskroom/miniforge/base/bin/mamba'
export MAMBA_ROOT_PREFIX='/usr/local/Caskroom/miniforge/base'
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup
# <<< mamba initialize <<<

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                              Starship Prompt                               │
# └───────────────────────────────────────────────────────────────────────────┘
eval "$(starship init zsh)"

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                             Yazi Integration                               │
# └───────────────────────────────────────────────────────────────────────────┘
# Función mejorada para Yazi con cd al salir
function ya() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                              AWS Configuration                             │
# └───────────────────────────────────────────────────────────────────────────┘

# ─── AWS Profile Management ────────────────────────────────────────────────
# Aliases para cambiar perfiles AWS rápidamente
alias aws-prod='export AWS_PROFILE="632266566629_DataScientistAnalyticsOperator" && echo "✅ AWS Profile: PRODUCTION"'
alias aws-dev='export AWS_PROFILE="260306441297_DataScientistAnalyticsOperator" && echo "✅ AWS Profile: DEVELOPMENT"'
alias aws-profile='echo "🔍 Current AWS Profile: ${AWS_PROFILE:-default}"'
alias aws-clear='unset AWS_PROFILE && echo "🔄 AWS Profile cleared (using default)"'

# ─── AWS Utility Functions ─────────────────────────────────────────────────
# Función para mostrar información del perfil actual
aws-info() {
    if [[ -z "$AWS_PROFILE" ]]; then
        echo "📋 Using default AWS profile"
    else
        echo "🔍 Current AWS Profile: $AWS_PROFILE"
        if [[ "$AWS_PROFILE" == *"632266566629"* ]]; then
            echo "🏢 Environment: PRODUCTION"
            echo "⚠️  CUIDADO: Estás en producción!"
        elif [[ "$AWS_PROFILE" == *"260306441297"* ]]; then
            echo "🏢 Environment: DEVELOPMENT" 
            echo "🚀 Perfecto para desarrollo"
        fi
    fi
    
    # Mostrar información de la cuenta si AWS CLI está configurado
    if command -v aws &> /dev/null; then
        echo "📊 Account Info:"
        aws sts get-caller-identity 2>/dev/null || echo "❌ No se pudo obtener información de la cuenta"
    fi
}

# Función para listar todos los perfiles disponibles
aws-list() {
    echo "📋 AWS Profiles disponibles:"
    if [ -f ~/.aws/config ]; then
        grep '\[profile' ~/.aws/config | sed 's/\[profile \(.*\)\]/  📦 \1/'
    fi
    if [ -f ~/.aws/credentials ]; then
        grep '\[' ~/.aws/credentials | grep -v 'profile' | sed 's/\[\(.*\)\]/  🔑 \1/'
    fi
    echo ""
    aws-info
}

# Función interactiva para cambiar perfiles con fzf
aws-switch() {
    if ! command -v fzf &> /dev/null; then
        echo "❌ fzf no está instalado. Usa aws-dev o aws-prod directamente."
        return 1
    fi
    
    local profiles=()
    profiles+=("632266566629_DataScientistAnalyticsOperator  🏢 PRODUCTION")
    profiles+=("260306441297_DataScientistAnalyticsOperator  🚀 DEVELOPMENT")
    profiles+=("default  📋 DEFAULT")
    profiles+=("clear  🔄 CLEAR PROFILE")
    
    local choice
    choice=$(printf '%s\n' "${profiles[@]}" | fzf --height 40% --layout=reverse --border --prompt="🔍 Select AWS Profile: ")
    
    if [[ -n "$choice" ]]; then
        local profile_name=$(echo "$choice" | awk '{print $1}')
        case "$profile_name" in
            "632266566629_DataScientistAnalyticsOperator")
                aws-prod
                ;;
            "260306441297_DataScientistAnalyticsOperator")
                aws-dev
                ;;
            "clear")
                aws-clear
                ;;
            "default")
                export AWS_PROFILE=""
                echo "📋 Using default AWS profile"
                ;;
        esac
        aws-info
    fi
}

# Función para verificar conexión AWS
aws-test() {
    if ! command -v aws &> /dev/null; then
        echo "❌ AWS CLI no está instalado"
        return 1
    fi
    
    echo "🔍 Testing AWS connection..."
    if aws sts get-caller-identity > /dev/null 2>&1; then
        echo "✅ AWS connection successful"
        aws-info
    else
        echo "❌ AWS connection failed"
        echo "💡 Verifica tus credenciales y perfil"
    fi
}

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                                 Aliases                                    │
# └───────────────────────────────────────────────────────────────────────────┘

# ─── Yazi ───────────────────────────────────────────────────────────────────
alias y='ya'                    # Abrir Yazi
alias yy='ya .'                 # Abrir Yazi en directorio actual
alias yc='ya ~/.config'         # Abrir Yazi en config
alias yn='ya ~/.config/nvim'    # Abrir Yazi en config de Neovim

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

# ─── Python/Data Science ────────────────────────────────────────────────────
alias py='python'
alias ipy='ipython --no-autoindent'
alias jl='jupyter lab'
alias jn='jupyter notebook'

# ─── Conda/Mamba shortcuts ─────────────────────────────────────────────────
alias condalist='mamba env list'
alias condainfo='mamba info'
alias condaclean='mamba clean -a'
alias ds='mamba activate datascience'  # Activar entorno de data science rápidamente
alias base='mamba activate base'       # Volver al entorno base

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
        echo "🚀 Abriendo Lazygit en: $(basename "$git_root")"
        cd "$git_root" && lazygit
    else
        echo "❌ No estás en un repositorio Git"
        echo "💡 ¿Quieres inicializar uno aquí? (git init)"
    fi
}

# Función para hacer commit rápido con lazygit
lgc() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        lazygit --filter='+refs/heads/'
    else
        echo "❌ No estás en un repositorio Git"
    fi
}

# Función para clonar y abrir en lazygit
clone_and_lg() {
    if [ -z "$1" ]; then
        echo "❌ Uso: clone_and_lg <url_del_repositorio>"
        return 1
    fi
    
    local repo_name
    repo_name=$(basename "$1" .git)
    
    echo "📦 Clonando $repo_name..."
    git clone "$1" && cd "$repo_name" && lazygit
}

# ─── Funciones para Data Science ───────────────────────────────────────────
# Crear entorno de data science completo
create_ds_env() {
    local env_name=${1:-datascience}
    echo "🐍 Creando entorno de data science: $env_name"
    mamba create -n $env_name python=3.11 \
        numpy pandas matplotlib seaborn plotly \
        scikit-learn xgboost lightgbm \
        jupyter notebook jupyterlab \
        statsmodels scipy \
        openpyxl xlrd sqlalchemy \
        tqdm ipywidgets \
        -y
    echo "✅ Entorno '$env_name' creado exitosamente"
    echo "💡 Actívalo con: mamba activate $env_name"
}

# Instalar paquetes adicionales en el entorno actual
install_ml_extras() {
    echo "🚀 Instalando paquetes adicionales de ML..."
    mamba install catboost shap optuna -y
    echo "✅ Paquetes instalados"
}

# Función para mostrar información del entorno actual
env_info() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "🌍 Entorno actual: $CONDA_DEFAULT_ENV"
        echo "🐍 Python: $(python --version)"
        echo "📦 Paquetes principales:"
        mamba list | grep -E "(numpy|pandas|matplotlib|scikit-learn|jupyter)" | awk '{print "   " $1 " " $2}'
    else
        echo "❌ No hay entorno conda/mamba activo"
    fi
}

# ─── Gestión avanzada de entornos virtuales ───────────────────────────────
# Lista entornos con información detallada
envs() {
    echo "🌍 Entornos disponibles:"
    mamba env list | tail -n +3 | while read name path; do
        if [[ "$name" == "$CONDA_DEFAULT_ENV" ]]; then
            echo "   ✅ $name (activo) - $path"
        else
            echo "   📦 $name - $path"
        fi
    done
}

# Activar entorno con autocompletado
activate() {
    if [[ -z "$1" ]]; then
        echo "📋 Entornos disponibles:"
        mamba env list | tail -n +3 | awk '{print "   " $1}'
        echo "💡 Uso: activate <nombre_entorno>"
        return 1
    fi
    mamba activate "$1"
    echo "✅ Entorno '$1' activado"
    env_info
}

# Crear entorno rápido con Python específico
mkenv() {
    local env_name="${1:-myenv}"
    local python_version="${2:-3.11}"
    
    echo "🐍 Creando entorno: $env_name con Python $python_version"
    mamba create -n "$env_name" python="$python_version" -y
    echo "✅ Entorno '$env_name' creado"
    echo "💡 Actívalo con: activate $env_name"
}

# Eliminar entorno con confirmación
rmenv() {
    if [[ -z "$1" ]]; then
        echo "❌ Especifica el nombre del entorno"
        echo "📋 Entornos disponibles:"
        mamba env list | tail -n +3 | awk '{print "   " $1}'
        return 1
    fi
    
    if [[ "$1" == "base" ]]; then
        echo "⚠️  No puedes eliminar el entorno 'base'"
        return 1
    fi
    
    echo "⚠️  ¿Estás seguro de eliminar el entorno '$1'? (y/N)"
    read -q "response"
    echo
    if [[ "$response" =~ ^[Yy]$ ]]; then
        mamba env remove -n "$1"
        echo "🗑️  Entorno '$1' eliminado"
    else
        echo "❌ Operación cancelada"
    fi
}

# Exportar entorno actual
export_env() {
    if [[ -z "$CONDA_DEFAULT_ENV" ]]; then
        echo "❌ No hay entorno activo"
        return 1
    fi
    
    local filename="${1:-${CONDA_DEFAULT_ENV}_environment.yml}"
    mamba env export > "$filename"
    echo "📄 Entorno '$CONDA_DEFAULT_ENV' exportado a: $filename"
}

# Importar entorno desde archivo
import_env() {
    if [[ -z "$1" ]]; then
        echo "❌ Especifica el archivo environment.yml"
        echo "💡 Uso: import_env <archivo.yml> [nombre_entorno]"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "❌ El archivo '$1' no existe"
        return 1
    fi
    
    local env_name="$2"
    if [[ -n "$env_name" ]]; then
        mamba env create -f "$1" -n "$env_name"
        echo "✅ Entorno '$env_name' creado desde $1"
    else
        mamba env create -f "$1"
        echo "✅ Entorno creado desde $1"
    fi
}

# ┌───────────────────────────────────────────────────────────────────────────┐
# │                          OS-Specific Settings                              │
# └───────────────────────────────────────────────────────────────────────────┘

# Detectar el sistema operativo
case "$(uname -s)" in
    Darwin*)
        # macOS específico
        alias updatedb='/usr/libexec/locate.updatedb'
        
        # Homebrew
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
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
