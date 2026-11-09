-- Migración 0010 — Avisos generales del Panel de Operaciones
-- Un aviso es un mensaje de la dirección a todo el equipo que aparece en
-- el panel en tiempo real. Su primer uso: la campaña de activación de
-- notificaciones — el aviso llega a cada aparato con el botón grande de
-- activar, porque el permiso solo lo puede conceder cada persona en su
-- propio teléfono (regla de todos los navegadores).

create table if not exists public.op_aviso (
  id uuid primary key default gen_random_uuid(),
  texto text not null,
  tipo text not null default 'general' check (tipo in ('general', 'activacion')),
  creado_por text not null references public.op_persona(nombre),
  created_at timestamptz not null default now()
);

alter table public.op_aviso enable row level security;
grant select, insert, update, delete on public.op_aviso to anon, authenticated;
create policy op_aviso_piloto on public.op_aviso for all to anon, authenticated using (true) with check (true);

do $$
begin
  begin
    alter publication supabase_realtime add table public.op_aviso;
  exception when duplicate_object then null;
  end;
end $$;
