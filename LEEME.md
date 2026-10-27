# Formato B – PMD Huimanguillo (Netlify)

## Publicar
1. Sube esta carpeta a un repo de GitHub y conéctalo en Netlify (Add new site → Import from Git).
   (Con "arrastrar y soltar" NO funcionan las funciones: usa Git o Netlify CLI: `npm i -g netlify-cli && netlify deploy --prod`.)
2. En Netlify → Site configuration → Environment variables, crea **ADMIN_PASSWORD** (tu contraseña de administrador).
3. Entra con usuario `admin` y esa contraseña. Los demás usuarios/contraseñas están en `credenciales.csv` (NO lo subas al repo).

## Dónde cambiar cosas
- Panel admin (en la propia página): reasignar líneas, editar texto/unidad/eje, agregar o eliminar líneas y usuarios, cambiar contraseñas, descargar CSV.
- Periodos y mínimo de caracteres: arriba del `<script>` en `public/index.html` (y `valida` en `netlify/functions/api.mjs`).
- `data/seed.json` solo se carga la PRIMERA vez. Después todo vive en Netlify Blobs y se edita desde el panel.
