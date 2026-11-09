# Sistema de información TECSO — Plataforma y Data Warehouse

Repositorio de la plataforma interna de TECSO (Tecnología Social para el
Desarrollo S.A. de C.V.): el sistema PMD vigente, el Administrador del
Warehouse (el molde) y el Panel de trabajo, todos sobre el mismo proyecto
de Supabase.

## Estructura

| Ruta | Contenido |
|---|---|
| `index.html` + `config.js` | Sistema PMD vigente (captura y gestión del Plan Municipal de Desarrollo). No se modifica desde este proyecto. |
| `admin/` | Administrador del Warehouse: la página del molde (módulos, entidades, campos, catálogos, reportes) que se rellena y queda guardado en el esquema `meta` de Supabase. |
| `panel/` | Panel de trabajo TECSO: pendientes por proyecto con responsable, revisor, fechas de compromiso y de revisión, y estado (pendiente, en proceso, realizado, revisado). Lee la tabla `app.app_tarea`. |
| `supabase/migrations/` | Migraciones SQL del warehouse, en orden: 0001 esqueleto del molde, 0002 políticas de seguridad, 0003 panel de tareas. |
| `docs/` | Diseño y gobierno de la información: arquitectura de la plataforma, criterio perceptivo de clasificación e inventario del primer lote de Drive. |

## El warehouse

Cinco esquemas en Supabase: `meta` (el molde: el warehouse se describe a
sí mismo), `raw` (datos tal como llegan), `core` (datos limpios y
relacionados), `rpt` (salidas para reportes) y `app` (usuarios, roles,
auditoría y operación interna). La seguridad es por Row Level Security:
la lectura de metadatos es abierta con la llave publishable y la
escritura del molde es exclusiva del rol `admin_tecso`.

## Puesta en marcha pendiente

1. Exponer los esquemas `meta`, `app`, `core` y `rpt` en el panel de
   Supabase: Settings → API → Exposed schemas.
2. Asignar el primer rol `admin_tecso` por SQL (ver `admin/README.md`).
