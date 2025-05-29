#!/bin/bash

# 🚀 Script para crear estructura base de un sitio estático por cliente
# Autor: tu Tech Advisor ✌️
# Uso: ./tools/deploy/create-static-site.sh nombreCliente

# --- Validación inicial ---
CLIENT=$1

if [ -z "$CLIENT" ]; then
  echo "❌ Debes ingresar el nombre del cliente. Ejemplo:"
  echo "./tools/deploy/create-static-site.sh digin"
  exit 1
fi

SITE_DIR="clients/$CLIENT/site"
WORKFLOW_DIR=".github/workflows"

echo "🛠️ Creando estructura para $CLIENT..."

# --- Crear carpetas base ---
mkdir -p "$SITE_DIR/css" "$SITE_DIR/js" "$WORKFLOW_DIR"

# --- HTML base ---
cat > "$SITE_DIR/index.html" <<EOL
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$CLIENT Site</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
  <h1>Bienvenido al sitio de $CLIENT</h1>
  <script src="js/script.js"></script>
</body>
</html>
EOL

# --- CSS base ---
cat > "$SITE_DIR/css/style.css" <<EOL
body {
  font-family: sans-serif;
  margin: 0;
  padding: 0;
}
EOL

# --- JS base ---
cat > "$SITE_DIR/js/script.js" <<EOL
console.log("Sitio $CLIENT cargado correctamente");
EOL

# --- Config Vite ---
cat > "$SITE_DIR/vite.config.js" <<EOL
import { defineConfig } from 'vite'

export default defineConfig({
  root: '.',
  base: './',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    manifest: true,
    rollupOptions: {
      input: 'index.html'
    }
  }
})
EOL

# --- Linters config (transversales) ---
cat > "$SITE_DIR/.stylelintrc.json" <<EOL
{
  "extends": "stylelint-config-standard"
}
EOL

cat > "$SITE_DIR/.eslintrc.json" <<EOL
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 12
  },
  "rules": {}
}
EOL

cat > "$SITE_DIR/.htmlhintrc" <<EOL
{
  "tag-pair": true,
  "attr-lowercase": true,
  "doctype-first": false
}
EOL

# --- package.json ---
cat > "$SITE_DIR/package.json" <<EOL
{
  "name": "$CLIENT-site",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint:css": "stylelint '**/*.css'",
    "lint:html": "htmlhint '**/*.html'",
    "lint:js": "eslint '**/*.js'",
    "lint": "npm run lint:css && npm run lint:html && npm run lint:js"
  },
  "devDependencies": {}
}
EOL

# --- Instalar dependencias ---
cd "$SITE_DIR"
npm init -y > /dev/null
npm install vite stylelint stylelint-config-standard eslint htmlhint --save-dev

cd - > /dev/null

# --- Workflow GitHub Actions preview-[cliente] ---
cat > "$WORKFLOW_DIR/preview-$CLIENT.yml" <<EOL
name: Preview & Lint $CLIENT Site

on:
  push:
    branches:
      - dev
    paths:
      - 'clients/$CLIENT/site/**'

jobs:
  lint-and-preview:
    runs-on: ubuntu-latest
    environment: dev

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 20

      - name: Install dependencies
        working-directory: clients/$CLIENT/site
        run: npm install

      - name: Run linters
        working-directory: clients/$CLIENT/site
        run: npm run lint

      - name: Build site for preview
        working-directory: clients/$CLIENT/site
        run: npm run build
EOL

echo "✅ Sitio base creado: $SITE_DIR"
echo "✅ Workflow creado: $WORKFLOW_DIR/preview-$CLIENT.yml"

# --- Workflow GitHub Actions deploy-[cliente] ---
cat > "$WORKFLOW_DIR/deploy-$CLIENT.yml" <<EOL
name: Deploy $CLIENT Site to S3

on:
  push:
    branches:
      - main
    paths:
      - 'clients/$CLIENT/site/**'

jobs:
  deploy:
    name: Deploy to AWS S3
    runs-on: ubuntu-latest
    environment: production

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 20

      - name: Install dependencies
        working-directory: clients/$CLIENT/site
        run: npm install

      - name: Build site
        working-directory: clients/$CLIENT/site
        run: npm run build

      - name: Deploy to S3
        uses: jakejarvis/s3-sync-action@v0.5.1
        with:
          args: --delete
        env:
          AWS_S3_BUCKET: \${{ secrets.BUCKET_${CLIENT^^} }}
          AWS_ACCESS_KEY_ID: \${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: \${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: \${{ secrets.AWS_REGION }}
          SOURCE_DIR: clients/$CLIENT/site/dist
EOL

echo "✅ Workflow de producción creado: $WORKFLOW_DIR/deploy-$CLIENT.yml"
