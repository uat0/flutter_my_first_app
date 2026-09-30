-- Выполнить один раз: Supabase → SQL Editor → New query → вставить → Run

-- ===== Профили пользователей =====
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text not null,
  last_name  text not null,
  email      text not null,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "profiles: read own"
  on public.profiles for select to authenticated
  using ((select auth.uid()) = id);

-- Профиль создаётся автоматически при регистрации
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, first_name, last_name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'first_name', ''),
    coalesce(new.raw_user_meta_data ->> 'last_name', ''),
    new.email
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ===== История расчётов ИМТ =====
create table if not exists public.bmi_records (
  id         bigint generated always as identity primary key,
  user_id    uuid not null default auth.uid()
             references auth.users (id) on delete cascade,
  weight     numeric(5,2) not null check (weight > 0),  -- кг
  height     numeric(4,2) not null check (height > 0),  -- метры
  bmi        numeric(5,2) not null,
  category   text not null,
  created_at timestamptz not null default now()
);

create index if not exists bmi_records_user_created_idx
  on public.bmi_records (user_id, created_at desc);

alter table public.bmi_records enable row level security;

create policy "bmi: read own"
  on public.bmi_records for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "bmi: insert own"
  on public.bmi_records for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "bmi: delete own"
  on public.bmi_records for delete to authenticated
  using ((select auth.uid()) = user_id);
