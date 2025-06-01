# 🧠 Loader – Monorepo para Sitios Estáticos de Clientes

Este repositorio centraliza los sitios estáticos de múltiples clientes, automatizando sus flujos de desarrollo, validación y despliegue mediante GitHub Actions, Vite y AWS (S3 + CloudFront).

---

## 📁 Estructura de Carpetas
loader/
│
├── clients/
│   └── digin/
│       └── site/         # Código fuente del sitio estático de DigIn
│
├── tools/
│   └── deploy/           # Scripts Bash reutilizables para CI/CD
│
├── .github/
│   └── workflows/        # GitHub Actions para CI/CD automatizado
│
└── README.md             # Este archivo


## 🚀 CI/CD Automatizado

Cada push a la rama `main` dispara:

- 🔨 Build del sitio con [Vite](https://vitejs.dev)
- ☁️ Publicación a Amazon S3 (bucket: `www.digin.cl`)
- 🚫 Invalidación automática del caché en CloudFront

---

## ⚙️ Requisitos del Entorno

- Node.js `v20+`
- AWS CLI configurado (`aws configure`)
- Permisos para S3 y CloudFront
- Git con acceso a `origin` vía HTTPS o SSH

---

## 📘 Documentación clave

Para editar, testear y desplegar sitios o scripts:

👉 [tools/deploy/DEPLOY_GUIDE.md](tools/deploy/DEPLOY_GUIDE.md)

Cómo publicar nuevos sitios
👉 [Checklist para nuevos sitios estáticos](tools/deploy/checklist-deploy-static-site.md)

---

## 🤝 Contribuciones

Este repo es mantenido por `@fboldt` como parte del ecosistema de automatización de DigIn. Si deseas colaborar o proponer una mejora, ¡abre un PR!

---

## 🛡️ Licencia

MIT License — 2025 © DigIn