create table if not exists public.venue_operating_hours (
  venue_id uuid not null references public.venues(id) on delete cascade,
  day_of_week integer not null check (day_of_week between 0 and 6),
  open_time time,
  close_time time,
  is_closed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (venue_id, day_of_week),
  check (
    (is_closed = true and open_time is null and close_time is null)
    or
    (is_closed = false and open_time is not null and close_time is not null and open_time < close_time)
  )
);

create trigger set_venue_operating_hours_updated_at
before update on public.venue_operating_hours
for each row execute function public.set_updated_at();

alter table public.venue_operating_hours enable row level security;

create policy "venue_operating_hours_public_select"
on public.venue_operating_hours for select
using (
  exists (
    select 1
    from public.venues v
    where v.id = venue_operating_hours.venue_id
      and v.status = 'open'
  )
);

create policy "venue_operating_hours_owner_select"
on public.venue_operating_hours for select
using (public.owns_venue(venue_id));

create policy "venue_operating_hours_admin_all"
on public.venue_operating_hours for all
using (public.is_admin())
with check (public.is_admin());

create or replace function public.day_label(p_day_of_week integer)
returns text
language sql
immutable
as $$
  select case p_day_of_week
    when 0 then 'Sunday'
    when 1 then 'Monday'
    when 2 then 'Tuesday'
    when 3 then 'Wednesday'
    when 4 then 'Thursday'
    when 5 then 'Friday'
    when 6 then 'Saturday'
    else 'Unknown'
  end;
$$;

create or replace function public.admin_venue_operating_hours(p_venue_id uuid)
returns table (
  venue_id uuid,
  day_of_week integer,
  day_label text,
  open_time time,
  close_time time,
  is_closed boolean
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
    p_venue_id,
    days.day_of_week,
    public.day_label(days.day_of_week),
    coalesce(voh.open_time, '08:00'::time) as open_time,
    coalesce(voh.close_time, '23:00'::time) as close_time,
    coalesce(voh.is_closed, false) as is_closed
  from generate_series(0, 6) as days(day_of_week)
  left join public.venue_operating_hours voh
    on voh.venue_id = p_venue_id
   and voh.day_of_week = days.day_of_week
  order by days.day_of_week;
end;
$$;

create or replace function public.admin_set_venue_operating_hours(
  p_venue_id uuid,
  p_hours jsonb
)
returns table (
  venue_id uuid,
  day_of_week integer,
  day_label text,
  open_time time,
  close_time time,
  is_closed boolean
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_item jsonb;
  v_day integer;
  v_open_time time;
  v_close_time time;
  v_is_closed boolean;
begin
  perform public.require_admin();

  if not exists (select 1 from public.venues v where v.id = p_venue_id) then
    raise exception 'Venue not found';
  end if;

  if jsonb_typeof(p_hours) <> 'array' then
    raise exception 'Operating hours payload must be an array';
  end if;

  for v_item in select value from jsonb_array_elements(p_hours) loop
    v_day := (v_item->>'day_of_week')::integer;
    v_is_closed := coalesce((v_item->>'is_closed')::boolean, false);

    if v_day is null or v_day < 0 or v_day > 6 then
      raise exception 'Invalid day_of_week';
    end if;

    if v_is_closed then
      v_open_time := null;
      v_close_time := null;
    else
      v_open_time := nullif(v_item->>'open_time', '')::time;
      v_close_time := nullif(v_item->>'close_time', '')::time;

      if v_open_time is null or v_close_time is null or v_open_time >= v_close_time then
        raise exception 'Invalid operating hours for day %', v_day;
      end if;
    end if;

    insert into public.venue_operating_hours (
      venue_id,
      day_of_week,
      open_time,
      close_time,
      is_closed
    )
    values (
      p_venue_id,
      v_day,
      v_open_time,
      v_close_time,
      v_is_closed
    )
    on conflict (venue_id, day_of_week) do update
    set
      open_time = excluded.open_time,
      close_time = excluded.close_time,
      is_closed = excluded.is_closed,
      updated_at = now();
  end loop;

  return query
  select *
  from public.admin_venue_operating_hours(p_venue_id);
end;
$$;

create or replace function public.get_court_availability(
  p_court_id uuid,
  p_booking_date date
)
returns table (
  slot_id uuid,
  label text,
  start_time time,
  end_time time,
  is_available boolean,
  reason text
)
language sql
security definer
set search_path = public
stable
as $$
  select
    ts.id as slot_id,
    ts.label,
    ts.start_time,
    ts.end_time,
    case
      when cm.id is not null then false
      when voh.venue_id is not null and (
        voh.is_closed = true
        or ts.start_time < voh.open_time
        or ts.end_time > voh.close_time
      ) then false
      when bs.time_slot_id is not null then false
      when p_booking_date = current_date and ts.start_time <= current_time then false
      else true
    end as is_available,
    case
      when cm.id is not null then 'maintenance'
      when voh.venue_id is not null and (
        voh.is_closed = true
        or ts.start_time < voh.open_time
        or ts.end_time > voh.close_time
      ) then 'outside_operating_hours'
      when bs.time_slot_id is not null then 'booked'
      when p_booking_date = current_date and ts.start_time <= current_time then 'past_time'
      else null
    end as reason
  from public.court_available_slots cas
  join public.courts c on c.id = cas.court_id
  join public.time_slots ts on ts.id = cas.time_slot_id
  left join public.venue_operating_hours voh
    on voh.venue_id = c.venue_id
   and voh.day_of_week = extract(dow from p_booking_date)::integer
  left join public.booking_slots bs
    on bs.court_id = cas.court_id
   and bs.booking_date = p_booking_date
   and bs.time_slot_id = ts.id
   and bs.is_active = true
   and exists (
     select 1
     from public.bookings b
     where b.id = bs.booking_id
       and b.status in ('pending_payment', 'confirmed')
   )
  left join public.court_maintenance cm
    on cm.court_id = cas.court_id
   and cm.maintenance_date = p_booking_date
   and (cm.time_slot_id = ts.id or cm.time_slot_id is null)
  where cas.court_id = p_court_id
    and ts.is_active = true
  order by ts.sort_order, ts.start_time;
$$;

grant execute on function public.day_label(integer) to authenticated, anon;
grant execute on function public.admin_venue_operating_hours(uuid) to authenticated;
grant execute on function public.admin_set_venue_operating_hours(uuid, jsonb) to authenticated;
