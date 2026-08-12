#!/bin/bash
# Sincroniza el vault de notas con su remoto git. Lo dispara notes-sync.timer.
# Idempotente: sin cambios locales no crea commits.

set -uo pipefail

VAULT="${NOTES_VAULT:-$HOME/Documents/notes}"

avisar() {
  command -v notify-send >/dev/null 2>&1 && notify-send -u critical "notes-sync" "$1"
  echo "notes-sync: $1" >&2
}

cd "$VAULT" 2>/dev/null || {
  avisar "No existe el vault en $VAULT"
  exit 1
}

git rev-parse --git-dir >/dev/null 2>&1 || {
  avisar "$VAULT no es un repositorio git"
  exit 1
}

# La rama se lee del repo, no se asume.
RAMA="$(git symbolic-ref --short HEAD 2>/dev/null)"
[ -n "$RAMA" ] || {
  avisar "HEAD desacoplado en $VAULT"
  exit 1
}

# Un rebase o merge a medias es un conflicto sin resolver: no tocar el repo.
if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] ||
  [ -d "$(git rev-parse --git-dir)/rebase-apply" ] ||
  [ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]; then
  avisar "Hay un rebase/merge sin terminar: resuélvelo a mano"
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -q -m "auto-sync: $(hostname) $(date '+%Y-%m-%d %H:%M')"
fi

if ! git pull --rebase --autostash --quiet origin "$RAMA"; then
  git rebase --abort 2>/dev/null
  avisar "Conflicto al integrar cambios remotos: resuélvelo a mano"
  exit 1
fi

if ! git push --quiet origin "$RAMA"; then
  avisar "No se pudo hacer push a origin/$RAMA"
  exit 1
fi

echo "notes-sync: $VAULT sincronizado con origin/$RAMA"
