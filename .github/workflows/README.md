# 🚀 CI/CD Workflow para Sitios Estáticos

Este repositorio implementa un flujo de trabajo automatizado para el desarrollo, validación y despliegue de sitios estáticos usando GitHub Actions, Vite, AWS S3 y CloudFront.

---

## 🔀 Estructura de ramas

| Rama   | Propósito                                    | ¿Despliega en Producción? |
|--------|----------------------------------------------|----------------------------|
| `dev`  | Desarrollo local, pruebas, validación visual | ❌ No                      |
| `main` | Rama estable, despliegue productivo          | ✅ Sí                      |

---

## 🧪 Flujo de trabajo en `dev`

### 1. Realiza cambios en tu máquina local o Codespaces:
```bash
   git checkout dev
   code clients/<cliente>/site/index.html
```

### 2.Levanta el entorno local
```bash
   cd clients/<cliente>/site
   npm run dev
   # o usar: ./tools/deploy/preview-dev.sh <cliente>
```
### 3.Guarda tus cambios y súbelos a dev
```bash
git add .
git commit -m "feat: actualización visual del CTA"
git push origin dev
```
## 🚀 Flujo de despliegue a producción (main)
Una vez validados los cambios en dev:

### 1. Fusiona hacia main:
```bash
git checkout main
git pull origin main
git merge dev
git push origin main
```
### 2. ⚙️ GitHub Actions se encarga del resto:
•	🔨 Build con Vite
•	☁️ Publicación a bucket S3
•	🚫 Invalidación automática de caché en CloudFront


## Scripts y herramientas

### Crear un nuevo sitio estático para un cliente:
```bash
bash tools/deploy/create-static-site.sh
```
### Desplegar manualmente (solo si es necesario)
```bash
# Producción
./tools/deploy/deploy-prod.sh digin
# Preview local
./tools/deploy/preview-dev.sh digin
```

## 📌 Notas
•	Todas las rutas, buckets y dominios están configurados por cliente.
•	Para modificar el comportamiento del despliegue automático, edita el archivo:
```bash
.github/workflows/deploy-digin.yml
```

## Mantenedor
Este workflow fue diseñado y es mantenido por @fboldt para estandarizar y automatizar los procesos de publicación de sitios estáticos de Loader.