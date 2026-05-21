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
    on conflict on constraint venue_operating_hours_pkey do update
    set
      open_time = excluded.open_time,
      close_time = excluded.close_time,
      is_closed = excluded.is_closed,
      updated_at = now();
  end loop;

  return query
  select
    hours.venue_id,
    hours.day_of_week,
    hours.day_label,
    hours.open_time,
    hours.close_time,
    hours.is_closed
  from public.admin_venue_operating_hours(p_venue_id) hours;
end;
$$;
