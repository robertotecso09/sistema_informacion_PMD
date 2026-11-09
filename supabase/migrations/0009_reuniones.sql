-- Migración 0009 — Reuniones: lo programado, visible y con control
-- Una reunión se programa con invitados; cada invitado confirma su
-- asistencia con un toque (el mismo gesto de palomear de las tareas).
-- Al crearla, los invitados reciben el aviso en tiempo real del panel.

create table if not exists public.op_reunion (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  detalle text,
  fecha_hora timestamptz not null,
  lugar text,
  creada_por text not null references public.op_persona(nombre),
  grupal boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.op_reunion_invitado (
  id uuid primary key default gen_random_uuid(),
  reunion_id uuid not null references public.op_reunion(id) on delete cascade,
  persona text not null references public.op_persona(nombre),
  confirmado boolean not null default false,
  confirmado_at timestamptz,
  unique (reunion_id, persona)
);

alter table public.op_reunion enable row level security;
alter table public.op_reunion_invitado enable row level security;
grant select, insert, update, delete on public.op_reunion, public.op_reunion_invitado to anon, authenticated;
create policy op_reunion_piloto on public.op_reunion for all to anon, authenticated using (true) with check (true);
create policy op_invitado_piloto on public.op_reunion_invitado for all to anon, authenticated using (true) with check (true);

do $$
begin
  begin
    alter publication supabase_realtime add table public.op_reunion;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table public.op_reunion_invitado;
  exception when duplicate_object then null;
  end;
end $$;
