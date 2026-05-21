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
    update public.venue_images vi
    set is_primary = false
    where vi.venue_id = v_venue_id
      and vi.id <> p_image_id;
  end if;

  update public.venue_images vi
  set
    image_url = trim(p_image_url),
    alt_text = nullif(trim(p_alt_text), ''),
    sort_order = coalesce(p_sort_order, 0),
    is_primary = coalesce(p_is_primary, false)
  where vi.id = p_image_id;

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

    update public.venue_images vi
    set is_primary = true
    where vi.id = v_remaining_primary_id;
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

  delete from public.venue_images vi
  where vi.id = p_image_id;

  if v_was_primary then
    select vi.id
    into v_next_primary_id
    from public.venue_images vi
    where vi.venue_id = v_venue_id
    order by vi.sort_order, vi.created_at
    limit 1;

    update public.venue_images vi
    set is_primary = true
    where vi.id = v_next_primary_id;
  end if;

  return query
  select p_image_id, v_venue_id;
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
    update public.court_images ci
    set is_primary = false
    where ci.court_id = v_court_id
      and ci.id <> p_image_id;
  end if;

  update public.court_images ci
  set
    image_url = trim(p_image_url),
    alt_text = nullif(trim(p_alt_text), ''),
    sort_order = coalesce(p_sort_order, 0),
    is_primary = coalesce(p_is_primary, false)
  where ci.id = p_image_id;

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

    update public.court_images ci
    set is_primary = true
    where ci.id = v_remaining_primary_id;
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

  delete from public.court_images ci
  where ci.id = p_image_id;

  if v_was_primary then
    select ci.id
    into v_next_primary_id
    from public.court_images ci
    where ci.court_id = v_court_id
    order by ci.sort_order, ci.created_at
    limit 1;

    update public.court_images ci
    set is_primary = true
    where ci.id = v_next_primary_id;
  end if;

  return query
  select p_image_id, v_court_id;
end;
$$;
