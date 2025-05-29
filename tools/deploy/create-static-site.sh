#!/bin/bash

# 🚨 Validación del nombre del cliente
if [ -z "$1" ]; then
  echo "❌ Uso: ./tools/deploy/create-static-site.sh nombre_cliente"
  exit 1
fi

CLIENT=$1
CLIENT_UPPER=$(echo "$CLIENT" | tr '[:lower:]' '[:upper:]')
BASE_DIR="clients/$CLIENT/site"
WORKFLOW_DIR=".github/workflows"
DEPLOY_WORKFLOW="$WORKFLOW_DIR/deploy-$CLIENT.yml"
PREVIEW_WORKFLOW="$WORKFLOW_DIR/preview-$CLIENT.yml"

# 🏗️ Crear estructura base
mkdir -p "$BASE_DIR/css" "$BASE_DIR/js" "$WORKFLOW_DIR"

# 🌐 index.html
cat > "$BASE_DIR/index.html" <<EOL
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$CLIENT</title>
  <link rel="stylesheet" href="./css/style.css" />
</head>
<body>
  <h1>Bienvenido a $CLIENT</h1>
  <script src="./js/script.js"></script>
</body>
</html>
EOL

# 🎨 CSS y JS
echo "body { font-family: sans-serif; }" > "$BASE_DIR/css/style.css"
echo "console.log('Hello from $CLIENT');" > "$BASE_DIR/js/script.js"

# ⚙️ vite.config.js
cat > "$BASE_DIR/vite.config.js" <<EOL
import { defineConfig } from 'vite';

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
});
EOL

# 📦 package.json
cat > "$BASE_DIR/package.json" <<EOL
{
  "name": "$CLIENT-site",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint:css": "stylelint 'css/**/*.css'",
    "lint:html": "htmlhint '**/*.html'",
    "lint:js": "eslint 'js/**/*.js'",
    "lint": "npm run lint:html && npm run lint:css && npm run lint:js"
  }
}
EOL

# 🧾 .gitignore
cat > "$BASE_DIR/.gitignore" <<EOL
node_modules/
dist/
.DS_Store
.env
*.log
EOL

# ⚙️ GitHub Action: deploy
cat > "$DEPLOY_WORKFLOW" <<EOL
name: Deploy $CLIENT Site to S3

on:
  push:
    branches:
      - main
    paths:
      - 'clients/$CLIENT/site/**'

jobs:
  deploy:
    name: 🚀 Build & Deploy to AWS S3
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

      - name: Build static site with Vite
        working-directory: clients/$CLIENT/site
        run: npm run build

      - name: Deploy to S3
        uses: jakejarvis/s3-sync-action@v0.5.1
        with:
          args: --delete
        env:
          AWS_S3_BUCKET: \${{ secrets.${CLIENT_UPPER}_S3_BUCKET }}
          AWS_ACCESS_KEY_ID: \${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: \${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: "sa-east-1"
          SOURCE_DIR: clients/$CLIENT/site/dist
EOL

# ⚙️ GitHub Action: preview
cat > "$PREVIEW_WORKFLOW" <<EOL
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

# ✅ Instalar dependencias automáticamente
cd "$BASE_DIR"
npm init -y > /dev/null
npm install vite stylelint stylelint-config-standard eslint htmlhint --save-dev

# 🔚 Resultado
echo ""
echo "✅ Sitio estático '$CLIENT' creado y listo:"
echo "📂 Código:     $BASE_DIR"
echo "⚙️  Workflows:  $DEPLOY_WORKFLOW + $PREVIEW_WORKFLOW"
echo ""
echo "🔐 Recordá crear el secret: ${CLIENT_UPPER}_S3_BUCKET"
echo ""