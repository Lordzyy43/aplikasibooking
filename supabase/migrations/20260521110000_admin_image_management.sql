create or replace function public.admin_venue_images(p_venue_id uuid)
returns table (
  image_id uuid,
  venue_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues v where v.id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  return query
  select
    vi.id,
    vi.venue_id,
    vi.image_url,
    vi.alt_text,
    vi.sort_order,
    vi.is_primary,
    vi.created_at
  from public.venue_images vi
  where vi.venue_id = p_venue_id
  order by vi.is_primary desc, vi.sort_order, vi.created_at;
end;
$$;

create or replace function public.admin_create_venue_image(
  p_venue_id uuid,
  p_image_url text,
  p_alt_text text default null,
  p_sort_order integer default 0,
  p_is_primary boolean default false
)
returns table (
  image_id uuid,
  venue_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_image_id uuid;
  v_is_primary boolean;
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues v where v.id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if nullif(trim(p_image_url), '') is null then
    raise exception 'Image URL is required';
  end if;

  v_is_primary := coalesce(p_is_primary, false)
    or not exists (select 1 from public.venue_images vi where vi.venue_id = p_venue_id);

  if v_is_primary then
    update public.venue_images
    set is_primary = false
    where venue_id = p_venue_id;
  end if;

  insert into public.venue_images (
    venue_id,
    image_url,
    alt_text,
    sort_order,
    is_primary
  )
  values (
    p_venue_id,
    trim(p_image_url),
    nullif(trim(p_alt_text), ''),
    coalesce(p_sort_order, 0),
    v_is_primary
  )
  returning id into v_image_id;

  return query
  select *
  from public.admin_venue_images(p_venue_id) images
  where images.image_id = v_image_id;
end;
$$;

create or replace function public.admin_update_venue_image(
  p_image_id uuid,
  p_image_url text,
  p_alt_text text default null,
  p_sort_order integer default 0,
  p_is_primary boolean default false
)
returns table (
  image_id uuid,
  venue_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue_id uuid;
  v_remaining_primary_id uuid;
begin
  perform public.require_admin();

  select vi.venue_id
  into v_venue_id
  from public.venue_images vi
  where vi.id = p_image_id;

  if v_venue_id is null then
    raise exception 'Venue image not found';
  end if;

  if nullif(trim(p_image_url), '') is null then
    raise exception 'Image URL is required';
  end if;

  if coalesce(p_is_primary, false) then
    update public.venue_images
    set is_primary = false
    where venue_id = v_venue_id
      and id <> p_image_id;
  end if;

  update public.venue_images
  set
    image_url = trim(p_image_url),
    alt_text = nullif(trim(p_alt_text), ''),
    sort_order = coalesce(p_sort_order, 0),
    is_primary = coalesce(p_is_primary, false)
  where id = p_image_id;

  if not exists (
    select 1
    from public.venue_images vi
    where vi.venue_id = v_venue_id
      and vi.is_primary = true
  ) then
    select vi.id
    into v_remaining_primary_id
    from public.venue_images vi
    where vi.venue_id = v_venue_id
    order by vi.sort_order, vi.created_at
    limit 1;

    update public.venue_images
    set is_primary = true
    where id = v_remaining_primary_id;
  end if;

  return query
  select *
  from public.admin_venue_images(v_venue_id) images
  where images.image_id = p_image_id;
end;
$$;

create or replace function public.admin_delete_venue_image(p_image_id uuid)
returns table (
  deleted_image_id uuid,
  venue_id uuid
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue_id uuid;
  v_was_primary boolean;
  v_next_primary_id uuid;
begin
  perform public.require_admin();

  select vi.venue_id, vi.is_primary
  into v_venue_id, v_was_primary
  from public.venue_images vi
  where vi.id = p_image_id;

  if v_venue_id is null then
    raise exception 'Venue image not found';
  end if;

  delete from public.venue_images
  where id = p_image_id;

  if v_was_primary then
    select vi.id
    into v_next_primary_id
    from public.venue_images vi
    where vi.venue_id = v_venue_id
    order by vi.sort_order, vi.created_at
    limit 1;

    update public.venue_images
    set is_primary = true
    where id = v_next_primary_id;
  end if;

  return query
  select p_image_id, v_venue_id;
end;
$$;

create or replace function public.admin_court_images(p_court_id uuid)
returns table (
  image_id uuid,
  court_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.courts c where c.id = p_court_id) then
    raise exception 'Court not found';
  end if;

  return query
  select
    ci.id,
    ci.court_id,
    ci.image_url,
    ci.alt_text,
    ci.sort_order,
    ci.is_primary,
    ci.created_at
  from public.court_images ci
  where ci.court_id = p_court_id
  order by ci.is_primary desc, ci.sort_order, ci.created_at;
end;
$$;

create or replace function public.admin_create_court_image(
  p_court_id uuid,
  p_image_url text,
  p_alt_text text default null,
  p_sort_order integer default 0,
  p_is_primary boolean default false
)
returns table (
  image_id uuid,
  court_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_image_id uuid;
  v_is_primary boolean;
begin
  perform public.require_admin();

  if not exists (select 1 from public.courts c where c.id = p_court_id) then
    raise exception 'Court not found';
  end if;

  if nullif(trim(p_image_url), '') is null then
    raise exception 'Image URL is required';
  end if;

  v_is_primary := coalesce(p_is_primary, false)
    or not exists (select 1 from public.court_images ci where ci.court_id = p_court_id);

  if v_is_primary then
    update public.court_images
    set is_primary = false
    where court_id = p_court_id;
  end if;

  insert into public.court_images (
    court_id,
    image_url,
    alt_text,
    sort_order,
    is_primary
  )
  values (
    p_court_id,
    trim(p_image_url),
    nullif(trim(p_alt_text), ''),
    coalesce(p_sort_order, 0),
    v_is_primary
  )
  returning id into v_image_id;

  return query
  select *
  from public.admin_court_images(p_court_id) images
  where images.image_id = v_image_id;
end;
$$;

create or replace function public.admin_update_court_image(
  p_image_id uuid,
  p_image_url text,
  p_alt_text text default null,
  p_sort_order integer default 0,
  p_is_primary boolean default false
)
returns table (
  image_id uuid,
  court_id uuid,
  image_url text,
  alt_text text,
  sort_order integer,
  is_primary boolean,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_court_id uuid;
  v_remaining_primary_id uuid;
begin
  perform public.require_admin();

  select ci.court_id
  into v_court_id
  from public.court_images ci
  where ci.id = p_image_id;

  if v_court_id is null then
    raise exception 'Court image not found';
  end if;

  if nullif(trim(p_image_url), '') is null then
    raise exception 'Image URL is required';
  end if;

  if coalesce(p_is_primary, false) then
    update public.court_images
    set is_primary = false
    where court_id = v_court_id
      and id <> p_image_id;
  end if;

  update public.court_images
  set
    image_url = trim(p_image_url),
    alt_text = nullif(trim(p_alt_text), ''),
    sort_order = coalesce(p_sort_order, 0),
    is_primary = coalesce(p_is_primary, false)
  where id = p_image_id;

  if not exists (
    select 1
    from public.court_images ci
    where ci.court_id = v_court_id
      and ci.is_primary = true
  ) then
    select ci.id
    into v_remaining_primary_id
    from public.court_images ci
    where ci.court_id = v_court_id
    order by ci.sort_order, ci.created_at
    limit 1;

    update public.court_images
    set is_primary = true
    where id = v_remaining_primary_id;
  end if;

  return query
  select *
  from public.admin_court_images(v_court_id) images
  where images.image_id = p_image_id;
end;
$$;

create or replace function public.admin_delete_court_image(p_image_id uuid)
returns table (
  deleted_image_id uuid,
  court_id uuid
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_court_id uuid;
  v_was_primary boolean;
  v_next_primary_id uuid;
begin
  perform public.require_admin();

  select ci.court_id, ci.is_primary
  into v_court_id, v_was_primary
  from public.court_images ci
  where ci.id = p_image_id;

  if v_court_id is null then
    raise exception 'Court image not found';
  end if;

  delete from public.court_images
  where id = p_image_id;

  if v_was_primary then
    select ci.id
    into v_next_primary_id
    from public.court_images ci
    where ci.court_id = v_court_id
    order by ci.sort_order, ci.created_at
    limit 1;

    update public.court_images
    set is_primary = true
    where id = v_next_primary_id;
  end if;

  return query
  select p_image_id, v_court_id;
end;
$$;

grant execute on function public.admin_venue_images(uuid) to authenticated;
grant execute on function public.admin_create_venue_image(uuid, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_update_venue_image(uuid, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_delete_venue_image(uuid) to authenticated;
grant execute on function public.admin_court_images(uuid) to authenticated;
grant execute on function public.admin_create_court_image(uuid, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_update_court_image(uuid, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_delete_court_image(uuid) to authenticated;
