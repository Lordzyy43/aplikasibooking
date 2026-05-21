create or replace function public.create_booking(
  p_court_id uuid,
  p_booking_date date,
  p_time_slot_ids uuid[]
)
returns table (
  booking_id uuid,
  booking_code text,
  total_price integer
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_court_price integer;
  v_slot_count integer;
  v_subtotal integer;
  v_service_fee integer := 2500;
  v_booking_id uuid;
  v_booking_code text;
begin
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Authentication required';
  end if;

  if p_booking_date < current_date then
    raise exception 'Booking date cannot be in the past';
  end if;

  select price_per_hour
  into v_court_price
  from public.courts
  where id = p_court_id
    and status = 'active';

  if v_court_price is null then
    raise exception 'Court is not available';
  end if;

  select count(distinct requested.requested_slot_id)
  into v_slot_count
  from unnest(p_time_slot_ids) as requested(requested_slot_id)
  join public.get_court_availability(p_court_id, p_booking_date) availability
    on availability.slot_id = requested.requested_slot_id
   and availability.is_available = true;

  if v_slot_count = 0 or v_slot_count <> cardinality(p_time_slot_ids) then
    raise exception 'One or more selected slots are not available';
  end if;

  v_subtotal := v_court_price * v_slot_count;
  v_booking_code := public.create_booking_code();

  insert into public.bookings (
    booking_code,
    user_id,
    court_id,
    booking_date,
    status,
    subtotal,
    service_fee,
    discount_amount,
    total_price,
    expires_at
  )
  values (
    v_booking_code,
    v_user_id,
    p_court_id,
    p_booking_date,
    'pending_payment',
    v_subtotal,
    v_service_fee,
    0,
    v_subtotal + v_service_fee,
    now() + interval '15 minutes'
  )
  returning id into v_booking_id;

  insert into public.booking_slots (
    booking_id,
    court_id,
    booking_date,
    time_slot_id
  )
  select
    v_booking_id,
    p_court_id,
    p_booking_date,
    distinct_slots.requested_slot_id
  from (
    select distinct requested_slot_id
    from unnest(p_time_slot_ids) as requested(requested_slot_id)
  ) distinct_slots;

  return query
  select v_booking_id, v_booking_code, v_subtotal + v_service_fee;
end;
$$;
