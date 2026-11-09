# Administrador de Warehouse — el molde

Página de administración del Data Warehouse de TECSO. Aquí se rellena el
molde (módulos, entidades, campos, catálogos y reportes) y todo queda
guardado en Supabase, en el esquema `meta`. La app de captura y los
reportes se generan a partir de esa descripción.

- No modifica `index.html` (el sistema PMD vigente) ni `config.js`.
- Usa la misma `config.js` del proyecto: URL pública y llave publishable.
  La llave secreta (service_role) nunca va en el navegador.

## Puesta en marcha

1. **Exponer los esquemas a la API** (una sola vez, en el panel de
   Supabase): Settings → API → Exposed schemas → agregar `meta`, `app`,
   `core`, `rpt`. Sin este paso la página muestra un aviso con la ruta.
2. **Migraciones** (carpeta `supabase/migrations/` de este repositorio):
   `0001` crea los esquemas y las tablas del molde; `0002` crea los
   permisos y las políticas de seguridad (RLS). Ambas ya están aplicadas
   en el proyecto (9 nov 2026).
3. **Primer administrador**: las políticas solo permiten escribir a
   usuarios con rol `admin_tecso`, y el primer rol se asigna por SQL
   (desde el SQL Editor o la API de gestión), con el UUID del usuario de
   Auth:

   ```sql
   insert into app.app_usuario_rol (usuario_id, rol)
   values ('<uuid-del-usuario>', 'admin_tecso');
   ```

## Reglas del molde

- La lectura de los metadatos es abierta con la llave publishable: son
  estructura, no datos sensibles, y la captura los necesita para dibujar
  formularios.
- La escritura exige sesión iniciada y rol `admin_tecso`.
- Todo campo exige ayuda contextual: es el texto del «?» que verá quien
  capture.
