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
    git add .
    git commit -m "feat: nueva sección de beneficios"
    git push origin dev


🔧 Se ejecuta el workflow preview.yml:
	•	Lint de HTML, CSS, JS
	•	Build con Vite
	•	Ideal para pruebas locales o preview en Codespaces

🚀 Flujo de despliegue a producción (main)
	1.	Una vez validado el preview en dev, fusiona a main:
    ```bash
    git checkout main
    git merge dev
    git push origin main
    
    2.	Una vez validado el preview en dev, fusiona a main:
    •	Build con Vite
	•	Deploy del contenido generado (dist/) al bucket de AWS S3
	•	Asociado al entorno production

🧰 Scripts y herramientas

Crear nuevo sitio estático

Ejecuta el siguiente script:
```bash
bash tools/deploy/create-static-site.sh

📦 Esto creará la estructura del cliente en clients/<cliente>/site con:
	•	index.html, vite.config.js
	•	package.json con linters configurados
	•	.gitignore y estructura base lista

También generará automáticamente un workflow de preview:
```bash
.github/workflows/preview-<cliente>.yml

🛡️ Buenas prácticas y linters

Cada sitio tiene configurado:
	•	Stylelint para CSS
	•	ESLint para JS
	•	HTMLHint para HTML

Puedes ejecutar manualmente:
```bash
npm run lint

🌐 Producción en AWS
	•	Bucket S3: configurado con hosting estático
	•	CloudFront (opcional): en producción puedes añadir invalidaciones si necesitas manejo de caché más fino.

🧼 Archivos ignorados por Git

Revisa el archivo raíz .gitignore, que incluye:
```bash
# node_modules, builds
node_modules/
**/dist/

# Configuración de entornos
.env
.env.local

# macOS y VS Code
.DS_Store
.vscode/

📌 Recomendación

Si estás agregando nuevos sitios estáticos:
	1.	Usa el script create-static-site.sh
	2.	Trabaja en la rama dev
	3.	Revisa el preview desde Codespaces o local
	4.	Solo luego mergea a main para publicar
