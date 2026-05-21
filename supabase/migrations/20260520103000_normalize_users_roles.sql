begin;

create table if not exists public.roles (
  id uuid primary key default gen_random_uuid(),
  name text not null unique check (name in ('customer', 'owner', 'admin')),
  label text not null,
  description text,
  created_at timestamptz not null default now()
);

insert into public.roles (name, label, description)
values
  ('customer', 'Customer', 'User/customer yang melakukan booking lapangan.'),
  ('owner', 'Owner', 'Pemilik venue dengan akses baca data venue miliknya.'),
  ('admin', 'Admin', 'Admin operasional dengan akses kelola data.')
on conflict (name) do update
set
  label = excluded.label,
  description = excluded.description;

alter table public.profiles
add column if not exists role_id uuid;

update public.profiles p
set role_id = r.id
from public.roles r
where r.name = p.role::text
  and p.role_id is null;

alter table public.profiles
alter column role_id set not null;

alter table public.profiles
add constraint profiles_role_id_fkey
foreign key (role_id) references public.roles(id) on delete restrict;

create index if not exists idx_profiles_role_id on public.profiles(role_id);

alter table public.profiles rename to users;

alter index if exists idx_profiles_role_id rename to idx_users_role_id;
alter table public.users rename constraint profiles_role_id_fkey to users_role_id_fkey;

create or replace function public.protect_profile_system_fields()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() = old.id and (
    new.role_id is distinct from old.role_id
    or new.wallet_balance is distinct from old.wallet_balance
    or new.points is distinct from old.points
  ) then
    raise exception 'role, wallet_balance, and points cannot be updated by the user';
  end if;

  return new;
end;
$$;

create or replace function public.current_user_role()
returns public.app_role
language sql
security definer
set search_path = public
stable
as $$
  select r.name::public.app_role
  from public.users u
  join public.roles r on r.id = u.role_id
  where u.id = auth.uid();
$$;

create or replace function public.can_read_user(p_user_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select
    p_user_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1
      from public.bookings b
      join public.courts c on c.id = b.court_id
      join public.venues v on v.id = c.venue_id
      where b.user_id = p_user_id
        and v.owner_id = auth.uid()
    );
$$;

create or replace function public.can_read_profile(p_profile_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select public.can_read_user(p_profile_id);
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_customer_role_id uuid;
begin
  select id
  into v_customer_role_id
  from public.roles
  where name = 'customer';

  insert into public.users (id, role_id, full_name, phone, avatar_url)
  values (
    new.id,
    v_customer_role_id,
    coalesce(
      nullif(new.raw_user_meta_data->>'full_name', ''),
      nullif(new.raw_user_meta_data->>'name', ''),
      nullif(split_part(new.email, '@', 1), ''),
      'User Aerobook'
    ),
    nullif(new.raw_user_meta_data->>'phone', ''),
    nullif(new.raw_user_meta_data->>'avatar_url', '')
  )
  on conflict (id) do nothing;

  return new;
exception
  when others then
    raise warning 'handle_new_user failed for auth user %: %', new.id, sqlerrm;
    return new;
end;
$$;

create or replace function public.ensure_customer_user()
returns public.users
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_user public.users;
  v_email text;
  v_meta jsonb;
  v_customer_role_id uuid;
begin
  if auth.uid() is null then
    raise exception 'Authentication required';
  end if;

  select email, raw_user_meta_data
  into v_email, v_meta
  from auth.users
  where id = auth.uid();

  select id
  into v_customer_role_id
  from public.roles
  where name = 'customer';

  insert into public.users (id, role_id, full_name, phone, avatar_url)
  values (
    auth.uid(),
    v_customer_role_id,
    coalesce(
      nullif(v_meta->>'full_name', ''),
      nullif(v_meta->>'name', ''),
      nullif(split_part(v_email, '@', 1), ''),
      'User Aerobook'
    ),
    nullif(v_meta->>'phone', ''),
    nullif(v_meta->>'avatar_url', '')
  )
  on conflict (id) do update
  set
    full_name = coalesce(nullif(public.users.full_name, ''), excluded.full_name),
    phone = coalesce(public.users.phone, excluded.phone),
    avatar_url = coalesce(public.users.avatar_url, excluded.avatar_url)
  returning * into v_user;

  return v_user;
end;
$$;

create or replace function public.ensure_customer_profile()
returns public.users
language sql
security definer
set search_path = public
as $$
  select * from public.ensure_customer_user();
$$;

alter table public.users drop column if exists role;

alter table public.roles enable row level security;

drop policy if exists "roles_public_select" on public.roles;
create policy "roles_public_select"
on public.roles for select
using (true);

drop policy if exists "roles_admin_all" on public.roles;
create policy "roles_admin_all"
on public.roles for all
using (public.is_admin())
with check (public.is_admin());

grant execute on function public.ensure_customer_user() to authenticated;
grant execute on function public.ensure_customer_profile() to authenticated;

commit;
