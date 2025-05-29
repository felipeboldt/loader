#!/bin/bash

# 🚨 Validar nombre del cliente
if [ -z "$1" ]; then
  echo "❌ Debes ingresar el nombre del cliente (en minúscula y sin espacios)"
  echo "👉 Ejemplo: ./create-static-site.sh digin"
  exit 1
fi

CLIENT=$1
SITE_DIR="clients/$CLIENT/site"
WORKFLOW_DIR=".github/workflows"

echo "🚧 Creando estructura para $CLIENT..."

# 📁 Estructura básica
mkdir -p "$SITE_DIR"/{css,js,images}
touch "$SITE_DIR/index.html"
echo "<!-- TODO: contenido del sitio $CLIENT -->" > "$SITE_DIR/index.html"

# 🧠 Configs por cliente
cat > "$SITE_DIR/vite.config.js" <<EOL
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
})
EOL

# ⚙️ Linter y dependencias base
npm init -y --scope="$CLIENT" --workspace="$SITE_DIR"
cd "$SITE_DIR" || exit

npm install --save-dev vite stylelint stylelint-config-standard eslint htmlhint

cat > .eslintrc.json <<EOL
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

cat > .stylelintrc.json <<EOL
{
  "extends": "stylelint-config-standard"
}
EOL

cat > .htmlhintrc <<EOL
{
  "tagname-lowercase": true,
  "attr-lowercase": true,
  "doctype-first": true
}
EOL

# 🚫 Evitar .gitignore local
[ -f .gitignore ] && rm .gitignore && echo "🧹 .gitignore local eliminado"

# 🔙 Volver al root del proyecto
cd ../../../..

# ⚙️ GitHub Action: preview-$CLIENT.yml
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
        run: npm run lint || true

      - name: Build site for preview
        working-directory: clients/$CLIENT/site
        run: npm run build
EOL

echo "✅ Sitio estático para $CLIENT creado en $SITE_DIR"
echo "✅ Workflow preview-${CLIENT}.yml generado en $WORKFLOW_DIR"