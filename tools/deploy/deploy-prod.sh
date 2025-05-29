#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
  echo "❌ Debes indicar el nombre del cliente"
  exit 1
fi

SITE_PATH="clients/$CLIENT/site"
CONFIG_PATH="clients/$CLIENT/config.json"

if [ ! -d "$SITE_PATH/dist" ]; then
  echo "❌ No se encontró la carpeta de build: $SITE_PATH/dist"
  exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
  echo "❌ No se encontró archivo de configuración en $CONFIG_PATH"
  exit 1
fi

# Extraer bucket desde config.json
BUCKET=$(jq -r '.bucket' "$CONFIG_PATH")

if [ "$BUCKET" == "null" ] || [ -z "$BUCKET" ]; then
  echo "❌ El bucket no está definido correctamente en $CONFIG_PATH"
  exit 1
fi

echo "🚀 Publicando sitio $CLIENT a producción (bucket S3)..."
echo "📁 Ruta local: $SITE_PATH/dist"
echo "🪣 Bucket destino: s3://$BUCKET"

# Subir archivos
aws s3 sync "$SITE_PATH/dist" "s3://$BUCKET" --delete

if [ $? -eq 0 ]; then
  echo "✅ Sitio $CLIENT publicado correctamente en producción."
else
  echo "❌ Error al publicar el sitio."
fi