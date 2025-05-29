#!/bin/bash

# Validación de argumento
if [ -z "$1" ]; then
  echo "❌ Debes especificar el nombre del cliente. Ej: ./tools/deploy/deploy-dev.sh digin"
  exit 1
fi

CLIENT=$1
CLIENT_PATH="clients/$CLIENT/site"

echo "🔍 Cliente detectado: $CLIENT"
echo "📁 Ruta del sitio: $CLIENT_PATH"

# Validar existencia de package.json
if [ ! -f "$CLIENT_PATH/package.json" ]; then
  echo "❌ No se encontró package.json en $CLIENT_PATH"
  exit 1
fi

# Cambiar a directorio del cliente
cd "$CLIENT_PATH" || exit 1

# Instalar dependencias si no están presentes
if [ ! -d "node_modules" ]; then
  echo "📦 Instalando dependencias..."
  npm install
fi

# Ejecutar build
echo "🏗️  Generando build con Vite..."
npm run build

# Validar que el directorio dist/ se haya generado
if [ ! -d "dist" ]; then
  echo "❌ No se generó el directorio dist/. Verifica errores en el build."
  exit 1
fi

# Confirmación final
echo "✅ Build generado exitosamente en $CLIENT_PATH/dist"