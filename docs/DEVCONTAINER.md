# 🐳 Uso de Codespaces con DevContainer

Este archivo documenta el flujo recomendado para levantar y probar sitios estáticos (como DigIn) usando GitHub Codespaces y el archivo `devcontainer.json`.

---

## ⚙️ Requisitos

- El repositorio debe tener un archivo `.devcontainer/devcontainer.json`
- Este archivo ya incluye:
  - Node.js 18
  - `live-server` instalado globalmente
  - Extensiones de VSCode preinstaladas: ESLint, Stylelint, Prettier, Live Server

---

## 🚀 Paso a paso para levantar el entorno

### 1. Iniciar Codespace desde GitHub

- Ir al repositorio en GitHub
- Clic en el botón verde `Code`
- Seleccionar la pestaña **Codespaces**
- Clic en `Create codespace on dev` (o ingresar al existente)

⚠️ El entorno se abrirá automáticamente en el contenedor definido.

---

### 2. Navegar a la carpeta del sitio

En la terminal del Codespace:

```bash
cd clients/digin/site
```

### 3. Levantar el sitio con Live Server

El contenedor ya instala live-server. Ejecuta:
```bash
live-server
```
Esto:
	•	Sirve el sitio en http://127.0.0.1:5500
	•	Codespaces lo tunelará a una URL externa como:
        https://5500-<tuusuario>.githubpreview.dev

🔗 Esta URL aparecerá automáticamente en la terminal o en el port forwarding de VSCode.

### 4. Verificación visual
	•	Abrí la URL tunelada
	•	Confirmá que el sitio carga correctamente (CSS, JS, imágenes, etc.)


## 🚀 Recomendaciones adicionales
	•	Asegurate de que vite.config.js tenga base: './'
	•	Usá rutas relativas para assets (ej: ./css/style.css)
	•	Revisá errores en la consola del navegador (Cmd + Opt + I → pestaña “Console”)

## 🧼 Limpieza
	•	El Codespace guarda el entorno, así que la próxima vez podés retomarlo.
	•	Podés detenerlo o borrarlo desde GitHub → Codespaces.

## 🧠 Buenas prácticas
	•	Usá Codespaces para validación visual antes de mergear a main
	•	Evitá usar vite dev en este entorno si estás usando live-server
	•	Mantené actualizado el archivo devcontainer.json si agregás nuevas herramientas