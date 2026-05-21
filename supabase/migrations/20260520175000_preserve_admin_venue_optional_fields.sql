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
    description = coalesce(nullif(trim(p_description), ''), description),
    address = trim(p_address),
    city = trim(p_city),
    latitude = coalesce(p_latitude, latitude),
    longitude = coalesce(p_longitude, longitude),
    status = p_status,
    updated_at = now()
  where id = p_venue_id;

  return query
  select v.id, v.name, v.slug, v.status
  from public.venues v
  where v.id = p_venue_id;
end;
$$;
