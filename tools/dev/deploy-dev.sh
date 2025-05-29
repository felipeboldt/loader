#!/bin/zsh

# Nombre del cliente (ej: digin)
CLIENT=$1
MSG=$2

if [ -z "$CLIENT" ] || [ -z "$MSG" ]; then
  echo "Uso: sh tools/dev/deploy-dev.sh <cliente> \"mensaje del commit\""
  exit 1
fi

echo "📦 Cambios en cliente: $CLIENT"
cd clients/$CLIENT/site || exit

# Verifica si estás en la rama dev
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "dev" ]; then
  echo "🔀 Cambiando a la rama 'dev'..."
  git checkout dev
fi

# Commit y push
git add .
git commit -m "$MSG"
git push origin dev

# Mensaje para el usuario
echo "✅ Código enviado a la rama 'dev'."
echo "🚀 Abre Codespaces para probarlo en preview:"
echo "👉 https://github.com/<USUARIO>/<REPO>/codespaces"

# Si estás en macOS, abre GitHub
open "https://github.com/$(git config user.name)/loader/codespaces" > /dev/null 2>&1