-- Migración 0006 — Claves personales: cada quien crea su PIN la primera vez
-- Adrián solo registra el nombre; la persona inventa su clave de 4 números
-- al entrar por primera vez (con confirmación en la página). Aplica a
-- todos: las claves sembradas en la 0005 se eliminan.

delete from public.op_pin;

-- Lista pública de personas con indicador de si ya creó su clave
create or replace function public.op_lista_personas()
returns table (nombre text, rol text, tiene_pin boolean)
language sql stable security definer set search_path = ''
as $$
  select p.nombre, p.rol, exists (select 1 from public.op_pin x where x.persona = p.nombre)
  from public.op_persona p
  where p.activo
  order by p.nombre;
$$;

-- Crear la clave por primera vez (solo si aún no tiene una)
create or replace function public.op_crear_pin(p_nombre text, p_pin text)
returns text language plpgsql security definer set search_path = ''
as $$
begin
  if p_pin !~ '^\d{4}$' then return 'La clave debe tener 4 números'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_nombre and activo) then
    return 'Esa persona no está registrada'; end if;
  if exists (select 1 from public.op_pin where persona = p_nombre) then
    return 'ya_tiene'; end if;
  insert into public.op_pin (persona, pin) values (p_nombre, p_pin);
  return 'ok';
end $$;

-- Administración sin claves ajenas: agregar persona (creará su clave al entrar)
drop function if exists public.op_admin_crear_persona(text, text, text, text, text);
create or replace function public.op_admin_agregar_persona(p_admin text, p_admin_pin text, p_nombre text, p_rol text)
returns text language plpgsql security definer set search_path = ''
as $$
begin
  if not public.op_validar_pin(p_admin, p_admin_pin) then return 'Tu clave de administrador no es válida'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_admin and rol in ('director','admin')) then
    return 'Esa cuenta no puede administrar personas'; end if;
  insert into public.op_persona (nombre, rol) values (p_nombre, p_rol) on conflict (nombre) do nothing;
  return 'ok';
end $$;

-- Reiniciar la clave de alguien: la crea de nuevo en su próximo acceso
create or replace function public.op_admin_reiniciar_pin(p_admin text, p_admin_pin text, p_nombre text)
returns text language plpgsql security definer set search_path = ''
as $$
begin
  if not public.op_validar_pin(p_admin, p_admin_pin) then return 'Tu clave de administrador no es válida'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_admin and rol in ('director','admin')) then
    return 'Esa cuenta no puede administrar personas'; end if;
  delete from public.op_pin where persona = p_nombre;
  return 'ok';
end $$;

grant execute on function public.op_lista_personas() to anon, authenticated;
grant execute on function public.op_crear_pin(text, text) to anon, authenticated;
grant execute on function public.op_admin_agregar_persona(text, text, text, text) to anon, authenticated;
grant execute on function public.op_admin_reiniciar_pin(text, text, text) to anon, authenticated;
