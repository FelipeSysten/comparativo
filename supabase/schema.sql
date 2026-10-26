-- Comparativo de Prescritores — schema do Supabase
-- Rode este arquivo inteiro em: Supabase > SQL Editor > New query > Run

create table if not exists public.months (
  id          bigint generated always as identity primary key,
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  year        int  not null check (year between 2000 and 2100),
  month       int  not null check (month between 1 and 12),
  file        text,
  sheet       text,
  rows        jsonb not null default '[]'::jsonb,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (user_id, year, month)
);

-- Cada usuário só enxerga e altera as próprias planilhas
alter table public.months enable row level security;

drop policy if exists "months_select_own" on public.months;
drop policy if exists "months_insert_own" on public.months;
drop policy if exists "months_update_own" on public.months;
drop policy if exists "months_delete_own" on public.months;

create policy "months_select_own" on public.months
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "months_insert_own" on public.months
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "months_update_own" on public.months
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "months_delete_own" on public.months
  for delete to authenticated using ((select auth.uid()) = user_id);

create or replace function public.months_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists months_touch on public.months;
create trigger months_touch before update on public.months
  for each row execute function public.months_touch();
