#!/bin/bash

# Detectar nombre del cliente según el path actual
CLIENT=$(basename "$(dirname "$PWD")")

echo "🔍 Cliente detectado: $CLIENT"
echo "🚀 Iniciando entorno de desarrollo con Vite..."

# Validar existencia de package.json
if [ ! -f "package.json" ]; then
  echo "❌ No se encontró package.json en $(pwd)"
  exit 1
fi

# Instalar dependencias si no existen
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependencias..."
  npm install
fi

# Ejecutar preview con Vite
npm run preview