-- Migración 0005 — Panel de Operaciones TECSO (piloto)
-- Vive en el esquema public porque es el que la API de datos ya expone:
-- el piloto funciona hoy sin pasos manuales en el panel de Supabase.
-- Acceso por persona + PIN. Los PIN viven en op_pin, tabla sin políticas
-- (nadie la lee por la API); solo se consultan mediante funciones
-- SECURITY DEFINER. Las demás tablas tienen políticas abiertas de piloto:
-- al madurar, el módulo migra al esquema app con Auth completo.

create table if not exists public.op_persona (
  id uuid primary key default gen_random_uuid(),
  nombre text unique not null,
  rol text not null default 'equipo' check (rol in ('director', 'admin', 'equipo')),
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.op_pin (
  persona text primary key references public.op_persona(nombre) on delete cascade,
  pin text not null
);

create table if not exists public.op_tarea (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  detalle text,
  audio_url text,
  creada_por text not null references public.op_persona(nombre),
  grupal boolean not null default false,
  prioridad text not null default 'media' check (prioridad in ('alta', 'media', 'baja')),
  fecha_limite date,
  created_at timestamptz not null default now()
);

create table if not exists public.op_asignacion (
  id uuid primary key default gen_random_uuid(),
  tarea_id uuid not null references public.op_tarea(id) on delete cascade,
  persona text not null references public.op_persona(nombre),
  hecho boolean not null default false,
  hecho_at timestamptz,
  unique (tarea_id, persona)
);

alter table public.op_persona enable row level security;
alter table public.op_pin enable row level security;
alter table public.op_tarea enable row level security;
alter table public.op_asignacion enable row level security;

grant select, insert, update, delete on public.op_persona, public.op_tarea, public.op_asignacion to anon, authenticated;
-- op_pin: sin grants a la API; solo las funciones la tocan.

create policy op_persona_piloto on public.op_persona for all to anon, authenticated using (true) with check (true);
create policy op_tarea_piloto on public.op_tarea for all to anon, authenticated using (true) with check (true);
create policy op_asignacion_piloto on public.op_asignacion for all to anon, authenticated using (true) with check (true);

create or replace function public.op_validar_pin(p_nombre text, p_pin text)
returns boolean language sql stable security definer set search_path = ''
as $$ select exists (select 1 from public.op_pin where persona = p_nombre and pin = p_pin) $$;

create or replace function public.op_admin_crear_persona(p_admin text, p_admin_pin text, p_nombre text, p_rol text, p_pin text)
returns text language plpgsql security definer set search_path = ''
as $$
begin
  if not public.op_validar_pin(p_admin, p_admin_pin) then return 'PIN de administrador incorrecto'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_admin and rol in ('director','admin')) then
    return 'Esa cuenta no puede administrar personas'; end if;
  insert into public.op_persona (nombre, rol) values (p_nombre, p_rol) on conflict (nombre) do nothing;
  insert into public.op_pin (persona, pin) values (p_nombre, p_pin)
    on conflict (persona) do update set pin = excluded.pin;
  return 'ok';
end $$;

grant execute on function public.op_validar_pin(text, text) to anon, authenticated;
grant execute on function public.op_admin_crear_persona(text, text, text, text, text) to anon, authenticated;

-- Almacén de notas de voz: bucket público de piloto
insert into storage.buckets (id, name, public) values ('op-audios', 'op-audios', true)
on conflict (id) do nothing;

create policy op_audios_lectura on storage.objects for select to anon, authenticated using (bucket_id = 'op-audios');
create policy op_audios_subida on storage.objects for insert to anon, authenticated with check (bucket_id = 'op-audios');

-- Tiempo real: publicar las tablas operativas
do $$
begin
  begin
    alter publication supabase_realtime add table public.op_tarea;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.op_asignacion;
  exception when duplicate_object then null;
  end;
end $$;

-- Personas iniciales del piloto
insert into public.op_persona (nombre, rol) values
  ('Víctor Fajardo', 'director'),
  ('Adrián López', 'admin')
on conflict (nombre) do nothing;
insert into public.op_pin (persona, pin) values
  ('Víctor Fajardo', '3040'),
  ('Adrián López', '1020')
on conflict (persona) do nothing;
