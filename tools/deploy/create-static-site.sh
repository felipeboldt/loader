#!/bin/bash

# 🚀 Crear cliente para sitio estático con linters y configuración base

CLIENT=$1
SITE_DIR="clients/$CLIENT/site"

if [ -z "$CLIENT" ]; then
  echo "❌ Debes ingresar el nombre del cliente. Ejemplo:"
  echo "./tools/deploy/create-static-site.sh digin"
  exit 1
fi

echo "📁 Creando estructura de carpetas para $CLIENT..."

mkdir -p "$SITE_DIR/css" "$SITE_DIR/js" "$SITE_DIR/images"

# 📄 Crear archivos base si no existen
[ -f "$SITE_DIR/index.html" ] || cat > "$SITE_DIR/index.html" <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$CLIENT</title>
  <link rel="stylesheet" href="css/style.css" />
</head>
<body>
  <h1>Bienvenido a $CLIENT</h1>
  <script src="js/script.js"></script>
</body>
</html>
EOF

[ -f "$SITE_DIR/css/style.css" ] || echo "/* Estilos para $CLIENT */" > "$SITE_DIR/css/style.css"
[ -f "$SITE_DIR/js/script.js" ] || echo "// JavaScript para $CLIENT" > "$SITE_DIR/js/script.js"

cd "$SITE_DIR"

# 📦 Inicializar npm si no existe
if [ ! -f "package.json" ]; then
  npm init -y
fi

# 📥 Instalar linters
echo "📦 Instalando linters..."
npm install --save-dev eslint stylelint stylelint-config-standard htmlhint

# 🔧 Agregar scripts al package.json
npx json -I -f package.json -e '
this.scripts = this.scripts || {};
this.scripts["lint"] = "npm run lint:js && npm run lint:css && npm run lint:html";
this.scripts["lint:js"] = "eslint .";
this.scripts["lint:css"] = "stylelint **/*.css";
this.scripts["lint:html"] = "htmlhint .";
'

# 📝 Crear archivos de configuración de linters
cat > .eslintrc.json <<EOF
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "no-unused-vars": "warn",
    "no-console": "off",
    "semi": ["error", "always"],
    "quotes": ["error", "double"]
  }
}
EOF

cat > .stylelintrc.json <<EOF
{
  "extends": "stylelint-config-standard",
  "rules": {
    "color-hex-length": "short",
    "declaration-block-no-duplicate-properties": true,
    "block-no-empty": true
  }
}
EOF

cat > .htmlhintrc <<EOF
{
  "tagname-lowercase": true,
  "attr-lowercase": true,
  "attr-value-double-quotes": true,
  "doctype-first": false,
  "tag-pair": true,
  "spec-char-escape": true,
  "id-unique": true,
  "head-script-disabled": false,
  "style-disabled": false
}
EOF

echo "✅ Sitio estático para '$CLIENT' creado con linters y configuración lista."