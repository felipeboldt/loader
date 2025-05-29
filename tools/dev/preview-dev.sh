#!/bin/bash

# Nombre del cliente (ej: digin)
CLIENT=$1

if [ -z "$CLIENT" ]; then
  echo "Uso: sh tools/dev/preview-dev.sh <cliente>"
  exit 1
fi

echo "📦 Preparando preview para cliente: $CLIENT"
cd clients/$CLIENT/site || exit

echo "📥 Instalando dependencias..."
npm install

echo "🚀 Levantando preview local con Vite..."
npm run preview