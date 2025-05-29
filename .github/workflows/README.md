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