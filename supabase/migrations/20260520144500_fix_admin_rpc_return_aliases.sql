create or replace function public.admin_confirm_booking(p_booking_id uuid)
returns table (
  booking_id uuid,
  booking_code text,
  booking_status public.booking_status
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;

  update public.bookings
  set
    status = 'confirmed',
    updated_at = now()
  where id = p_booking_id
    and status in ('pending_payment', 'confirmed');

  if not found then
    raise exception 'Booking cannot be confirmed';
  end if;

  return query
  select b.id, b.booking_code, b.status
  from public.bookings b
  where b.id = p_booking_id;
end;
$$;

create or replace function public.admin_finish_booking(p_booking_id uuid)
returns table (
  booking_id uuid,
  booking_code text,
  booking_status public.booking_status
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;

  update public.bookings
  set
    status = 'finished',
    updated_at = now()
  where id = p_booking_id
    and status = 'confirmed';

  if not found then
    raise exception 'Only confirmed bookings can be finished';
  end if;

  return query
  select b.id, b.booking_code, b.status
  from public.bookings b
  where b.id = p_booking_id;
end;
$$;

create or replace function public.admin_cancel_booking(
  p_booking_id uuid,
  p_reason text default null
)
returns table (
  booking_id uuid,
  booking_code text,
  booking_status public.booking_status
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;

  update public.bookings
  set
    status = 'cancelled',
    updated_at = now()
  where id = p_booking_id
    and status in ('pending_payment', 'confirmed');

  if not found then
    raise exception 'Booking cannot be cancelled';
  end if;

  update public.payments
  set
    status = 'cancelled',
    updated_at = now()
  where booking_id = p_booking_id
    and status = 'pending';

  if nullif(trim(p_reason), '') is not null then
    insert into public.notifications (user_id, type, title, body)
    select
      b.user_id,
      'booking',
      'Alasan pembatalan',
      p_reason
    from public.bookings b
    where b.id = p_booking_id;
  end if;

  return query
  select b.id, b.booking_code, b.status
  from public.bookings b
  where b.id = p_booking_id;
end;
$$;
