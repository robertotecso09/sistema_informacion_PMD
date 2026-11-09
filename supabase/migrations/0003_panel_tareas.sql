-- Migración 0003 — Panel de trabajo: delegación de tareas de TECSO
-- Tabla operativa en el esquema app y su registro en el molde (meta).
-- Estados del flujo de delegación:
--   pendiente -> en_proceso -> realizado -> revisado
-- (realizado lo marca el responsable; revisado, el revisor)

create or replace function app.tiene_rol(p_rol text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from app.app_usuario_rol r
    where r.usuario_id = auth.uid() and r.rol = p_rol
  );
$$;

create table if not exists app.app_tarea (
  id uuid primary key default gen_random_uuid(),
  proyecto text not null,
  titulo text not null,
  descripcion text,
  responsable text,
  revisor text,
  fecha_compromiso date,
  fecha_revision date,
  estado text not null default 'pendiente'
    check (estado in ('pendiente', 'en_proceso', 'realizado', 'revisado')),
  prioridad text not null default 'media'
    check (prioridad in ('alta', 'media', 'baja')),
  fuente text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table app.app_tarea enable row level security;

grant select, insert, update, delete on app.app_tarea to authenticated;

create policy tarea_lectura on app.app_tarea
  for select to authenticated using (true);
create policy tarea_escritura on app.app_tarea
  for all to authenticated
  using (app.tiene_rol('admin_tecso') or app.tiene_rol('equipo_tecso'))
  with check (app.tiene_rol('admin_tecso') or app.tiene_rol('equipo_tecso'));

-- Registro de la entidad en el molde: el Panel nace descrito por el Manager
insert into meta.meta_modulo (nombre, descripcion, orden)
values ('Operación interna', 'Delegación de tareas, pendientes por proyecto y revisión del trabajo del equipo TECSO.', 1)
on conflict (nombre) do nothing;

insert into meta.meta_entidad (modulo_id, nombre, capa, descripcion, campo_clave, campo_visible)
select id, 'tarea', 'core',
       'Pendiente de un proyecto con responsable, revisor, fecha de compromiso y fecha de revisión. Flujo: pendiente, en proceso, realizado, revisado.',
       'id', 'titulo'
from meta.meta_modulo where nombre = 'Operación interna'
on conflict (modulo_id, nombre) do nothing;

insert into meta.meta_campo (entidad_id, nombre, etiqueta, tipo, requerido, orden, ayuda)
select e.id, v.nombre, v.etiqueta, v.tipo, v.requerido, v.orden, v.ayuda
from meta.meta_entidad e
join meta.meta_modulo m on m.id = e.modulo_id and m.nombre = 'Operación interna'
cross join (values
  ('proyecto', 'Proyecto', 'texto', true, 1, 'Proyecto o cliente al que pertenece el pendiente, por ejemplo Huimanguillo o San Pedro Garza García.'),
  ('titulo', 'Título', 'texto', true, 2, 'El pendiente en una frase accionable: qué hay que hacer y sobre qué.'),
  ('responsable', 'Responsable', 'texto', true, 3, 'Persona que ejecuta el pendiente.'),
  ('revisor', 'Revisor', 'texto', false, 4, 'Persona que revisa el trabajo cuando el responsable lo marca realizado.'),
  ('fecha_compromiso', 'Fecha de compromiso', 'fecha', false, 5, 'Fecha en que el pendiente debe estar realizado.'),
  ('fecha_revision', 'Fecha de revisión', 'fecha', false, 6, 'Fecha en que el revisor debe checar el trabajo realizado.'),
  ('estado', 'Estado', 'catalogo', true, 7, 'pendiente, en_proceso, realizado o revisado. Realizado lo marca el responsable; revisado, el revisor.'),
  ('prioridad', 'Prioridad', 'catalogo', false, 8, 'alta, media o baja, según el impacto en la entrega del proyecto.'),
  ('fuente', 'Fuente', 'texto', false, 9, 'De dónde salió el pendiente: nota diaria, reunión, inventario o acuerdo.')
) as v(nombre, etiqueta, tipo, requerido, orden, ayuda)
where e.nombre = 'tarea'
on conflict (entidad_id, nombre) do nothing;
