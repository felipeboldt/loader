# 🚀 Checklist para Publicar un Nuevo Sitio Estático

Este checklist aplica a sitios HTML/CSS/JS simples (tipo landing), desplegados en S3 con GitHub Actions.

---

## 🧩 1. Crear nuevo cliente

```bash
./tools/deploy/create-static-site.sh nombre_cliente
```

- ✅ Genera estructura clients/nombre_cliente/site/
- ✅ Crea workflows de preview y deploy
- ✅ Instala dependencias (vite, linters, etc.)
- ✅ Configura vite.config.js, package.json y archivos base

---

## **🔐 2. Configurar Secrets en GitHub**

Ir a **Repo → Settings → Secrets → Actions**

Agregar:

| **Nombre** | **Valor** |
| --- | --- |
| AWS_ACCESS_KEY_ID | Access key del IAM user |
| AWS_SECRET_ACCESS_KEY | Secret key del IAM user |
| NOMBRECLIENTE_S3_BUCKET | Ej: www.cliente.com |

 Reutiliza AWS para todos los sitios, pero cada cliente necesita su propio S3_BUCKET.

---

## **🧪 3. Subir cambios a rama dev  (entorno de prueba)**

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

## **👁 4. Probar en Codespaces (opcional)**

```yaml
cd clients/nombre_cliente/site
npm run dev
```

> Previsualizá el sitio en http://localhost:5173/
Ideal para revisión de QA o demo interna
> 

## **🚢 5. Publicar en producción (S3 + CloudFront)**

```bash
git checkout main
git merge dev
git push origin main
```

---

## **🧼 6. Tareas opcionales**

- Agregar dominio personalizado (CloudFront + Route53)
- Incluir certificado SSL en ACM
- Crear landing con header/footer reutilizable
- Validar performance con Lighthouse

---

## **🧠 Buenas prácticas**

- 🏷 Usar nombres de clientes en minúscula y sin espacios
- 🔐 No hardcodear secretos (usar GitHub Secrets)
- 📁 Mantener consistencia en carpetas: clients/<cliente>/site
- ✅ Usar vite.config.js con base: './' para compatibilidad S3