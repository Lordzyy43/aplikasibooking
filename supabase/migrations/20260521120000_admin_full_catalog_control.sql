create table if not exists public.venue_rules (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues(id) on delete cascade,
  icon_name text,
  title text not null,
  description text not null,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.home_banners (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subtitle text,
  tag text,
  cta_label text,
  image_url text,
  accent_color text,
  sport_slug text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.promos (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text,
  discount_type text not null default 'percentage' check (discount_type in ('percentage', 'fixed')),
  discount_value integer not null check (discount_value >= 0),
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_venue_rules_updated_at on public.venue_rules;
create trigger set_venue_rules_updated_at
before update on public.venue_rules
for each row execute function public.set_updated_at();

drop trigger if exists set_home_banners_updated_at on public.home_banners;
create trigger set_home_banners_updated_at
before update on public.home_banners
for each row execute function public.set_updated_at();

drop trigger if exists set_promos_updated_at on public.promos;
create trigger set_promos_updated_at
before update on public.promos
for each row execute function public.set_updated_at();

alter table public.venue_rules enable row level security;
alter table public.home_banners enable row level security;
alter table public.promos enable row level security;

drop policy if exists "venue_rules_public_select" on public.venue_rules;
create policy "venue_rules_public_select"
on public.venue_rules for select
using (
  is_active = true
  and exists (
    select 1
    from public.venues v
    where v.id = venue_rules.venue_id
      and v.status = 'open'
  )
);

drop policy if exists "venue_rules_owner_select" on public.venue_rules;
create policy "venue_rules_owner_select"
on public.venue_rules for select
using (public.owns_venue(venue_id));

drop policy if exists "venue_rules_admin_all" on public.venue_rules;
create policy "venue_rules_admin_all"
on public.venue_rules for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "home_banners_public_select" on public.home_banners;
create policy "home_banners_public_select"
on public.home_banners for select
using (is_active = true);

drop policy if exists "home_banners_admin_all" on public.home_banners;
create policy "home_banners_admin_all"
on public.home_banners for all
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "promos_public_select" on public.promos;
create policy "promos_public_select"
on public.promos for select
using (
  is_active = true
  and (starts_at is null or starts_at <= now())
  and (ends_at is null or ends_at >= now())
);

drop policy if exists "promos_admin_all" on public.promos;
create policy "promos_admin_all"
on public.promos for all
using (public.is_admin())
with check (public.is_admin());

create or replace function public.admin_time_slots()
returns table (
  time_slot_id uuid,
  label text,
  start_time time,
  end_time time,
  sort_order integer,
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
  select ts.id, ts.label, ts.start_time, ts.end_time, ts.sort_order, ts.is_active
  from public.time_slots ts
  order by ts.sort_order, ts.start_time;
end;
$$;

create or replace function public.admin_create_time_slot(
  p_label text,
  p_start_time time,
  p_end_time time,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  time_slot_id uuid,
  label text,
  start_time time,
  end_time time,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_time_slot_id uuid;
begin
  perform public.require_admin();

  if nullif(trim(p_label), '') is null then
    raise exception 'Time slot label is required';
  end if;

  if p_start_time is null or p_end_time is null or p_start_time >= p_end_time then
    raise exception 'Invalid time range';
  end if;

  insert into public.time_slots (label, start_time, end_time, sort_order, is_active)
  values (trim(p_label), p_start_time, p_end_time, coalesce(p_sort_order, 0), coalesce(p_is_active, true))
  returning id into v_time_slot_id;

  return query
  select ts.id, ts.label, ts.start_time, ts.end_time, ts.sort_order, ts.is_active
  from public.time_slots ts
  where ts.id = v_time_slot_id;
end;
$$;

create or replace function public.admin_update_time_slot(
  p_time_slot_id uuid,
  p_label text,
  p_start_time time,
  p_end_time time,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  time_slot_id uuid,
  label text,
  start_time time,
  end_time time,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.time_slots ts where ts.id = p_time_slot_id) then
    raise exception 'Time slot not found';
  end if;

  if nullif(trim(p_label), '') is null then
    raise exception 'Time slot label is required';
  end if;

  if p_start_time is null or p_end_time is null or p_start_time >= p_end_time then
    raise exception 'Invalid time range';
  end if;

  update public.time_slots ts
  set
    label = trim(p_label),
    start_time = p_start_time,
    end_time = p_end_time,
    sort_order = coalesce(p_sort_order, 0),
    is_active = coalesce(p_is_active, true)
  where ts.id = p_time_slot_id;

  return query
  select ts.id, ts.label, ts.start_time, ts.end_time, ts.sort_order, ts.is_active
  from public.time_slots ts
  where ts.id = p_time_slot_id;
end;
$$;

create or replace function public.admin_court_available_slots(p_court_id uuid)
returns table (
  time_slot_id uuid,
  label text,
  start_time time,
  end_time time,
  sort_order integer,
  is_active boolean,
  is_assigned boolean
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
    ts.id,
    ts.label,
    ts.start_time,
    ts.end_time,
    ts.sort_order,
    ts.is_active,
    cas.time_slot_id is not null as is_assigned
  from public.time_slots ts
  left join public.court_available_slots cas
    on cas.time_slot_id = ts.id
   and cas.court_id = p_court_id
  order by ts.sort_order, ts.start_time;
end;
$$;

create or replace function public.admin_set_court_available_slots(
  p_court_id uuid,
  p_time_slot_ids uuid[]
)
returns table (
  time_slot_id uuid,
  label text,
  start_time time,
  end_time time,
  sort_order integer,
  is_active boolean,
  is_assigned boolean
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.courts c where c.id = p_court_id) then
    raise exception 'Court not found';
  end if;

  delete from public.court_available_slots cas
  where cas.court_id = p_court_id;

  insert into public.court_available_slots (court_id, time_slot_id)
  select p_court_id, distinct_slots.time_slot_id
  from (
    select distinct unnest(coalesce(p_time_slot_ids, array[]::uuid[])) as time_slot_id
  ) distinct_slots
  join public.time_slots ts on ts.id = distinct_slots.time_slot_id;

  return query
  select *
  from public.admin_court_available_slots(p_court_id);
end;
$$;

create or replace function public.admin_court_maintenance(p_court_id uuid default null)
returns table (
  maintenance_id uuid,
  court_id uuid,
  court_name text,
  venue_name text,
  maintenance_date date,
  time_slot_id uuid,
  slot_label text,
  note text,
  created_at timestamptz
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
    cm.id,
    cm.court_id,
    c.name,
    v.name,
    cm.maintenance_date,
    cm.time_slot_id,
    ts.label,
    cm.note,
    cm.created_at
  from public.court_maintenance cm
  join public.courts c on c.id = cm.court_id
  join public.venues v on v.id = c.venue_id
  left join public.time_slots ts on ts.id = cm.time_slot_id
  where p_court_id is null or cm.court_id = p_court_id
  order by cm.maintenance_date desc, v.name, c.name, ts.sort_order;
end;
$$;

create or replace function public.admin_create_court_maintenance(
  p_court_id uuid,
  p_maintenance_date date,
  p_time_slot_id uuid default null,
  p_note text default null
)
returns table (
  maintenance_id uuid,
  court_id uuid,
  court_name text,
  venue_name text,
  maintenance_date date,
  time_slot_id uuid,
  slot_label text,
  note text,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_maintenance_id uuid;
begin
  perform public.require_admin();

  if not exists (select 1 from public.courts c where c.id = p_court_id) then
    raise exception 'Court not found';
  end if;

  if p_maintenance_date is null then
    raise exception 'Maintenance date is required';
  end if;

  if p_time_slot_id is not null and not exists (select 1 from public.time_slots ts where ts.id = p_time_slot_id) then
    raise exception 'Time slot not found';
  end if;

  insert into public.court_maintenance (court_id, maintenance_date, time_slot_id, note)
  values (p_court_id, p_maintenance_date, p_time_slot_id, nullif(trim(p_note), ''))
  returning id into v_maintenance_id;

  return query
  select *
  from public.admin_court_maintenance(p_court_id) rows
  where rows.maintenance_id = v_maintenance_id;
end;
$$;

create or replace function public.admin_delete_court_maintenance(p_maintenance_id uuid)
returns table (
  deleted_maintenance_id uuid
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.court_maintenance cm where cm.id = p_maintenance_id) then
    raise exception 'Maintenance not found';
  end if;

  delete from public.court_maintenance cm
  where cm.id = p_maintenance_id;

  return query select p_maintenance_id;
end;
$$;

create or replace function public.admin_amenities()
returns table (
  amenity_id uuid,
  name text,
  icon_name text,
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
  select a.id, a.name, a.icon_name, count(va.venue_id) as venues_count
  from public.amenities a
  left join public.venue_amenities va on va.amenity_id = a.id
  group by a.id, a.name, a.icon_name
  order by a.name;
end;
$$;

create or replace function public.admin_create_amenity(
  p_name text,
  p_icon_name text default null
)
returns table (
  amenity_id uuid,
  name text,
  icon_name text,
  venues_count bigint
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_amenity_id uuid;
begin
  perform public.require_admin();

  if nullif(trim(p_name), '') is null then
    raise exception 'Amenity name is required';
  end if;

  insert into public.amenities (name, icon_name)
  values (trim(p_name), nullif(trim(p_icon_name), ''))
  returning id into v_amenity_id;

  return query
  select *
  from public.admin_amenities() rows
  where rows.amenity_id = v_amenity_id;
end;
$$;

create or replace function public.admin_update_amenity(
  p_amenity_id uuid,
  p_name text,
  p_icon_name text default null
)
returns table (
  amenity_id uuid,
  name text,
  icon_name text,
  venues_count bigint
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.amenities a where a.id = p_amenity_id) then
    raise exception 'Amenity not found';
  end if;

  if nullif(trim(p_name), '') is null then
    raise exception 'Amenity name is required';
  end if;

  update public.amenities a
  set name = trim(p_name), icon_name = nullif(trim(p_icon_name), '')
  where a.id = p_amenity_id;

  return query
  select *
  from public.admin_amenities() rows
  where rows.amenity_id = p_amenity_id;
end;
$$;

create or replace function public.admin_venue_amenities(p_venue_id uuid)
returns table (
  amenity_id uuid,
  name text,
  icon_name text,
  is_assigned boolean
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
    a.id,
    a.name,
    a.icon_name,
    va.venue_id is not null as is_assigned
  from public.amenities a
  left join public.venue_amenities va
    on va.amenity_id = a.id
   and va.venue_id = p_venue_id
  order by a.name;
end;
$$;

create or replace function public.admin_set_venue_amenities(
  p_venue_id uuid,
  p_amenity_ids uuid[]
)
returns table (
  amenity_id uuid,
  name text,
  icon_name text,
  is_assigned boolean
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues v where v.id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  delete from public.venue_amenities va
  where va.venue_id = p_venue_id;

  insert into public.venue_amenities (venue_id, amenity_id)
  select p_venue_id, distinct_amenities.amenity_id
  from (
    select distinct unnest(coalesce(p_amenity_ids, array[]::uuid[])) as amenity_id
  ) distinct_amenities
  join public.amenities a on a.id = distinct_amenities.amenity_id;

  return query
  select *
  from public.admin_venue_amenities(p_venue_id);
end;
$$;

create or replace function public.admin_venue_rules(p_venue_id uuid)
returns table (
  rule_id uuid,
  venue_id uuid,
  icon_name text,
  title text,
  description text,
  sort_order integer,
  is_active boolean
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
  select vr.id, vr.venue_id, vr.icon_name, vr.title, vr.description, vr.sort_order, vr.is_active
  from public.venue_rules vr
  where vr.venue_id = p_venue_id
  order by vr.sort_order, vr.created_at;
end;
$$;

create or replace function public.admin_create_venue_rule(
  p_venue_id uuid,
  p_title text,
  p_description text,
  p_icon_name text default null,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  rule_id uuid,
  venue_id uuid,
  icon_name text,
  title text,
  description text,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_rule_id uuid;
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues v where v.id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if nullif(trim(p_title), '') is null or nullif(trim(p_description), '') is null then
    raise exception 'Rule title and description are required';
  end if;

  insert into public.venue_rules (venue_id, title, description, icon_name, sort_order, is_active)
  values (p_venue_id, trim(p_title), trim(p_description), nullif(trim(p_icon_name), ''), coalesce(p_sort_order, 0), coalesce(p_is_active, true))
  returning id into v_rule_id;

  return query
  select *
  from public.admin_venue_rules(p_venue_id) rows
  where rows.rule_id = v_rule_id;
end;
$$;

create or replace function public.admin_update_venue_rule(
  p_rule_id uuid,
  p_title text,
  p_description text,
  p_icon_name text default null,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  rule_id uuid,
  venue_id uuid,
  icon_name text,
  title text,
  description text,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue_id uuid;
begin
  perform public.require_admin();

  select vr.venue_id into v_venue_id from public.venue_rules vr where vr.id = p_rule_id;
  if v_venue_id is null then
    raise exception 'Venue rule not found';
  end if;

  if nullif(trim(p_title), '') is null or nullif(trim(p_description), '') is null then
    raise exception 'Rule title and description are required';
  end if;

  update public.venue_rules vr
  set
    title = trim(p_title),
    description = trim(p_description),
    icon_name = nullif(trim(p_icon_name), ''),
    sort_order = coalesce(p_sort_order, 0),
    is_active = coalesce(p_is_active, true)
  where vr.id = p_rule_id;

  return query
  select *
  from public.admin_venue_rules(v_venue_id) rows
  where rows.rule_id = p_rule_id;
end;
$$;

create or replace function public.admin_delete_venue_rule(p_rule_id uuid)
returns table (deleted_rule_id uuid)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();
  delete from public.venue_rules vr where vr.id = p_rule_id;
  if not found then raise exception 'Venue rule not found'; end if;
  return query select p_rule_id;
end;
$$;

create or replace function public.admin_promos()
returns table (
  promo_id uuid,
  code text,
  title text,
  description text,
  discount_type text,
  discount_value integer,
  starts_at timestamptz,
  ends_at timestamptz,
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
  select p.id, p.code, p.title, p.description, p.discount_type, p.discount_value, p.starts_at, p.ends_at, p.is_active
  from public.promos p
  order by p.created_at desc;
end;
$$;

create or replace function public.admin_create_promo(
  p_code text,
  p_title text,
  p_description text default null,
  p_discount_type text default 'percentage',
  p_discount_value integer default 0,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_is_active boolean default true
)
returns table (
  promo_id uuid,
  code text,
  title text,
  description text,
  discount_type text,
  discount_value integer,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare v_promo_id uuid;
begin
  perform public.require_admin();
  if nullif(trim(p_code), '') is null or nullif(trim(p_title), '') is null then raise exception 'Promo code and title are required'; end if;
  if p_discount_type not in ('percentage', 'fixed') then raise exception 'Invalid discount type'; end if;
  if p_discount_value < 0 then raise exception 'Discount value must be greater than or equal to zero'; end if;
  insert into public.promos (code, title, description, discount_type, discount_value, starts_at, ends_at, is_active)
  values (upper(trim(p_code)), trim(p_title), nullif(trim(p_description), ''), p_discount_type, p_discount_value, p_starts_at, p_ends_at, coalesce(p_is_active, true))
  returning id into v_promo_id;
  return query select * from public.admin_promos() rows where rows.promo_id = v_promo_id;
end;
$$;

create or replace function public.admin_update_promo(
  p_promo_id uuid,
  p_code text,
  p_title text,
  p_description text default null,
  p_discount_type text default 'percentage',
  p_discount_value integer default 0,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_is_active boolean default true
)
returns table (
  promo_id uuid,
  code text,
  title text,
  description text,
  discount_type text,
  discount_value integer,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();
  if not exists (select 1 from public.promos p where p.id = p_promo_id) then raise exception 'Promo not found'; end if;
  if nullif(trim(p_code), '') is null or nullif(trim(p_title), '') is null then raise exception 'Promo code and title are required'; end if;
  if p_discount_type not in ('percentage', 'fixed') then raise exception 'Invalid discount type'; end if;
  if p_discount_value < 0 then raise exception 'Discount value must be greater than or equal to zero'; end if;
  update public.promos p
  set code = upper(trim(p_code)), title = trim(p_title), description = nullif(trim(p_description), ''), discount_type = p_discount_type, discount_value = p_discount_value, starts_at = p_starts_at, ends_at = p_ends_at, is_active = coalesce(p_is_active, true)
  where p.id = p_promo_id;
  return query select * from public.admin_promos() rows where rows.promo_id = p_promo_id;
end;
$$;

create or replace function public.admin_delete_promo(p_promo_id uuid)
returns table (deleted_promo_id uuid)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();
  delete from public.promos p where p.id = p_promo_id;
  if not found then raise exception 'Promo not found'; end if;
  return query select p_promo_id;
end;
$$;

create or replace function public.admin_home_banners()
returns table (
  banner_id uuid,
  title text,
  subtitle text,
  tag text,
  cta_label text,
  image_url text,
  accent_color text,
  sport_slug text,
  sort_order integer,
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
  select hb.id, hb.title, hb.subtitle, hb.tag, hb.cta_label, hb.image_url, hb.accent_color, hb.sport_slug, hb.sort_order, hb.is_active
  from public.home_banners hb
  order by hb.sort_order, hb.created_at desc;
end;
$$;

create or replace function public.admin_create_home_banner(
  p_title text,
  p_subtitle text default null,
  p_tag text default null,
  p_cta_label text default null,
  p_image_url text default null,
  p_accent_color text default null,
  p_sport_slug text default null,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  banner_id uuid,
  title text,
  subtitle text,
  tag text,
  cta_label text,
  image_url text,
  accent_color text,
  sport_slug text,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare v_banner_id uuid;
begin
  perform public.require_admin();
  if nullif(trim(p_title), '') is null then raise exception 'Banner title is required'; end if;
  insert into public.home_banners (title, subtitle, tag, cta_label, image_url, accent_color, sport_slug, sort_order, is_active)
  values (trim(p_title), nullif(trim(p_subtitle), ''), nullif(trim(p_tag), ''), nullif(trim(p_cta_label), ''), nullif(trim(p_image_url), ''), nullif(trim(p_accent_color), ''), nullif(trim(p_sport_slug), ''), coalesce(p_sort_order, 0), coalesce(p_is_active, true))
  returning id into v_banner_id;
  return query select * from public.admin_home_banners() rows where rows.banner_id = v_banner_id;
end;
$$;

create or replace function public.admin_update_home_banner(
  p_banner_id uuid,
  p_title text,
  p_subtitle text default null,
  p_tag text default null,
  p_cta_label text default null,
  p_image_url text default null,
  p_accent_color text default null,
  p_sport_slug text default null,
  p_sort_order integer default 0,
  p_is_active boolean default true
)
returns table (
  banner_id uuid,
  title text,
  subtitle text,
  tag text,
  cta_label text,
  image_url text,
  accent_color text,
  sport_slug text,
  sort_order integer,
  is_active boolean
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();
  if not exists (select 1 from public.home_banners hb where hb.id = p_banner_id) then raise exception 'Banner not found'; end if;
  if nullif(trim(p_title), '') is null then raise exception 'Banner title is required'; end if;
  update public.home_banners hb
  set title = trim(p_title), subtitle = nullif(trim(p_subtitle), ''), tag = nullif(trim(p_tag), ''), cta_label = nullif(trim(p_cta_label), ''), image_url = nullif(trim(p_image_url), ''), accent_color = nullif(trim(p_accent_color), ''), sport_slug = nullif(trim(p_sport_slug), ''), sort_order = coalesce(p_sort_order, 0), is_active = coalesce(p_is_active, true)
  where hb.id = p_banner_id;
  return query select * from public.admin_home_banners() rows where rows.banner_id = p_banner_id;
end;
$$;

create or replace function public.admin_delete_home_banner(p_banner_id uuid)
returns table (deleted_banner_id uuid)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.require_admin();
  delete from public.home_banners hb where hb.id = p_banner_id;
  if not found then raise exception 'Banner not found'; end if;
  return query select p_banner_id;
end;
$$;

grant execute on function public.admin_time_slots() to authenticated;
grant execute on function public.admin_create_time_slot(text, time, time, integer, boolean) to authenticated;
grant execute on function public.admin_update_time_slot(uuid, text, time, time, integer, boolean) to authenticated;
grant execute on function public.admin_court_available_slots(uuid) to authenticated;
grant execute on function public.admin_set_court_available_slots(uuid, uuid[]) to authenticated;
grant execute on function public.admin_court_maintenance(uuid) to authenticated;
grant execute on function public.admin_create_court_maintenance(uuid, date, uuid, text) to authenticated;
grant execute on function public.admin_delete_court_maintenance(uuid) to authenticated;
grant execute on function public.admin_amenities() to authenticated;
grant execute on function public.admin_create_amenity(text, text) to authenticated;
grant execute on function public.admin_update_amenity(uuid, text, text) to authenticated;
grant execute on function public.admin_venue_amenities(uuid) to authenticated;
grant execute on function public.admin_set_venue_amenities(uuid, uuid[]) to authenticated;
grant execute on function public.admin_venue_rules(uuid) to authenticated;
grant execute on function public.admin_create_venue_rule(uuid, text, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_update_venue_rule(uuid, text, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_delete_venue_rule(uuid) to authenticated;
grant execute on function public.admin_promos() to authenticated;
grant execute on function public.admin_create_promo(text, text, text, text, integer, timestamptz, timestamptz, boolean) to authenticated;
grant execute on function public.admin_update_promo(uuid, text, text, text, text, integer, timestamptz, timestamptz, boolean) to authenticated;
grant execute on function public.admin_delete_promo(uuid) to authenticated;
grant execute on function public.admin_home_banners() to authenticated;
grant execute on function public.admin_create_home_banner(text, text, text, text, text, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_update_home_banner(uuid, text, text, text, text, text, text, text, integer, boolean) to authenticated;
grant execute on function public.admin_delete_home_banner(uuid) to authenticated;
