-- Migración 0001 — Esqueleto del molde del Warehouse Manager (TECSO)
-- Estado: PREPARADA, aún no aplicada. Se aplicará vía API de gestión de
-- Supabase en cuanto la credencial de gestión verifique correctamente.
-- Diseño: el warehouse se describe a sí mismo en el esquema `meta`.
-- No toca el esquema `public` ni ningún objeto del sistema PMD vigente.

create schema if not exists meta;
create schema if not exists raw;
create schema if not exists core;
create schema if not exists rpt;
create schema if not exists app;

-- ============================================================
-- META: los objetos del molde que Adrián rellena desde la página
-- ============================================================

create table if not exists meta.meta_modulo (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  descripcion text,
  icono text,
  orden int not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists meta.meta_entidad (
  id uuid primary key default gen_random_uuid(),
  modulo_id uuid not null references meta.meta_modulo(id),
  nombre text not null,
  capa text not null check (capa in ('raw', 'core', 'rpt')),
  descripcion text,
  campo_clave text,
  campo_visible text,
  activa boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (modulo_id, nombre)
);

create table if not exists meta.meta_catalogo (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  descripcion text,
  created_at timestamptz not null default now()
);

create table if not exists meta.meta_catalogo_valor (
  id uuid primary key default gen_random_uuid(),
  catalogo_id uuid not null references meta.meta_catalogo(id) on delete cascade,
  clave text not null,
  etiqueta text not null,
  orden int not null default 0,
  activo boolean not null default true,
  unique (catalogo_id, clave)
);

create table if not exists meta.meta_campo (
  id uuid primary key default gen_random_uuid(),
  entidad_id uuid not null references meta.meta_entidad(id) on delete cascade,
  nombre text not null,
  etiqueta text not null,
  tipo text not null check (tipo in
    ('texto', 'numero', 'decimal', 'fecha', 'fecha_hora', 'booleano',
     'catalogo', 'relacion', 'archivo', 'texto_largo')),
  requerido boolean not null default false,
  unico boolean not null default false,
  orden int not null default 0,
  ayuda text,
  catalogo_id uuid references meta.meta_catalogo(id),
  relacion_entidad_id uuid references meta.meta_entidad(id),
  valor_defecto text,
  unique (entidad_id, nombre)
);

create table if not exists meta.meta_relacion (
  id uuid primary key default gen_random_uuid(),
  entidad_origen_id uuid not null references meta.meta_entidad(id) on delete cascade,
  campo_origen_id uuid not null references meta.meta_campo(id) on delete cascade,
  entidad_destino_id uuid not null references meta.meta_entidad(id),
  cardinalidad text not null default 'muchos_a_uno'
    check (cardinalidad in ('muchos_a_uno', 'uno_a_uno', 'muchos_a_muchos')),
  al_borrar text not null default 'restringir'
    check (al_borrar in ('restringir', 'cascada', 'nulo'))
);

create table if not exists meta.meta_formulario (
  id uuid primary key default gen_random_uuid(),
  entidad_id uuid not null references meta.meta_entidad(id) on delete cascade,
  nombre text not null,
  rol text not null,
  descripcion text,
  unique (entidad_id, nombre)
);

create table if not exists meta.meta_formulario_campo (
  id uuid primary key default gen_random_uuid(),
  formulario_id uuid not null references meta.meta_formulario(id) on delete cascade,
  campo_id uuid not null references meta.meta_campo(id) on delete cascade,
  orden int not null default 0,
  seccion text,
  editable boolean not null default true,
  unique (formulario_id, campo_id)
);

create table if not exists meta.meta_validacion (
  id uuid primary key default gen_random_uuid(),
  campo_id uuid not null references meta.meta_campo(id) on delete cascade,
  tipo_regla text not null,
  parametros jsonb not null default '{}'::jsonb,
  mensaje text not null
);

create table if not exists meta.meta_transformacion (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  capa_origen text not null check (capa_origen in ('raw', 'core')),
  entidad_origen_id uuid references meta.meta_entidad(id),
  capa_destino text not null check (capa_destino in ('core', 'rpt')),
  entidad_destino_id uuid references meta.meta_entidad(id),
  mapeo jsonb not null default '{}'::jsonb,
  orden int not null default 0,
  activa boolean not null default true
);

create table if not exists meta.meta_reporte (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  descripcion text,
  fuente text not null,
  columnas jsonb not null default '[]'::jsonb,
  filtros jsonb not null default '[]'::jsonb,
  agrupacion jsonb not null default '[]'::jsonb
);

-- ============================================================
-- APP: usuarios, roles y auditoría
-- ============================================================

create table if not exists app.app_usuario_rol (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null,
  rol text not null check (rol in
    ('admin_tecso', 'equipo_tecso', 'capturista_municipal', 'ejecutivo')),
  municipio text,
  area text,
  created_at timestamptz not null default now(),
  unique (usuario_id, rol, municipio, area)
);

create table if not exists app.app_auditoria (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid,
  objeto_tipo text not null,
  objeto_id uuid,
  accion text not null,
  detalle jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- RLS activo desde el nacimiento en todas las tablas del molde.
-- Sin políticas todavía: el acceso vía API pública queda denegado por
-- defecto y las políticas por rol se agregan en la migración 0002,
-- junto con la autenticación de la página de administración.
alter table meta.meta_modulo enable row level security;
alter table meta.meta_entidad enable row level security;
alter table meta.meta_catalogo enable row level security;
alter table meta.meta_catalogo_valor enable row level security;
alter table meta.meta_campo enable row level security;
alter table meta.meta_relacion enable row level security;
alter table meta.meta_formulario enable row level security;
alter table meta.meta_formulario_campo enable row level security;
alter table meta.meta_validacion enable row level security;
alter table meta.meta_transformacion enable row level security;
alter table meta.meta_reporte enable row level security;
alter table app.app_usuario_rol enable row level security;
alter table app.app_auditoria enable row level security;
