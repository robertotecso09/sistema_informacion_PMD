-- Migración 0007 — Borrar personas del Panel de Operaciones
-- Solo director o admin, con su clave. Al borrar a alguien:
-- - desaparecen sus asignaciones (sus palomeos en tareas de otros),
-- - las tareas que esa persona creó pasan a nombre de quien la borra
--   (para no perder el trabajo registrado),
-- - se elimina su clave y su registro.
-- Nadie puede borrarse a sí mismo desde el panel.

create or replace function public.op_admin_borrar_persona(p_admin text, p_admin_pin text, p_nombre text)
returns text language plpgsql security definer set search_path = ''
as $$
begin
  if not public.op_validar_pin(p_admin, p_admin_pin) then return 'Tu clave de administrador no es válida'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_admin and rol in ('director','admin')) then
    return 'Esa cuenta no puede administrar personas'; end if;
  if p_nombre = p_admin then return 'No puedes borrarte a ti mismo'; end if;
  if not exists (select 1 from public.op_persona where nombre = p_nombre) then
    return 'Esa persona no existe'; end if;
  update public.op_tarea set creada_por = p_admin where creada_por = p_nombre;
  delete from public.op_asignacion where persona = p_nombre;
  delete from public.op_pin where persona = p_nombre;
  delete from public.op_persona where nombre = p_nombre;
  return 'ok';
end $$;

grant execute on function public.op_admin_borrar_persona(text, text, text) to anon, authenticated;
