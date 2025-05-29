# 🧠 CI/CD Workflow: loader

Este repositorio usa un flujo de trabajo Git semiautomatizado para mantener una separación clara entre desarrollo, pruebas y producción. El despliegue a AWS S3 se maneja con GitHub Actions.

---

## 🪢 Estructura de Ramas

| Rama  | Propósito                        | ¿Despliega a Producción? |
|-------|----------------------------------|---------------------------|
| `dev` | Desarrollo, testing, Codespaces | ❌ No                     |
| `main`| Producción (deploy a S3)        | ✅ Sí                     |

---

## 🚀 Flujo de trabajo recomendado

### 1. Desarrollo en `dev`

```bash
git checkout dev
