-- Migración 0002 — Permisos y políticas RLS del molde (Warehouse Manager)
-- Estado: PREPARADA junto con la 0001. Se aplica después de la 0001.
-- Reglas:
--  * Los metadatos (esquema meta) se pueden LEER con la llave publishable:
--    son estructura, no datos sensibles, y la app de captura necesita
--    leerlos para dibujar formularios.
--  * Solo usuarios autenticados con rol admin_tecso pueden ESCRIBIR
--    en el molde.
--  * Cada usuario ve únicamente sus propios roles en app_usuario_rol;
--    el administrador ve y gestiona todos.
--  * La auditoría acepta inserciones de usuarios autenticados y solo
--    la lee el administrador.
-- La función app.es_admin() es SECURITY DEFINER para que las políticas
-- puedan consultar app_usuario_rol sin recursión infinita de RLS.

create or replace function app.es_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from app.app_usuario_rol r
    where r.usuario_id = auth.uid() and r.rol = 'admin_tecso'
  );
$$;

grant usage on schema meta to anon, authenticated;
grant usage on schema app to anon, authenticated;
grant usage on schema core to anon, authenticated;
grant usage on schema rpt to anon, authenticated;

grant select on all tables in schema meta to anon, authenticated;
grant insert, update, delete on all tables in schema meta to authenticated;

grant select, insert, update, delete on all tables in schema app to authenticated;

-- ============ meta: lectura abierta, escritura solo admin_tecso ============

create policy meta_lectura on meta.meta_modulo
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_modulo
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_entidad
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_entidad
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_catalogo
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_catalogo
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_catalogo_valor
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_catalogo_valor
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_campo
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_campo
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_relacion
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_relacion
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_formulario
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_formulario
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_formulario_campo
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_formulario_campo
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_validacion
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_validacion
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_transformacion
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_transformacion
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

create policy meta_lectura on meta.meta_reporte
  for select to anon, authenticated using (true);
create policy meta_escritura on meta.meta_reporte
  for all to authenticated using (app.es_admin()) with check (app.es_admin());

-- ============ app: roles propios o administración total ============

create policy roles_propios_o_admin on app.app_usuario_rol
  for select to authenticated
  using (usuario_id = auth.uid() or app.es_admin());
create policy roles_escritura_admin on app.app_usuario_rol
  for all to authenticated
  using (app.es_admin()) with check (app.es_admin());

create policy auditoria_insert on app.app_auditoria
  for insert to authenticated with check (true);
create policy auditoria_lectura_admin on app.app_auditoria
  for select to authenticated using (app.es_admin());
