#!/bin/bash

# Validación de argumento
if [ -z "$1" ]; then
  echo "❌ Debes especificar el nombre del cliente. Ej: ./tools/deploy/preview-dev.sh digin"
  exit 1
fi

CLIENT=$1
CLIENT_PATH="clients/$CLIENT/site"

echo "🔍 Cliente detectado: $CLIENT"
echo "📁 Ruta: $CLIENT_PATH"

# Validar existencia del package.json
if [ ! -f "$CLIENT_PATH/package.json" ]; then
  echo "❌ No se encontró package.json en $CLIENT_PATH"
  exit 1
fi

# Moverse al path del cliente
cd "$CLIENT_PATH" || exit 1

# Instalar dependencias si no existen
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependencias..."
  npm install
fi

# Ejecutar preview con Vite
echo "🚀 Ejecutando npm run preview..."
npm run preview