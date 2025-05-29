# 🚀 CI/CD Workflow para Sitios Estáticos

Este repositorio implementa un flujo de trabajo semiautomatizado para el desarrollo, prueba y despliegue de sitios estáticos con GitHub Actions y AWS S3.

---

## 🔀 Estructura de ramas

| Rama  | Propósito                               | ¿Despliega en Producción? |
|-------|------------------------------------------|----------------------------|
| `dev` | Desarrollo local, validaciones, preview | ❌ No                     |
| `main`| Producción, despliegue a AWS S3         | ✅ Sí                     |

---

## 🧪 Flujo de trabajo en `dev`

1. Realiza cambios en tu máquina local.
2. Ejecuta pruebas locales y/o usa Codespaces:
   ```bash
   cd clients/<cliente>/site
   npm run dev
3. Haz push a la rama dev:
   ```bash
   cd clients/<cliente>/site
   npm run dev

## 🚀 Flujo de despliegue a producción (main)
1. Una vez validado el preview en dev, fusiona a main:
   ```bash
   git checkout main
   git merge dev
   git push origin main

🧰 Scripts y herramientas)
    Crear nuevo sitio estático
    Ejecuta el siguiente script:
    ```bash
    bash tools/deploy/create-static-site.sh

