# 🚀 CI/CD Workflow para Sitios Estáticos

Este repositorio contiene la infraestructura automatizada para generar, previsualizar, testear y desplegar sitios estáticos personalizados por cliente, usando **Vite + GitHub Actions + AWS S3**.

Diseñado para escalar en entornos multi-brand, con buenas prácticas integradas (linters, CI/CD, separación de entornos).

---

## 🔀 Estructura de ramas

| Rama  | Propósito                               | ¿Despliega en Producción? |
|-------|------------------------------------------|----------------------------|
| `dev` | Desarrollo local, validaciones, preview | ❌ No                     |
| `main`| Producción, despliegue a AWS S3         | ✅ Sí                     |


---

## 📁 Estructura del proyecto
Clients/
└── /
└── site/
├── index.html
├── vite.config.js
├── css/
├── js/
└── dist/ (build)
.github/
└── workflows/
├── preview-.yml
└── deploy-.yml
tools/
└── deploy/
├── create-static-site.sh
├── deploy-dev.sh
├── deploy-prod.sh
└── preview-dev.sh
---

## 🧰 CLI Interno

Utiliza los scripts Bash como comandos CLI:

```bash
# Crear un nuevo sitio base para cliente
bash tools/deploy/create-static-site.sh <cliente>

# Previsualizar localmente (vite preview)
bash tools/deploy/preview-dev.sh <cliente>

# Generar build de desarrollo (en desuso)
bash tools/deploy/deploy-dev.sh <cliente>

# Publicar build en S3 (producción)(en desuso)
bash tools/deploy/deploy-prod.sh <cliente>
```

🔐 Las credenciales AWS se gestionan a través de GitHub Secrets (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_<CLIENTE>…).

## 🧪 Flujo de trabajo en CI/CD
🔁 Rama dev — Previsualización

1. Realiza cambios en tu máquina local.
2. Ejecuta pruebas locales y/o usa Codespaces:
```bash
cd clients/<cliente>/site
npm run dev
```
3. Haz push a la rama dev:
```bash
	git add .
    git commit -m "feat: nueva sección de beneficios"
    git push origin dev
```
4. Se ejecuta el workflow preview.yml:
	•	Lint de HTML, CSS, JS
	•	Build con Vite
	•	Ideal para pruebas locales o preview en Codespaces

🚀 Rama main — Producción
	1.	Una vez validado el preview en dev, fusiona a main:
```bash
    git checkout main
    git merge dev
    git push origin main
``` 
    2.	Github ejecuta
    •	Build con Vite
	•	Deploy del contenido generado (dist/) al bucket de AWS S3
	•	Asociado al entorno production

🛠 Linters configurados
	Cada sitio incluye configuración para:
	•	✅ stylelint (CSS)
	•	✅ eslint (JS)
	•	✅ htmlhint (HTML)

	Comando global de linting:
```bash
	npm run lint
```

🌐 Hosting en Producción (S3)
	Cada cliente tiene su configuración en:
```bash
	clients/<cliente>/site/config.json
```
	Ejemplo:
```json
	{
  		"bucket": "www.cliente123.cl"
	}
```
	El script de deploy sincroniza dist/ con el bucket:
```bash
	aws s3 sync dist/ s3://www.cliente123.cl --delete
```

📦 Dependencias

Se instalan automáticamente al crear un nuevo sitio:
	•	vite
	•	stylelint, stylelint-config-standard
	•	eslint
	•	htmlhint

Tambien se instalan manualmente:
```bash
npm install
```

🧼 .gitignore recomendado
```bash
	node_modules/
	**/dist/
	.env
	.env.local
	.DS_Store
	.vscode/
```

✅ Recomendaciones
	1.	Usa create-static-site.sh para nuevos clientes.
	2.	Trabaja sobre la rama dev.
	3.	Haz preview local o desde Codespaces.
	4.	Valida y luego haz merge a main para publicar.
	5.	Opcional: dockeriza o empaqueta como CLI para mayor portabilidad.


📌 Estado actual:
Tu pipeline ahora está full productivo:
	•	GitHub Actions + S3 + CloudFront ✅
	•	Deploy automático en push a main ✅
	•	Invalidación automática de cache ✅
	•	Reglas de permisos AWS revisadas ✅
	•	Linter, estructura por cliente y modularización OK ✅


📌 Roadmap sugerido
	•	Agregar CloudFront + invalidación ✅ 
	•	Agregar CLI unificado (Node.js o Taskfile)
	•	Notificaciones a Slack/Discord post-deploy
	•	Integrar con AWS IAM más granular