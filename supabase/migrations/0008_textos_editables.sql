-- Migración 0008 — Textos editables del Panel de Operaciones
-- Adrián (y Víctor) editan los textos visibles del panel desde la propia
-- página, sin tocar HTML: tabla clave/valor con los textos actuales como
-- valores iniciales. La página lee esta tabla al abrir y usa sus valores;
-- si una clave no existe, conserva el texto por defecto del código.

create table if not exists public.op_config (
  clave text primary key,
  valor text not null,
  updated_at timestamptz not null default now()
);

alter table public.op_config enable row level security;
grant select, insert, update, delete on public.op_config to anon, authenticated;
create policy op_config_piloto on public.op_config for all to anon, authenticated using (true) with check (true);

insert into public.op_config (clave, valor) values
  ('titulo_panel', 'TECSO · Panel de trabajo'),
  ('saludo_acceso', 'Hola 👋'),
  ('subtitulo_acceso', 'Toca tu nombre para ver tus pendientes de TECSO.'),
  ('guia_titulo', 'Así funciona, en 10 segundos:'),
  ('guia_pasos', 'Aquí te llegan las tareas que te dejan Víctor y el equipo.
Cuando termines una, toca el botón verde «Ya lo hice».
Para dejarle algo a alguien, ve a ➕ Nueva abajo. Puedes grabar una nota de voz.'),
  ('boton_hecho', '✓ Ya lo hice'),
  ('vacio_pendientes', 'Todo tranquilo por aquí. Cuando te dejen una tarea, aparecerá en esta pantalla.'),
  ('titulo_nueva', 'Nueva indicación'),
  ('boton_enviar', 'Enviar indicación ✓'),
  ('titulo_equipo', 'Trabajo del equipo 👥'),
  ('subtitulo_equipo', 'Quién ya hizo qué, en vivo.')
on conflict (clave) do nothing;
