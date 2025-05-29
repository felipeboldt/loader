#!/bin/bash

# Argumento: nombre del cliente
CLIENT=$1

# Rutas relevantes
SITE_PATH="clients/$CLIENT/site"
DIST_PATH="$SITE_PATH/dist"
CONFIG_PATH="clients/$CLIENT/config.json"

# Validar existencia de config.json
if [ ! -f "$CONFIG_PATH" ]; then
  echo "❌ No se encontró archivo de configuración en $CONFIG_PATH"
  exit 1
fi

# Extraer bucket desde el config.json del cliente
BUCKET=$(jq -r '.bucket' "$CONFIG_PATH")

# Validar que el bucket no esté vacío
if [ -z "$BUCKET" ] || [ "$BUCKET" == "null" ]; then
  echo "❌ No se encontró una propiedad válida 'bucket' en $CONFIG_PATH"
  exit 1
fi

echo "🚀 Publicando sitio $CLIENT a producción (bucket S3)..."
echo "📁 Ruta local: $DIST_PATH"
echo "🪣 Bucket destino: s3://$BUCKET"

# Verificar que el directorio de build exista
if [ ! -d "$DIST_PATH" ]; then
  echo "❌ No se encontró el directorio de build en $DIST_PATH. Ejecuta primero 'npm run build'."
  exit 1
fi

# Validar si el bucket existe y es accesible
aws s3 ls "s3://$BUCKET" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "❌ El bucket 's3://$BUCKET' no existe o no tienes permisos para acceder a él."
  exit 1
fi

# Sincronizar contenido al bucket S3
aws s3 sync "$DIST_PATH" "s3://$BUCKET" --delete

# Validar resultado
if [ $? -eq 0 ]; then
  echo "✅ Sitio $CLIENT publicado correctamente en producción."
else
  echo "❌ Falló la publicación en producción."
  exit 1
fi