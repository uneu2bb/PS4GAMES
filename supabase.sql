-- GAMING ZONE database schema. Run in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.games (
 id uuid primary key default gen_random_uuid(), name text not null, category text not null default 'أكشن',
 price numeric(10,2) not null check(price >= 0), old_price numeric(10,2) not null default 0 check(old_price >= 0),
 year integer, condition text default 'مستعمل بحالة جيدة', stock integer not null default 0 check(stock >= 0),
 featured boolean not null default false, image text, description text, active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.orders (
 id uuid primary key default gen_random_uuid(), order_number text not null unique,
 customer_name text not null, phone text not null, address text not null, notes text,
 items jsonb not null, total numeric(10,2) not null check(total >= 0),
 payment_method text not null default 'bank_transfer', status text not null default 'pending' check(status in ('pending','paid','shipped','cancelled')),
 created_at timestamptz not null default now()
);
alter table public.games enable row level security;
alter table public.orders enable row level security;
drop policy if exists "Anyone can view active games" on public.games;
create policy "Anyone can view active games" on public.games for select using (active = true or (auth.jwt()->'app_metadata'->>'role' = 'admin'));
drop policy if exists "Admins can add games" on public.games;
create policy "Admins can add games" on public.games for insert to authenticated with check (auth.jwt()->'app_metadata'->>'role' = 'admin');
drop policy if exists "Admins can edit games" on public.games;
create policy "Admins can edit games" on public.games for update to authenticated using (auth.jwt()->'app_metadata'->>'role' = 'admin') with check (auth.jwt()->'app_metadata'->>'role' = 'admin');
drop policy if exists "Admins can delete games" on public.games;
create policy "Admins can delete games" on public.games for delete to authenticated using (auth.jwt()->'app_metadata'->>'role' = 'admin');
drop policy if exists "Visitors can place orders" on public.orders;
create policy "Visitors can place orders" on public.orders for insert to anon, authenticated with check (status = 'pending' and payment_method = 'bank_transfer');
drop policy if exists "Admins can read orders" on public.orders;
create policy "Admins can read orders" on public.orders for select to authenticated using (auth.jwt()->'app_metadata'->>'role' = 'admin');
drop policy if exists "Admins can update orders" on public.orders;
create policy "Admins can update orders" on public.orders for update to authenticated using (auth.jwt()->'app_metadata'->>'role' = 'admin') with check (auth.jwt()->'app_metadata'->>'role' = 'admin');
-- Add initial games from the admin dashboard after connecting the site, or import them separately.
