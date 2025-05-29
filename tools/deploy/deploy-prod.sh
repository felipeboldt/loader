# ./tools/deploy/deploy-prod.sh
#!/bin/bash

CLIENT=$1

if [ -z "$CLIENT" ]; then
  echo "❌ Debes indicar el nombre del cliente (ej: ./deploy-prod.sh digin)"
  exit 1
fi

SITE_PATH="clients/$CLIENT/site"
DIST_PATH="$SITE_PATH/dist"
BUCKET="www.digin.cl"

echo "🚀 Publicando sitio $CLIENT a producción (bucket S3)..."
echo "📁 Ruta local: $DIST_PATH"
echo "🪣 Bucket destino: s3://$BUCKET/$CLIENT"

# Validar si el build existe
if [ ! -d "$DIST_PATH" ]; then
  echo "❌ No se encontró la carpeta dist. ¿Ejecutaste vite build?"
  exit 1
fi

# Subir a S3
aws s3 sync "$DIST_PATH/" "s3://$BUCKET/$CLIENT" --delete || exit 1

echo "✅ Sitio $CLIENT publicado correctamente en producción."