-- Migración 0004 — Módulo de Avances: publicación estructurada del trabajo
-- Cada avance pertenece a un proyecto, puede ligarse a un pendiente del
-- Panel y, cuando es una nueva versión de un producto, se encadena con
-- la versión anterior. La "versión vigente" es la última publicada de
-- cada producto; el historial completo se conserva.

create table if not exists app.app_avance (
  id uuid primary key default gen_random_uuid(),
  proyecto text not null,
  tarea_id uuid references app.app_tarea(id),
  producto text,
  titulo text not null,
  descripcion text,
  tipo text not null default 'avance'
    check (tipo in ('avance', 'para_revision', 'entrega', 'evidencia', 'nota')),
  autor text,
  version int,
  avance_anterior_id uuid references app.app_avance(id),
  archivo_nombre text,
  archivo_url text,
  es_vigente boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists idx_avance_proyecto_fecha
  on app.app_avance (proyecto, created_at desc);
create index if not exists idx_avance_producto
  on app.app_avance (proyecto, producto, version);

alter table app.app_avance enable row level security;

grant select, insert, update, delete on app.app_avance to authenticated;

create policy avance_lectura on app.app_avance
  for select to authenticated using (true);
create policy avance_escritura on app.app_avance
  for all to authenticated
  using (app.tiene_rol('admin_tecso') or app.tiene_rol('equipo_tecso'))
  with check (app.tiene_rol('admin_tecso') or app.tiene_rol('equipo_tecso'));

-- Registro en el molde: módulo Operación interna, entidad avance
insert into meta.meta_entidad (modulo_id, nombre, capa, descripcion, campo_clave, campo_visible)
select id, 'avance', 'core',
       'Publicación estructurada de trabajo: pertenece a un proyecto, puede ligarse a un pendiente y encadenarse como nueva versión de un producto. Sustituye el envío de versiones por WhatsApp.',
       'id', 'titulo'
from meta.meta_modulo where nombre = 'Operación interna'
on conflict (modulo_id, nombre) do nothing;

insert into meta.meta_campo (entidad_id, nombre, etiqueta, tipo, requerido, orden, ayuda)
select e.id, v.nombre, v.etiqueta, v.tipo, v.requerido, v.orden, v.ayuda
from meta.meta_entidad e
join meta.meta_modulo m on m.id = e.modulo_id and m.nombre = 'Operación interna'
cross join (values
  ('proyecto', 'Proyecto', 'texto', true, 1, 'Proyecto al que pertenece el avance; el sistema lo hereda de la página desde donde se publica.'),
  ('producto', 'Producto', 'texto', false, 2, 'Nombre del producto al que pertenece la versión, por ejemplo Resumen de Reporte de Líneas de Acción. Las publicaciones con el mismo producto se encadenan como versiones.'),
  ('titulo', 'Título', 'texto', true, 3, 'Qué es este avance, en una frase.'),
  ('que_cambio', 'Qué cambió', 'texto_largo', true, 4, 'Una línea obligatoria que resume qué trae esta versión respecto a la anterior. Es lo que permite revisar sin abrir el archivo.'),
  ('tipo', 'Tipo', 'catalogo', true, 5, 'avance, para_revision, entrega, evidencia o nota. El tipo define qué sigue: una entrega cierra, un para_revision va a la bandeja del revisor.'),
  ('archivo', 'Archivo', 'archivo', false, 6, 'El archivo del avance. Queda almacenado en la plataforma con enlace permanente de descarga.'),
  ('version', 'Versión', 'numero', false, 7, 'La asigna el sistema de forma automática y consecutiva por producto; nadie la escribe a mano.')
) as v(nombre, etiqueta, tipo, requerido, orden, ayuda)
where e.nombre = 'avance'
on conflict (entidad_id, nombre) do nothing;
