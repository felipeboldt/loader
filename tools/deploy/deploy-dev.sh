#!/bin/bash

# Detectar nombre del cliente desde el path actual
CLIENT=$(basename "$(dirname "$PWD")")

echo "🔍 Cliente detectado: $CLIENT"
echo "🛠️ Ejecutando build de Vite para $CLIENT..."

# Validar package.json
if [ ! -f "package.json" ]; then
  echo "❌ No se encontró package.json en $(pwd)"
  exit 1
fi

# Instalar dependencias si es necesario
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependencias..."
  npm install
fi

# Lint
echo "🔍 Ejecutando linters..."
npm run lint || {
  echo "❌ Linter falló. Corrige los errores antes de continuar.";
  exit 1;
}

# Build del sitio
echo "🏗️ Compilando el sitio..."
npm run build

# Commit y push
echo "💾 Commiteando build dist/"
cd ../../../..  # Volver a raíz del proyecto
git add clients/$CLIENT/site/dist/
git commit -m "build($CLIENT): generar versión optimizada para dev"
git push origin dev

echo "✅ ¡Listo! Ahora puedes revisar el build en Codespaces"