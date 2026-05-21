create or replace function public.slugify(p_value text)
returns text
language sql
immutable
as $$
  select trim(both '-' from regexp_replace(lower(coalesce(p_value, '')), '[^a-z0-9]+', '-', 'g'));
$$;

create or replace function public.admin_owners()
returns table (
  owner_id uuid,
  email text,
  full_name text,
  phone text,
  venues_count bigint
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_admin();

  return query
  select
    u.id,
    au.email::text,
    u.full_name,
    u.phone,
    count(v.id) as venues_count
  from public.users u
  join public.roles r on r.id = u.role_id
  left join auth.users au on au.id = u.id
  left join public.venues v on v.owner_id = u.id
  where r.name = 'owner'
  group by u.id, au.email, u.full_name, u.phone
  order by u.full_name;
end;
$$;

create or replace function public.admin_sports()
returns table (
  sport_id uuid,
  name text,
  slug text,
  icon_url text,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_admin();

  return query
  select
    s.id,
    s.name,
    s.slug,
    s.icon_url,
    s.is_active
  from public.sports s
  order by s.name;
end;
$$;

create or replace function public.admin_create_venue(
  p_name text,
  p_city text,
  p_address text,
  p_owner_id uuid default null,
  p_description text default null,
  p_latitude numeric default null,
  p_longitude numeric default null,
  p_status text default 'open'
)
returns table (
  venue_id uuid,
  name text,
  slug text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_base_slug text;
  v_slug text;
  v_suffix integer := 1;
  v_venue_id uuid;
begin
  perform public.require_admin();

  if nullif(trim(p_name), '') is null then
    raise exception 'Venue name is required';
  end if;

  if nullif(trim(p_city), '') is null then
    raise exception 'Venue city is required';
  end if;

  if nullif(trim(p_address), '') is null then
    raise exception 'Venue address is required';
  end if;

  if p_status not in ('open', 'closed') then
    raise exception 'Invalid venue status';
  end if;

  if p_owner_id is not null and not exists (
    select 1
    from public.users u
    join public.roles r on r.id = u.role_id
    where u.id = p_owner_id
      and r.name = 'owner'
  ) then
    raise exception 'Owner user not found';
  end if;

  v_base_slug := coalesce(nullif(public.slugify(p_name), ''), 'venue');
  v_slug := v_base_slug;

  while exists (select 1 from public.venues where slug = v_slug) loop
    v_suffix := v_suffix + 1;
    v_slug := concat(v_base_slug, '-', v_suffix);
  end loop;

  insert into public.venues (
    owner_id,
    name,
    slug,
    description,
    address,
    city,
    latitude,
    longitude,
    status
  )
  values (
    p_owner_id,
    trim(p_name),
    v_slug,
    nullif(trim(p_description), ''),
    trim(p_address),
    trim(p_city),
    p_latitude,
    p_longitude,
    p_status
  )
  returning id into v_venue_id;

  return query
  select v.id, v.name, v.slug, v.status
  from public.venues v
  where v.id = v_venue_id;
end;
$$;

create or replace function public.admin_update_venue(
  p_venue_id uuid,
  p_name text,
  p_city text,
  p_address text,
  p_owner_id uuid default null,
  p_description text default null,
  p_latitude numeric default null,
  p_longitude numeric default null,
  p_status text default 'open'
)
returns table (
  venue_id uuid,
  name text,
  slug text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues where id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if nullif(trim(p_name), '') is null then
    raise exception 'Venue name is required';
  end if;

  if nullif(trim(p_city), '') is null then
    raise exception 'Venue city is required';
  end if;

  if nullif(trim(p_address), '') is null then
    raise exception 'Venue address is required';
  end if;

  if p_status not in ('open', 'closed') then
    raise exception 'Invalid venue status';
  end if;

  if p_owner_id is not null and not exists (
    select 1
    from public.users u
    join public.roles r on r.id = u.role_id
    where u.id = p_owner_id
      and r.name = 'owner'
  ) then
    raise exception 'Owner user not found';
  end if;

  update public.venues
  set
    owner_id = p_owner_id,
    name = trim(p_name),
    description = nullif(trim(p_description), ''),
    address = trim(p_address),
    city = trim(p_city),
    latitude = p_latitude,
    longitude = p_longitude,
    status = p_status,
    updated_at = now()
  where id = p_venue_id;

  return query
  select v.id, v.name, v.slug, v.status
  from public.venues v
  where v.id = p_venue_id;
end;
$$;

create or replace function public.admin_create_court(
  p_venue_id uuid,
  p_sport_id uuid,
  p_name text,
  p_price_per_hour integer,
  p_surface text default null,
  p_environment text default 'Indoor',
  p_status text default 'active'
)
returns table (
  court_id uuid,
  venue_id uuid,
  court_name text,
  slug text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_base_slug text;
  v_slug text;
  v_suffix integer := 1;
  v_court_id uuid;
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues where id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if not exists (select 1 from public.sports where id = p_sport_id and is_active = true) then
    raise exception 'Active sport not found';
  end if;

  if nullif(trim(p_name), '') is null then
    raise exception 'Court name is required';
  end if;

  if p_price_per_hour is null or p_price_per_hour < 0 then
    raise exception 'Price per hour must be greater than or equal to zero';
  end if;

  if p_status not in ('active', 'inactive', 'maintenance') then
    raise exception 'Invalid court status';
  end if;

  v_base_slug := coalesce(nullif(public.slugify(p_name), ''), 'court');
  v_slug := v_base_slug;

  while exists (
    select 1
    from public.courts
    where venue_id = p_venue_id
      and slug = v_slug
  ) loop
    v_suffix := v_suffix + 1;
    v_slug := concat(v_base_slug, '-', v_suffix);
  end loop;

  insert into public.courts (
    venue_id,
    sport_id,
    name,
    slug,
    surface,
    environment,
    price_per_hour,
    status
  )
  values (
    p_venue_id,
    p_sport_id,
    trim(p_name),
    v_slug,
    nullif(trim(p_surface), ''),
    coalesce(nullif(trim(p_environment), ''), 'Indoor'),
    p_price_per_hour,
    p_status
  )
  returning id into v_court_id;

  return query
  select c.id, c.venue_id, c.name, c.slug, c.status
  from public.courts c
  where c.id = v_court_id;
end;
$$;

create or replace function public.admin_update_court(
  p_court_id uuid,
  p_venue_id uuid,
  p_sport_id uuid,
  p_name text,
  p_price_per_hour integer,
  p_surface text default null,
  p_environment text default 'Indoor',
  p_status text default 'active'
)
returns table (
  court_id uuid,
  venue_id uuid,
  court_name text,
  slug text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.courts where id = p_court_id) then
    raise exception 'Court not found';
  end if;

  if not exists (select 1 from public.venues where id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if not exists (select 1 from public.sports where id = p_sport_id and is_active = true) then
    raise exception 'Active sport not found';
  end if;

  if nullif(trim(p_name), '') is null then
    raise exception 'Court name is required';
  end if;

  if p_price_per_hour is null or p_price_per_hour < 0 then
    raise exception 'Price per hour must be greater than or equal to zero';
  end if;

  if p_status not in ('active', 'inactive', 'maintenance') then
    raise exception 'Invalid court status';
  end if;

  update public.courts
  set
    venue_id = p_venue_id,
    sport_id = p_sport_id,
    name = trim(p_name),
    surface = nullif(trim(p_surface), ''),
    environment = coalesce(nullif(trim(p_environment), ''), 'Indoor'),
    price_per_hour = p_price_per_hour,
    status = p_status,
    updated_at = now()
  where id = p_court_id;

  return query
  select c.id, c.venue_id, c.name, c.slug, c.status
  from public.courts c
  where c.id = p_court_id;
end;
$$;

grant execute on function public.admin_owners() to authenticated;
grant execute on function public.admin_sports() to authenticated;
grant execute on function public.admin_create_venue(text, text, text, uuid, text, numeric, numeric, text) to authenticated;
grant execute on function public.admin_update_venue(uuid, text, text, text, uuid, text, numeric, numeric, text) to authenticated;
grant execute on function public.admin_create_court(uuid, uuid, text, integer, text, text, text) to authenticated;
grant execute on function public.admin_update_court(uuid, uuid, uuid, text, integer, text, text, text) to authenticated;
