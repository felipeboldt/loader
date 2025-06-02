# 🚀 Guía de Deploy

Este documento describe el flujo completo para editar, validar y publicar cambios en el sitio de DigIn usando Git, GitHub Actions, Vite, S3 y CloudFront.

## 👉 Vas a crear un nuevo cliente desde cero?
👉 [Checklist para nuevos sitios estáticos](tools/deploy/checklist-deploy-static-site.md)

---

## 🔁 Flujo completo de despliegue de sitios estáticos

### 1. Editar código en la rama `dev`

Haz tus cambios en HTML, CSS o JS dentro de:
*clients/digin/site/*
```bash
sync-dev                        #cambia a ambiente dev y descarga toda la rama de dev a local
git checkout dev                #opcional si haces el paso anterior
code clients/digin/site/index.html   # o el archivo que desees editar
```

### 2. Validar visualmente (local o Codespaces)
**- En local**
```bash
./tools/deploy/preview-dev.sh digin
```
**- En codespaces**
Esto levanta Vite y te permite ver los cambios en http://localhost:5173.
```bash
npm run dev
```

### 3. Hacer commit y push en dev
```bash
git add clients/digin/site/index.html   # o cualquier archivo editado
git commit -m "feat: actualizar hero con nuevo CTA"
git push origin dev
```

### 4. Merge de dev a main
Al hacer push a main, se dispara el deploy automático.
```bash
git checkout main
git pull origin main          # asegura que estás actualizado
git merge dev -m "merge: integrar cambios de dev en main"  #resuelve los conflictos si los hay
git push origin main
```
### 5. GitHub Actions despliega automáticamente
El workflow deploy-digin.yml realiza:
	•	✅ Checkout del repo
	•	📦 Instalación de dependencias
	•	🔨 Build del sitio con vite
	•	☁️ Sync de dist/ al bucket S3 (www.digin.cl)
	•	🚫 Invalida cache de CloudFront para que los cambios se reflejen al instante

No necesitas ejecutar ningún script manual.

## 🔁 Flujo completo de componentes transversales

### 1. Editar código en la rama `dev`

Haz tus cambios de componentess transversales dentro de:
*loader, loader/tools o loader/.github, etc.*
```bash
sync-dev                        #cambia a ambiente dev y descarga toda la rama de dev a local
git checkout dev                #opcional si haces el paso anterior
code README.md  # o el archivo que desees editar
code code tools/deploy/deploy-prod.sh # o el archivo que desees editar
code .github/workflows/deploy-digin.yml # o el archivo que desees editar
```

### 2.  Verifica que el cambio no afecte otras funciones
	•	Si tocaste un .sh: ejecuta una prueba local (si aplica).
	•	Si tocaste un .yml: revisa que tenga la sintaxis correcta (act o validadores de GitHub).
	•	Si es un cambio en README.md: abre el preview markdown para revisar.

### 3.  Haz commit y push a dev
```bash
git add .
git commit -m "chore: actualizar script de deploy y documentación"
git push origin dev
```
### 4.  Merge a main con revisión
```bash
git checkout main
git pull origin main           # asegúrate de estar actualizado
git merge dev -m "merge: integrar cambios de dev en main"  #resuelve los conflictos si los hay
git push origin main
```
### 5.  Verifica si hay efectos colaterales
	•	Workflows .yml: se ejecutan automáticamente.
	•	Scripts: sólo afectan si los llamás manualmente.
	•	Readme o Docs: sólo informativo, no impacta la app.

## 🧹 Validación automática de código (Lint en rama `dev`)

Cada vez que haces push a la rama `dev`, se ejecuta un workflow llamado `Lint Site on Dev Push`, que:

- Verifica que el código HTML, CSS y JS siga buenas prácticas.
- Utiliza `htmlhint`, `stylelint` y `eslint` de forma centralizada.
- Ayuda a mantener un código limpio antes de mergear a `main`.

Puedes correr los linters también de forma local:

```bash
npm run lint:html
npm run lint:css
npm run lint:js
```