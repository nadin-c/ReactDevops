import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist', // Ensure this matches the directory referenced in the Dockerfile
    sourcemap: true,
  },
  server: {
    port: 3000,
    host: true
  },
  devDependencies: {
    vite: "^4.0.0"
  }
});
