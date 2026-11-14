-- Tabla donde se guardan los datos de cada persona.
-- Pégalo completo en Supabase > SQL Editor y presiona Run.

create table if not exists public.presupuestos (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- Cada persona puede ver y cambiar solo su propia fila.
alter table public.presupuestos enable row level security;

create policy "leer lo propio" on public.presupuestos
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "crear lo propio" on public.presupuestos
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "actualizar lo propio" on public.presupuestos
  for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create policy "borrar lo propio" on public.presupuestos
  for delete to authenticated using ((select auth.uid()) = user_id);
