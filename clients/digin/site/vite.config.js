import { defineConfig } from 'vite';

export default defineConfig({
  root: '.',              // raíz del proyecto
  base: './',             // rutas relativas
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    manifest: true,
    rollupOptions: {
      input: 'index.html'
    }
  }
})
