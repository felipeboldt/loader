# 🚀 Checklist para Publicar un Nuevo Sitio Estático

Este checklist aplica a sitios HTML/CSS/JS simples (tipo landing), desplegados en S3 con GitHub Actions.

---

## **🧩 1. Crear nuevo cliente**

```bash
./tools/deploy/create-static-site.sh nombre_cliente
```
Esto genera:
- ✅ Estructura clients/nombre_cliente/site/
- ✅ Archivos base: index.html, css/style.css, js/script.js
- ✅ Configura vite.config.js con base: './' (necesario para S3)
- ✅ Inicializa package.json con scripts de build/lint
- ✅ Instala dependencias (vite, eslint, stylelint, htmlhint, etc.)

---



## **🔄 2. Agregar cliente a matriz de linters (preview)**
**Esto permite que los linters se ejecuten en los nuevos sitios automáticamente en cada push a dev.**

1. Editar el archivo
```bash
.github/workflows/lint_dev.yml
```

2. Y agregar el nuevo cliente en la matriz:
```yaml
strategy:
  matrix:
    client: [digin, nombre_cliente]
```


## **🔐 3. Configurar Secrets en GitHub**

Ir a **Repo → Settings → Secrets → Actions**

Agregar:

| **Nombre** | **Valor** |
| --- | --- |
| AWS_ACCESS_KEY_ID | Access key del IAM user |
| AWS_SECRET_ACCESS_KEY | Secret key del IAM user |
| NOMBRECLIENTE_S3_BUCKET | Ej: www.cliente.com |

 Reutiliza AWS para todos los sitios, pero cada cliente necesita su propio S3_BUCKET.

---

## **🧪 4. Subir cambios a rama dev  (entorno de prueba)**

```bash
git checkout dev
git add .
git commit -m "feat: agregar sitio nombre_cliente"
git push origin dev
```

- ✅ Se ejecuta preview-nombre_cliente.yml
- ✅ Corre linters (html, css, js)
- ✅ Hace build con Vite
- ✅ No impacta producción

## **👁 5. Probar en Codespaces y validar visualmente (opcional)**

**En Codespaces**
```bash
cd clients/nombre_cliente/site
npm install
npm run dev
```
**En local**
Previsualizá el sitio en http://localhost:5173/
```bash
./tools/deploy/preview-dev.sh nombre_cliente
```

## **🚢 6. Publicar en producción (S3 + CloudFront)**

```bash
git checkout main
git pull origin main      # asegura estar actualizado
git merge dev -m "merge: agregar sitio nombre_cliente"
git push origin main
```
O bien puedes correr:
```bash
./tools/deploy/deploy-prod.sh nombre_cliente
```


---

## **🧼 7. Tareas opcionales**

- Agregar dominio personalizado (CloudFront + Route53)
- Incluir certificado SSL en ACM
- Publicar sitio en GitHub Pages (opcional para pruebas)
- Crear landing con header/footer reutilizable
- Optimizar con Lighthouse, Minify, Lazy Load
- Subir favicon, logos, imàgenes comprimidas

---

## **🧠 Buenas prácticas**

- 🏷 Usar nombres de clientes en minúscula y sin espacios
- 🔐 No hardcodear secretos (usar GitHub Secrets)
- 📁 Mantener consistencia en carpetas: clients/<cliente>/site
- ✅ Usar vite.config.js con base: './' para compatibilidad S3
- 🧪 Validar en dev antes de hacer merge a main