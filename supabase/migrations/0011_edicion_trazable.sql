-- Migración 0011 — Edición trazable de las peticiones ya enviadas
-- Dos piezas:
-- 1) op_tarea_nota: contexto que se agrega a una tarea después de enviada
--    (aclaraciones, datos nuevos), como hilo visible en la tarjeta.
-- 2) op_cambio: bitácora de cambios. Cada edición de una tarea registra
--    quién cambió qué campo, el valor anterior y el nuevo, y cuándo.
--    Nada se modifica en silencio: todo queda en el historial.

create table if not exists public.op_tarea_nota (
  id uuid primary key default gen_random_uuid(),
  tarea_id uuid not null references public.op_tarea(id) on delete cascade,
  autor text not null references public.op_persona(nombre),
  texto text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.op_cambio (
  id uuid primary key default gen_random_uuid(),
  entidad text not null default 'tarea',
  entidad_id uuid not null,
  campo text not null,
  valor_anterior text,
  valor_nuevo text,
  autor text not null references public.op_persona(nombre),
  created_at timestamptz not null default now()
);

create index if not exists idx_cambio_entidad on public.op_cambio (entidad_id, created_at desc);
create index if not exists idx_nota_tarea on public.op_tarea_nota (tarea_id, created_at);

alter table public.op_tarea_nota enable row level security;
alter table public.op_cambio enable row level security;
grant select, insert, update, delete on public.op_tarea_nota, public.op_cambio to anon, authenticated;
create policy op_nota_piloto on public.op_tarea_nota for all to anon, authenticated using (true) with check (true);
create policy op_cambio_piloto on public.op_cambio for all to anon, authenticated using (true) with check (true);

do $$
begin
  begin
    alter publication supabase_realtime add table public.op_tarea_nota;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.op_cambio;
  exception when duplicate_object then null;
  end;
end $$;
