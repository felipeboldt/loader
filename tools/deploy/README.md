# ⚙️ Automatizador de proyectos Loader

Este módulo permite generar de forma estandarizada la estructura de un nuevo cliente, incluyendo:

- Estructura base (HTML/CSS/JS con Vite)
- Configuración de linters
- Scripts de desarrollo y build
- Workflows de GitHub Actions para:
  - Lint + preview en `dev`
  - Deploy a producción en `main` hacia AWS S3

---

## 🛠 Requisitos previos

- Tener configurado un repo Git con ramas `main` y `dev`
- Tener las claves AWS y bucket configurados como secrets en GitHub:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `<CLIENTE>_S3_BUCKET` (en mayúsculas, ejemplo: `DIGIN_S3_BUCKET`)

---

## 🚀 Crear nuevo proyecto de cliente

Desde la raíz del repo:

```bash
./tools/deploy/create-client.sh nombre_cliente