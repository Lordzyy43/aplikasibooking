create or replace function public.require_owner_or_admin()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not (public.is_owner() or public.is_admin()) then
    raise exception 'Owner or admin role required';
  end if;
end;
$$;

create or replace function public.owner_venues()
returns table (
  venue_id uuid,
  name text,
  city text,
  address text,
  status text,
  courts_count bigint,
  bookings_count bigint,
  revenue_total bigint
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_owner_or_admin();

  return query
  select
    v.id,
    v.name,
    v.city,
    v.address,
    v.status,
    count(distinct c.id) as courts_count,
    count(distinct b.id) as bookings_count,
    coalesce(sum(distinct case when p.status = 'paid' then p.amount else 0 end), 0)::bigint as revenue_total
  from public.venues v
  left join public.courts c on c.venue_id = v.id
  left join public.bookings b on b.court_id = c.id
  left join public.payments p on p.booking_id = b.id
  where public.is_admin() or v.owner_id = auth.uid()
  group by v.id, v.name, v.city, v.address, v.status
  order by v.name;
end;
$$;

create or replace function public.owner_courts()
returns table (
  court_id uuid,
  venue_id uuid,
  venue_name text,
  sport_name text,
  court_name text,
  status text,
  price_per_hour integer,
  average_rating numeric,
  review_count integer
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_owner_or_admin();

  return query
  select
    c.id,
    v.id,
    v.name,
    s.name,
    c.name,
    c.status,
    c.price_per_hour,
    c.average_rating,
    c.review_count
  from public.courts c
  join public.venues v on v.id = c.venue_id
  join public.sports s on s.id = c.sport_id
  where public.is_admin() or v.owner_id = auth.uid()
  order by v.name, c.name;
end;
$$;

create or replace function public.owner_bookings()
returns table (
  booking_id uuid,
  booking_code text,
  booking_date date,
  booking_status public.booking_status,
  total_price integer,
  customer_name text,
  customer_phone text,
  venue_name text,
  court_name text,
  slot_labels text
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_owner_or_admin();

  return query
  select
    b.id,
    b.booking_code,
    b.booking_date,
    b.status,
    b.total_price,
    u.full_name,
    u.phone,
    v.name,
    c.name,
    string_agg(ts.label, ', ' order by ts.start_time) as slot_labels
  from public.bookings b
  join public.users u on u.id = b.user_id
  join public.courts c on c.id = b.court_id
  join public.venues v on v.id = c.venue_id
  left join public.booking_slots bs on bs.booking_id = b.id
  left join public.time_slots ts on ts.id = bs.time_slot_id
  where public.is_admin() or v.owner_id = auth.uid()
  group by b.id, b.booking_code, b.booking_date, b.status, b.total_price, u.full_name, u.phone, v.name, c.name
  order by b.booking_date desc, b.created_at desc;
end;
$$;

create or replace function public.owner_payments()
returns table (
  payment_id uuid,
  booking_id uuid,
  booking_code text,
  method public.payment_method,
  payment_status public.payment_status,
  amount integer,
  paid_at timestamptz,
  expired_at timestamptz,
  venue_name text,
  court_name text,
  customer_name text
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_owner_or_admin();

  return query
  select
    p.id,
    b.id,
    b.booking_code,
    p.method,
    p.status,
    p.amount,
    p.paid_at,
    p.expired_at,
    v.name,
    c.name,
    u.full_name
  from public.payments p
  join public.bookings b on b.id = p.booking_id
  join public.users u on u.id = b.user_id
  join public.courts c on c.id = b.court_id
  join public.venues v on v.id = c.venue_id
  where public.is_admin() or v.owner_id = auth.uid()
  order by p.created_at desc;
end;
$$;

create or replace function public.owner_reviews()
returns table (
  review_id uuid,
  booking_id uuid,
  court_id uuid,
  venue_name text,
  court_name text,
  customer_name text,
  rating integer,
  comment text,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  perform public.require_owner_or_admin();

  return query
  select
    r.id,
    r.booking_id,
    r.court_id,
    v.name,
    c.name,
    u.full_name,
    r.rating,
    r.comment,
    r.created_at
  from public.reviews r
  join public.users u on u.id = r.user_id
  join public.courts c on c.id = r.court_id
  join public.venues v on v.id = c.venue_id
  where public.is_admin() or v.owner_id = auth.uid()
  order by r.created_at desc;
end;
$$;

grant execute on function public.owner_venues() to authenticated;
grant execute on function public.owner_courts() to authenticated;
grant execute on function public.owner_bookings() to authenticated;
grant execute on function public.owner_payments() to authenticated;
grant execute on function public.owner_reviews() to authenticated;
