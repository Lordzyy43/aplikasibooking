-- Aerobook user-side schema.
-- Normalized enough to avoid repeated venue/court/slot data, while staying simple for Flutter.

create extension if not exists pgcrypto;

create type public.booking_status as enum (
  'pending_payment',
  'confirmed',
  'cancelled',
  'expired',
  'finished'
);

create type public.payment_status as enum (
  'pending',
  'paid',
  'failed',
  'expired',
  'cancelled'
);

create type public.payment_method as enum (
  'qris',
  'bank_transfer',
  'e_wallet',
  'cash'
);

create type public.notification_type as enum (
  'booking',
  'offer',
  'reminder',
  'payment'
);

create type public.app_role as enum (
  'customer',
  'owner',
  'admin'
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.protect_profile_system_fields()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() = old.id and (
    new.role is distinct from old.role
    or new.wallet_balance is distinct from old.wallet_balance
    or new.points is distinct from old.points
  ) then
    raise exception 'role, wallet_balance, and points cannot be updated by the user';
  end if;

  return new;
end;
$$;

create or replace function public.protect_user_booking_fields()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() = old.user_id and (
    new.id is distinct from old.id
    or new.booking_code is distinct from old.booking_code
    or new.user_id is distinct from old.user_id
    or new.court_id is distinct from old.court_id
    or new.booking_date is distinct from old.booking_date
    or new.subtotal is distinct from old.subtotal
    or new.service_fee is distinct from old.service_fee
    or new.discount_amount is distinct from old.discount_amount
    or new.total_price is distinct from old.total_price
    or new.expires_at is distinct from old.expires_at
    or new.created_at is distinct from old.created_at
  ) then
    raise exception 'Only booking status can be updated by the user';
  end if;

  return new;
end;
$$;

create or replace function public.sync_booking_slot_activity()
returns trigger
language plpgsql
as $$
begin
  if new.status in ('cancelled', 'expired') then
    update public.booking_slots
    set is_active = false
    where booking_id = new.id;
  elsif new.status in ('pending_payment', 'confirmed') then
    update public.booking_slots
    set is_active = true
    where booking_id = new.id;
  end if;

  return new;
end;
$$;

create or replace function public.protect_notification_fields()
returns trigger
language plpgsql
as $$
begin
  if auth.uid() = old.user_id and (
    new.id is distinct from old.id
    or new.user_id is distinct from old.user_id
    or new.type is distinct from old.type
    or new.title is distinct from old.title
    or new.body is distinct from old.body
    or new.created_at is distinct from old.created_at
  ) then
    raise exception 'Only notification read state can be updated by the user';
  end if;

  return new;
end;
$$;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role public.app_role not null default 'customer',
  full_name text not null,
  phone text,
  avatar_url text,
  wallet_balance integer not null default 0 check (wallet_balance >= 0),
  points integer not null default 0 check (points >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.sports (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  icon_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.venues (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles(id) on delete set null,
  name text not null,
  slug text not null unique,
  description text,
  address text not null,
  city text not null,
  latitude numeric(10, 7),
  longitude numeric(10, 7),
  status text not null default 'open' check (status in ('open', 'closed')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.venue_images (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues(id) on delete cascade,
  image_url text not null,
  alt_text text,
  sort_order integer not null default 0,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.amenities (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  icon_name text,
  created_at timestamptz not null default now()
);

create table public.venue_amenities (
  venue_id uuid not null references public.venues(id) on delete cascade,
  amenity_id uuid not null references public.amenities(id) on delete restrict,
  primary key (venue_id, amenity_id)
);

create table public.courts (
  id uuid primary key default gen_random_uuid(),
  venue_id uuid not null references public.venues(id) on delete cascade,
  sport_id uuid not null references public.sports(id) on delete restrict,
  name text not null,
  slug text,
  surface text,
  environment text not null default 'Indoor',
  price_per_hour integer not null check (price_per_hour >= 0),
  status text not null default 'active' check (status in ('active', 'inactive', 'maintenance')),
  average_rating numeric(3, 2) not null default 0 check (average_rating >= 0 and average_rating <= 5),
  review_count integer not null default 0 check (review_count >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (venue_id, slug)
);

create table public.court_images (
  id uuid primary key default gen_random_uuid(),
  court_id uuid not null references public.courts(id) on delete cascade,
  image_url text not null,
  alt_text text,
  sort_order integer not null default 0,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.time_slots (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  start_time time not null,
  end_time time not null,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  check (start_time < end_time),
  unique (start_time, end_time)
);

create table public.court_available_slots (
  court_id uuid not null references public.courts(id) on delete cascade,
  time_slot_id uuid not null references public.time_slots(id) on delete cascade,
  primary key (court_id, time_slot_id)
);

create table public.court_maintenance (
  id uuid primary key default gen_random_uuid(),
  court_id uuid not null references public.courts(id) on delete cascade,
  maintenance_date date not null,
  time_slot_id uuid references public.time_slots(id) on delete cascade,
  note text,
  created_at timestamptz not null default now()
);

create or replace function public.create_booking_code()
returns text
language sql
as $$
  select 'AB-' || to_char(now(), 'YYMMDD') || '-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 6));
$$;

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  booking_code text not null default public.create_booking_code() unique,
  user_id uuid not null references public.profiles(id) on delete cascade,
  court_id uuid not null references public.courts(id) on delete restrict,
  booking_date date not null,
  status public.booking_status not null default 'pending_payment',
  subtotal integer not null check (subtotal >= 0),
  service_fee integer not null default 0 check (service_fee >= 0),
  discount_amount integer not null default 0 check (discount_amount >= 0),
  total_price integer not null check (total_price >= 0),
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.booking_slots (
  booking_id uuid not null references public.bookings(id) on delete cascade,
  court_id uuid not null references public.courts(id) on delete restrict,
  booking_date date not null,
  time_slot_id uuid not null references public.time_slots(id) on delete restrict,
  is_active boolean not null default true,
  primary key (booking_id, time_slot_id)
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null unique references public.bookings(id) on delete cascade,
  method public.payment_method not null default 'qris',
  status public.payment_status not null default 'pending',
  amount integer not null check (amount >= 0),
  provider_reference text,
  paid_at timestamptz,
  expired_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null unique references public.bookings(id) on delete cascade,
  court_id uuid not null references public.courts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  rating integer not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type public.notification_type not null default 'booking',
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index idx_courts_venue_id on public.courts(venue_id);
create index idx_courts_sport_id on public.courts(sport_id);
create index idx_venues_owner_id on public.venues(owner_id);
create index idx_bookings_user_id on public.bookings(user_id);
create index idx_bookings_court_date on public.bookings(court_id, booking_date);
create index idx_booking_slots_lookup on public.booking_slots(court_id, booking_date);
create unique index idx_booking_slots_active_unique
on public.booking_slots(court_id, booking_date, time_slot_id)
where is_active = true;
create index idx_notifications_user_read on public.notifications(user_id, is_read, created_at desc);

create unique index idx_venue_images_one_primary
on public.venue_images(venue_id)
where is_primary = true;

create unique index idx_court_images_one_primary
on public.court_images(court_id)
where is_primary = true;

create unique index idx_court_maintenance_slot_unique
on public.court_maintenance(court_id, maintenance_date, time_slot_id)
where time_slot_id is not null;

create unique index idx_court_maintenance_full_day_unique
on public.court_maintenance(court_id, maintenance_date)
where time_slot_id is null;

create trigger set_profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger protect_profiles_system_fields
before update on public.profiles
for each row execute function public.protect_profile_system_fields();

create trigger set_venues_updated_at
before update on public.venues
for each row execute function public.set_updated_at();

create trigger set_courts_updated_at
before update on public.courts
for each row execute function public.set_updated_at();

create trigger set_bookings_updated_at
before update on public.bookings
for each row execute function public.set_updated_at();

create trigger protect_user_booking_fields
before update on public.bookings
for each row execute function public.protect_user_booking_fields();

create trigger sync_booking_slot_activity
after update of status on public.bookings
for each row execute function public.sync_booking_slot_activity();

create trigger set_payments_updated_at
before update on public.payments
for each row execute function public.set_updated_at();

create trigger set_reviews_updated_at
before update on public.reviews
for each row execute function public.set_updated_at();

create trigger protect_notification_fields
before update on public.notifications
for each row execute function public.protect_notification_fields();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', split_part(new.email, '@', 1), 'User Aerobook'),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'avatar_url'
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create or replace function public.current_user_role()
returns public.app_role
language sql
security definer
set search_path = public
stable
as $$
  select role
  from public.profiles
  where id = auth.uid();
$$;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(public.current_user_role() = 'admin', false);
$$;

create or replace function public.is_owner()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(public.current_user_role() = 'owner', false);
$$;

create or replace function public.owns_venue(p_venue_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.venues v
    where v.id = p_venue_id
      and v.owner_id = auth.uid()
  );
$$;

create or replace function public.owns_court(p_court_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.courts c
    join public.venues v on v.id = c.venue_id
    where c.id = p_court_id
      and v.owner_id = auth.uid()
  );
$$;

create or replace function public.can_read_booking(p_booking_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.bookings b
    join public.courts c on c.id = b.court_id
    join public.venues v on v.id = c.venue_id
    where b.id = p_booking_id
      and (
        b.user_id = auth.uid()
        or v.owner_id = auth.uid()
        or public.is_admin()
      )
  );
$$;

create or replace function public.can_read_profile(p_profile_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select
    p_profile_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1
      from public.bookings b
      join public.courts c on c.id = b.court_id
      join public.venues v on v.id = c.venue_id
      where b.user_id = p_profile_id
        and v.owner_id = auth.uid()
    );
$$;

create or replace function public.refresh_court_rating()
returns trigger
language plpgsql
as $$
declare
  affected_court_id uuid;
begin
  if tg_op = 'DELETE' then
    affected_court_id = old.court_id;
  else
    affected_court_id = new.court_id;
  end if;

  update public.courts
  set
    average_rating = coalesce((
      select round(avg(rating)::numeric, 2)
      from public.reviews
      where court_id = affected_court_id
    ), 0),
    review_count = (
      select count(*)
      from public.reviews
      where court_id = affected_court_id
    )
  where id = affected_court_id;

  if tg_op = 'DELETE' then
    return old;
  end if;

  return new;
end;
$$;

create trigger reviews_refresh_court_rating
after insert or update or delete on public.reviews
for each row execute function public.refresh_court_rating();

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
      when bs.time_slot_id is not null then false
      when p_booking_date = current_date and ts.start_time <= current_time then false
      else true
    end as is_available,
    case
      when cm.id is not null then 'maintenance'
      when bs.time_slot_id is not null then 'booked'
      when p_booking_date = current_date and ts.start_time <= current_time then 'past_time'
      else null
    end as reason
  from public.court_available_slots cas
  join public.time_slots ts on ts.id = cas.time_slot_id
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

  select count(distinct slot_id)
  into v_slot_count
  from unnest(p_time_slot_ids) as requested(slot_id)
  join public.get_court_availability(p_court_id, p_booking_date) availability
    on availability.slot_id = requested.slot_id
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
    distinct_slots.slot_id
  from (
    select distinct unnest(p_time_slot_ids) as slot_id
  ) distinct_slots;

  return query
  select v_booking_id, v_booking_code, v_subtotal + v_service_fee;
end;
$$;

alter table public.profiles enable row level security;
alter table public.sports enable row level security;
alter table public.venues enable row level security;
alter table public.venue_images enable row level security;
alter table public.amenities enable row level security;
alter table public.venue_amenities enable row level security;
alter table public.courts enable row level security;
alter table public.court_images enable row level security;
alter table public.time_slots enable row level security;
alter table public.court_available_slots enable row level security;
alter table public.court_maintenance enable row level security;
alter table public.bookings enable row level security;
alter table public.booking_slots enable row level security;
alter table public.payments enable row level security;
alter table public.reviews enable row level security;
alter table public.notifications enable row level security;

create policy "profiles_select_own"
on public.profiles for select
using (public.can_read_profile(id));

create policy "profiles_update_own"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "profiles_admin_all"
on public.profiles for all
using (public.is_admin())
with check (public.is_admin());

create policy "sports_public_select"
on public.sports for select
using (is_active = true);

create policy "sports_admin_all"
on public.sports for all
using (public.is_admin())
with check (public.is_admin());

create policy "venues_public_select"
on public.venues for select
using (status = 'open');

create policy "venues_owner_select"
on public.venues for select
using (owner_id = auth.uid());

create policy "venues_admin_all"
on public.venues for all
using (public.is_admin())
with check (public.is_admin());

create policy "venue_images_public_select"
on public.venue_images for select
using (
  exists (
    select 1
    from public.venues v
    where v.id = venue_images.venue_id
      and v.status = 'open'
  )
);

create policy "venue_images_owner_select"
on public.venue_images for select
using (public.owns_venue(venue_id));

create policy "venue_images_admin_all"
on public.venue_images for all
using (public.is_admin())
with check (public.is_admin());

create policy "amenities_public_select"
on public.amenities for select
using (true);

create policy "amenities_admin_all"
on public.amenities for all
using (public.is_admin())
with check (public.is_admin());

create policy "venue_amenities_public_select"
on public.venue_amenities for select
using (
  exists (
    select 1
    from public.venues v
    where v.id = venue_amenities.venue_id
      and v.status = 'open'
  )
);

create policy "venue_amenities_owner_select"
on public.venue_amenities for select
using (public.owns_venue(venue_id));

create policy "venue_amenities_admin_all"
on public.venue_amenities for all
using (public.is_admin())
with check (public.is_admin());

create policy "courts_public_select"
on public.courts for select
using (
  status = 'active'
  and exists (
    select 1
    from public.venues v
    where v.id = courts.venue_id
      and v.status = 'open'
  )
);

create policy "courts_owner_select"
on public.courts for select
using (public.owns_venue(venue_id));

create policy "courts_admin_all"
on public.courts for all
using (public.is_admin())
with check (public.is_admin());

create policy "court_images_public_select"
on public.court_images for select
using (
  exists (
    select 1
    from public.courts c
    join public.venues v on v.id = c.venue_id
    where c.id = court_images.court_id
      and c.status = 'active'
      and v.status = 'open'
  )
);

create policy "court_images_owner_select"
on public.court_images for select
using (public.owns_court(court_id));

create policy "court_images_admin_all"
on public.court_images for all
using (public.is_admin())
with check (public.is_admin());

create policy "time_slots_public_select"
on public.time_slots for select
using (is_active = true);

create policy "time_slots_admin_all"
on public.time_slots for all
using (public.is_admin())
with check (public.is_admin());

create policy "court_available_slots_public_select"
on public.court_available_slots for select
using (
  exists (
    select 1
    from public.courts c
    join public.venues v on v.id = c.venue_id
    where c.id = court_available_slots.court_id
      and c.status = 'active'
      and v.status = 'open'
  )
);

create policy "court_available_slots_owner_select"
on public.court_available_slots for select
using (public.owns_court(court_id));

create policy "court_available_slots_admin_all"
on public.court_available_slots for all
using (public.is_admin())
with check (public.is_admin());

create policy "court_maintenance_public_select"
on public.court_maintenance for select
using (false);

create policy "court_maintenance_owner_select"
on public.court_maintenance for select
using (public.owns_court(court_id));

create policy "court_maintenance_admin_all"
on public.court_maintenance for all
using (public.is_admin())
with check (public.is_admin());

create policy "bookings_select_own"
on public.bookings for select
using (public.can_read_booking(id));

create policy "bookings_admin_all"
on public.bookings for all
using (public.is_admin())
with check (public.is_admin());

create policy "bookings_cancel_own_pending"
on public.bookings for update
using (auth.uid() = user_id and status in ('pending_payment', 'confirmed'))
with check (auth.uid() = user_id and status = 'cancelled');

create policy "booking_slots_select_own"
on public.booking_slots for select
using (public.can_read_booking(booking_id));

create policy "booking_slots_admin_all"
on public.booking_slots for all
using (public.is_admin())
with check (public.is_admin());

create policy "payments_select_own"
on public.payments for select
using (public.can_read_booking(booking_id));

create policy "payments_admin_all"
on public.payments for all
using (public.is_admin())
with check (public.is_admin());

create policy "payments_insert_own"
on public.payments for insert
with check (
  exists (
    select 1 from public.bookings b
    where b.id = payments.booking_id
      and b.user_id = auth.uid()
      and b.status = 'pending_payment'
      and b.total_price = payments.amount
  )
  and payments.status = 'pending'
  and payments.method in ('qris', 'bank_transfer', 'e_wallet')
);

create policy "reviews_public_select"
on public.reviews for select
using (true);

create policy "reviews_admin_all"
on public.reviews for all
using (public.is_admin())
with check (public.is_admin());

create policy "reviews_insert_own_finished_booking"
on public.reviews for insert
with check (
  auth.uid() = user_id
  and exists (
    select 1 from public.bookings b
    where b.id = reviews.booking_id
      and b.user_id = auth.uid()
      and b.court_id = reviews.court_id
      and b.status = 'finished'
  )
);

create policy "reviews_update_own"
on public.reviews for update
using (auth.uid() = user_id)
with check (
  auth.uid() = user_id
  and exists (
    select 1 from public.bookings b
    where b.id = reviews.booking_id
      and b.user_id = auth.uid()
      and b.court_id = reviews.court_id
      and b.status = 'finished'
  )
);

create policy "notifications_select_own"
on public.notifications for select
using (auth.uid() = user_id);

create policy "notifications_update_own"
on public.notifications for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "notifications_admin_all"
on public.notifications for all
using (public.is_admin())
with check (public.is_admin());
