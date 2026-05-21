create or replace function public.require_admin()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;
end;
$$;

create or replace function public.admin_dashboard_summary()
returns table (
  users_count bigint,
  venues_count bigint,
  courts_count bigint,
  bookings_count bigint,
  pending_payments_count bigint,
  paid_revenue_total bigint,
  reviews_count bigint
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
    (select count(*) from public.users) as users_count,
    (select count(*) from public.venues) as venues_count,
    (select count(*) from public.courts) as courts_count,
    (select count(*) from public.bookings) as bookings_count,
    (select count(*) from public.payments p where p.status = 'pending') as pending_payments_count,
    (select coalesce(sum(p.amount), 0)::bigint from public.payments p where p.status = 'paid') as paid_revenue_total,
    (select count(*) from public.reviews) as reviews_count;
end;
$$;

create or replace function public.admin_users()
returns table (
  user_id uuid,
  email text,
  full_name text,
  phone text,
  role_name text,
  wallet_balance integer,
  points integer,
  created_at timestamptz,
  bookings_count bigint,
  total_spent bigint
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
    u.id,
    au.email::text,
    u.full_name,
    u.phone,
    r.name,
    u.wallet_balance,
    u.points,
    u.created_at,
    count(distinct b.id) as bookings_count,
    coalesce(sum(case when p.status = 'paid' then p.amount else 0 end), 0)::bigint as total_spent
  from public.users u
  join public.roles r on r.id = u.role_id
  left join auth.users au on au.id = u.id
  left join public.bookings b on b.user_id = u.id
  left join public.payments p on p.booking_id = b.id
  group by u.id, au.email, u.full_name, u.phone, r.name, u.wallet_balance, u.points, u.created_at
  order by u.created_at desc;
end;
$$;

create or replace function public.admin_venues()
returns table (
  venue_id uuid,
  name text,
  city text,
  address text,
  status text,
  owner_id uuid,
  owner_name text,
  owner_email text,
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
  perform public.require_admin();

  return query
  select
    v.id,
    v.name,
    v.city,
    v.address,
    v.status,
    v.owner_id,
    owner_user.full_name,
    owner_auth.email::text,
    count(distinct c.id) as courts_count,
    count(distinct b.id) as bookings_count,
    coalesce(sum(case when p.status = 'paid' then p.amount else 0 end), 0)::bigint as revenue_total
  from public.venues v
  left join public.users owner_user on owner_user.id = v.owner_id
  left join auth.users owner_auth on owner_auth.id = v.owner_id
  left join public.courts c on c.venue_id = v.id
  left join public.bookings b on b.court_id = c.id
  left join public.payments p on p.booking_id = b.id
  group by v.id, v.name, v.city, v.address, v.status, v.owner_id, owner_user.full_name, owner_auth.email
  order by v.name;
end;
$$;

create or replace function public.admin_courts()
returns table (
  court_id uuid,
  venue_id uuid,
  venue_name text,
  sport_name text,
  court_name text,
  status text,
  environment text,
  surface text,
  price_per_hour integer,
  average_rating numeric,
  review_count integer,
  bookings_count bigint
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
    c.id,
    v.id,
    v.name,
    s.name,
    c.name,
    c.status,
    c.environment,
    c.surface,
    c.price_per_hour,
    c.average_rating,
    c.review_count,
    count(distinct b.id) as bookings_count
  from public.courts c
  join public.venues v on v.id = c.venue_id
  join public.sports s on s.id = c.sport_id
  left join public.bookings b on b.court_id = c.id
  group by c.id, v.id, v.name, s.name, c.name, c.status, c.environment, c.surface, c.price_per_hour, c.average_rating, c.review_count
  order by v.name, c.name;
end;
$$;

create or replace function public.admin_bookings()
returns table (
  booking_id uuid,
  booking_code text,
  booking_date date,
  booking_status public.booking_status,
  subtotal integer,
  service_fee integer,
  discount_amount integer,
  total_price integer,
  expires_at timestamptz,
  created_at timestamptz,
  customer_id uuid,
  customer_name text,
  customer_email text,
  customer_phone text,
  venue_id uuid,
  venue_name text,
  court_id uuid,
  court_name text,
  slot_labels text,
  payment_status public.payment_status,
  payment_method public.payment_method,
  paid_at timestamptz
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
    b.id,
    b.booking_code,
    b.booking_date,
    b.status,
    b.subtotal,
    b.service_fee,
    b.discount_amount,
    b.total_price,
    b.expires_at,
    b.created_at,
    u.id,
    u.full_name,
    au.email::text,
    u.phone,
    v.id,
    v.name,
    c.id,
    c.name,
    string_agg(ts.label, ', ' order by ts.start_time) as slot_labels,
    p.status,
    p.method,
    p.paid_at
  from public.bookings b
  join public.users u on u.id = b.user_id
  left join auth.users au on au.id = u.id
  join public.courts c on c.id = b.court_id
  join public.venues v on v.id = c.venue_id
  left join public.payments p on p.booking_id = b.id
  left join public.booking_slots bs on bs.booking_id = b.id
  left join public.time_slots ts on ts.id = bs.time_slot_id
  group by
    b.id, b.booking_code, b.booking_date, b.status, b.subtotal, b.service_fee,
    b.discount_amount, b.total_price, b.expires_at, b.created_at, u.id,
    u.full_name, au.email, u.phone, v.id, v.name, c.id, c.name, p.status,
    p.method, p.paid_at
  order by b.created_at desc;
end;
$$;

create or replace function public.admin_payments()
returns table (
  payment_id uuid,
  booking_id uuid,
  booking_code text,
  method public.payment_method,
  payment_status public.payment_status,
  amount integer,
  provider_reference text,
  paid_at timestamptz,
  expired_at timestamptz,
  created_at timestamptz,
  customer_name text,
  customer_email text,
  venue_name text,
  court_name text
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
    p.id,
    b.id,
    b.booking_code,
    p.method,
    p.status,
    p.amount,
    p.provider_reference,
    p.paid_at,
    p.expired_at,
    p.created_at,
    u.full_name,
    au.email::text,
    v.name,
    c.name
  from public.payments p
  join public.bookings b on b.id = p.booking_id
  join public.users u on u.id = b.user_id
  left join auth.users au on au.id = u.id
  join public.courts c on c.id = b.court_id
  join public.venues v on v.id = c.venue_id
  order by p.created_at desc;
end;
$$;

create or replace function public.admin_reviews()
returns table (
  review_id uuid,
  booking_id uuid,
  booking_code text,
  court_id uuid,
  venue_name text,
  court_name text,
  customer_id uuid,
  customer_name text,
  customer_email text,
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
  perform public.require_admin();

  return query
  select
    r.id,
    r.booking_id,
    b.booking_code,
    r.court_id,
    v.name,
    c.name,
    u.id,
    u.full_name,
    au.email::text,
    r.rating,
    r.comment,
    r.created_at
  from public.reviews r
  join public.bookings b on b.id = r.booking_id
  join public.users u on u.id = r.user_id
  left join auth.users au on au.id = u.id
  join public.courts c on c.id = r.court_id
  join public.venues v on v.id = c.venue_id
  order by r.created_at desc;
end;
$$;

grant execute on function public.require_admin() to authenticated;
grant execute on function public.admin_dashboard_summary() to authenticated;
grant execute on function public.admin_users() to authenticated;
grant execute on function public.admin_venues() to authenticated;
grant execute on function public.admin_courts() to authenticated;
grant execute on function public.admin_bookings() to authenticated;
grant execute on function public.admin_payments() to authenticated;
grant execute on function public.admin_reviews() to authenticated;
