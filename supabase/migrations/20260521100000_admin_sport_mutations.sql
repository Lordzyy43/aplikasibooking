create or replace function public.admin_create_sport(
  p_name text,
  p_slug text default null,
  p_icon_url text default null,
  p_is_active boolean default true
)
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
as $$
declare
  v_base_slug text;
  v_slug text;
  v_suffix integer := 1;
  v_sport_id uuid;
begin
  perform public.require_admin();

  if nullif(trim(p_name), '') is null then
    raise exception 'Sport name is required';
  end if;

  v_base_slug := coalesce(nullif(public.slugify(p_slug), ''), nullif(public.slugify(p_name), ''), 'sport');
  v_slug := v_base_slug;

  while exists (select 1 from public.sports s where s.slug = v_slug) loop
    v_suffix := v_suffix + 1;
    v_slug := concat(v_base_slug, '-', v_suffix);
  end loop;

  insert into public.sports (
    name,
    slug,
    icon_url,
    is_active
  )
  values (
    trim(p_name),
    v_slug,
    nullif(trim(p_icon_url), ''),
    coalesce(p_is_active, true)
  )
  returning id into v_sport_id;

  return query
  select s.id, s.name, s.slug, s.icon_url, s.is_active
  from public.sports s
  where s.id = v_sport_id;
end;
$$;

create or replace function public.admin_update_sport(
  p_sport_id uuid,
  p_name text,
  p_slug text default null,
  p_icon_url text default null,
  p_is_active boolean default true
)
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
as $$
declare
  v_slug text;
begin
  perform public.require_admin();

  if not exists (select 1 from public.sports s where s.id = p_sport_id) then
    raise exception 'Sport not found';
  end if;

  if nullif(trim(p_name), '') is null then
    raise exception 'Sport name is required';
  end if;

  select s.slug
  into v_slug
  from public.sports s
  where s.id = p_sport_id;

  if nullif(trim(coalesce(p_slug, '')), '') is not null then
    v_slug := public.slugify(p_slug);

    if v_slug = '' then
      raise exception 'Sport slug is invalid';
    end if;

    if exists (
      select 1
      from public.sports s
      where s.slug = v_slug
        and s.id <> p_sport_id
    ) then
      raise exception 'Sport slug already exists';
    end if;
  end if;

  update public.sports
  set
    name = trim(p_name),
    slug = v_slug,
    icon_url = nullif(trim(p_icon_url), ''),
    is_active = coalesce(p_is_active, true)
  where id = p_sport_id;

  return query
  select s.id, s.name, s.slug, s.icon_url, s.is_active
  from public.sports s
  where s.id = p_sport_id;
end;
$$;

grant execute on function public.admin_create_sport(text, text, text, boolean) to authenticated;
grant execute on function public.admin_update_sport(uuid, text, text, text, boolean) to authenticated;
