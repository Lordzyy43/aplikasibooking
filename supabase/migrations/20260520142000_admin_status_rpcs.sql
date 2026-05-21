create or replace function public.notify_booking_status_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op <> 'UPDATE' or new.status is not distinct from old.status then
    return new;
  end if;

  insert into public.notifications (user_id, type, title, body)
  values (
    new.user_id,
    case
      when new.status = 'pending_payment' then 'payment'::public.notification_type
      else 'booking'::public.notification_type
    end,
    case new.status
      when 'confirmed' then 'Booking dikonfirmasi'
      when 'finished' then 'Booking selesai'
      when 'cancelled' then 'Booking dibatalkan'
      when 'expired' then 'Booking kadaluarsa'
      else 'Status booking diperbarui'
    end,
    case new.status
      when 'confirmed' then concat(new.booking_code, ' sudah aktif. Tunjukkan e-ticket saat tiba di venue.')
      when 'finished' then concat(new.booking_code, ' sudah selesai. Kamu sekarang bisa memberi ulasan.')
      when 'cancelled' then concat(new.booking_code, ' dibatalkan. Hubungi admin venue jika perlu bantuan.')
      when 'expired' then concat(new.booking_code, ' kadaluarsa karena pembayaran tidak selesai tepat waktu.')
      else concat(new.booking_code, ' statusnya diperbarui.')
    end
  );

  return new;
end;
$$;

drop trigger if exists bookings_notify_status_change on public.bookings;
create trigger bookings_notify_status_change
after update of status on public.bookings
for each row execute function public.notify_booking_status_change();

create or replace function public.admin_confirm_payment(p_payment_id uuid)
returns table (
  payment_id uuid,
  booking_id uuid,
  payment_status public.payment_status,
  booking_status public.booking_status
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_booking_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;

  update public.payments
  set
    status = 'paid',
    paid_at = coalesce(paid_at, now()),
    updated_at = now()
  where id = p_payment_id
    and status = 'pending'
  returning payments.booking_id into v_booking_id;

  if v_booking_id is null then
    raise exception 'Pending payment not found';
  end if;

  update public.bookings
  set
    status = 'confirmed',
    updated_at = now()
  where id = v_booking_id
    and status = 'pending_payment';

  return query
  select p.id, b.id, p.status, b.status
  from public.payments p
  join public.bookings b on b.id = p.booking_id
  where p.id = p_payment_id;
end;
$$;

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
  select id, booking_code, status
  from public.bookings
  where id = p_booking_id;
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
  select id, booking_code, status
  from public.bookings
  where id = p_booking_id;
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
      user_id,
      'booking',
      'Alasan pembatalan',
      p_reason
    from public.bookings
    where id = p_booking_id;
  end if;

  return query
  select id, booking_code, status
  from public.bookings
  where id = p_booking_id;
end;
$$;

grant execute on function public.admin_confirm_payment(uuid) to authenticated;
grant execute on function public.admin_confirm_booking(uuid) to authenticated;
grant execute on function public.admin_finish_booking(uuid) to authenticated;
grant execute on function public.admin_cancel_booking(uuid, text) to authenticated;
