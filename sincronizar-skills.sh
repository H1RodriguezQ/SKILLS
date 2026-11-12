#!/usr/bin/env bash
# Sincroniza las skills del cerebro:
#   .claude/skills -> .agents/skills (otros agentes)
#   .claude/skills -> ~/.claude/skills (todos los proyectos)
# Solo copia las skills de este repo; no toca otras skills de la carpeta global.
set -euo pipefail
repo="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$repo/.agents/skills" "$HOME/.claude/skills"
for s in "$repo"/.claude/skills/*/; do
  n="$(basename "$s")"
  for dest in "$repo/.agents/skills" "$HOME/.claude/skills"; do
    rm -rf "${dest:?}/$n"
    cp -r "$s" "$dest/$n"
  done
  echo "OK  $n"
done
echo "Listo. Abre una sesión nueva de Claude Code para ver los cambios."
