insert into public.sports (name, slug, icon_url)
values
  ('Badminton', 'badminton', null),
  ('Tennis', 'tennis', null),
  ('Futsal', 'futsal', null),
  ('Basket', 'basket', null)
on conflict (slug) do update set
  name = excluded.name,
  icon_url = excluded.icon_url,
  is_active = true;

insert into public.amenities (name, icon_name)
values
  ('WiFi', 'wifi'),
  ('Shower', 'shower'),
  ('Socket', 'electrical_services'),
  ('Mineral', 'local_drink'),
  ('Parkir', 'local_parking'),
  ('Locker', 'lock')
on conflict (name) do update set icon_name = excluded.icon_name;

insert into public.time_slots (label, start_time, end_time, sort_order)
values
  ('08:00', '08:00', '09:00', 1),
  ('09:00', '09:00', '10:00', 2),
  ('10:00', '10:00', '11:00', 3),
  ('11:00', '11:00', '12:00', 4),
  ('13:00', '13:00', '14:00', 5),
  ('14:00', '14:00', '15:00', 6),
  ('15:00', '15:00', '16:00', 7),
  ('16:00', '16:00', '17:00', 8),
  ('19:00', '19:00', '20:00', 9),
  ('20:00', '20:00', '21:00', 10),
  ('21:00', '21:00', '22:00', 11),
  ('22:00', '22:00', '23:00', 12)
on conflict (start_time, end_time) do update set
  label = excluded.label,
  sort_order = excluded.sort_order,
  is_active = true;

insert into public.venues (name, slug, description, address, city, status)
values
  (
    'Stadium Atelier',
    'stadium-atelier',
    'Premium indoor venue with clean modern courts.',
    'Olympic Sports Complex, Solo Baru',
    'Sukoharjo',
    'open'
  ),
  (
    'Grand Slam Arena',
    'grand-slam-arena',
    'Bright tennis training courts with tournament-standard lighting.',
    'Solo Center District',
    'Solo',
    'open'
  ),
  (
    'The Smash Club',
    'the-smash-club',
    'Friendly badminton club for weekly sparring and league nights.',
    'Kartasura Sports Hub',
    'Kartasura',
    'open'
  )
on conflict (slug) do update set
  name = excluded.name,
  description = excluded.description,
  address = excluded.address,
  city = excluded.city,
  status = excluded.status;

insert into public.venue_images (venue_id, image_url, alt_text, sort_order, is_primary)
select v.id, data.image_url, data.alt_text, data.sort_order, data.is_primary
from (
  values
    ('stadium-atelier', 'assets/images/Venue/Venue1.jpg', 'Stadium Atelier venue', 1, true),
    ('grand-slam-arena', 'assets/images/Venue/Venue2.jpg', 'Grand Slam Arena venue', 1, true),
    ('the-smash-club', 'assets/images/Venue/Venue3.jpg', 'The Smash Club venue', 1, true)
) as data(venue_slug, image_url, alt_text, sort_order, is_primary)
join public.venues v on v.slug = data.venue_slug
where not exists (
  select 1
  from public.venue_images vi
  where vi.venue_id = v.id
    and vi.image_url = data.image_url
);

insert into public.venue_amenities (venue_id, amenity_id)
select v.id, a.id
from (
  values
    ('stadium-atelier', 'WiFi'),
    ('stadium-atelier', 'Shower'),
    ('stadium-atelier', 'Socket'),
    ('stadium-atelier', 'Mineral'),
    ('stadium-atelier', 'Parkir'),
    ('grand-slam-arena', 'WiFi'),
    ('grand-slam-arena', 'Shower'),
    ('grand-slam-arena', 'Parkir'),
    ('the-smash-club', 'WiFi'),
    ('the-smash-club', 'Mineral'),
    ('the-smash-club', 'Parkir')
) as data(venue_slug, amenity_name)
join public.venues v on v.slug = data.venue_slug
join public.amenities a on a.name = data.amenity_name
on conflict do nothing;

insert into public.courts (
  venue_id,
  sport_id,
  name,
  slug,
  surface,
  environment,
  price_per_hour,
  status
)
select
  v.id,
  s.id,
  data.name,
  data.slug,
  data.surface,
  data.environment,
  data.price_per_hour,
  'active'
from (
  values
    ('stadium-atelier', 'badminton', 'Grand Court 01', 'grand-court-01', 'Vinyl Premium', 'Indoor', 100000),
    ('stadium-atelier', 'badminton', 'Grand Court 02', 'grand-court-02', 'Interlock Pro', 'Indoor', 100000),
    ('stadium-atelier', 'badminton', 'Grand Court 03', 'grand-court-03', 'Rubber Shock', 'Indoor', 110000),
    ('grand-slam-arena', 'tennis', 'Center Court', 'center-court', 'Synthetic Acrylic', 'Indoor', 95000),
    ('the-smash-club', 'badminton', 'Court A', 'court-a', 'Wood Finish', 'Indoor', 85000)
) as data(venue_slug, sport_slug, name, slug, surface, environment, price_per_hour)
join public.venues v on v.slug = data.venue_slug
join public.sports s on s.slug = data.sport_slug
on conflict (venue_id, slug) do update set
  sport_id = excluded.sport_id,
  name = excluded.name,
  surface = excluded.surface,
  environment = excluded.environment,
  price_per_hour = excluded.price_per_hour,
  status = excluded.status;

insert into public.court_images (court_id, image_url, alt_text, sort_order, is_primary)
select c.id, data.image_url, data.alt_text, data.sort_order, data.is_primary
from (
  values
    ('stadium-atelier', 'grand-court-01', 'assets/images/Court/badminton1.jpg', 'Grand Court 01', 1, true),
    ('stadium-atelier', 'grand-court-02', 'assets/images/Court/badminton4.jpg', 'Grand Court 02', 1, true),
    ('stadium-atelier', 'grand-court-03', 'assets/images/Court/badminton7.jpg', 'Grand Court 03', 1, true),
    ('grand-slam-arena', 'center-court', 'assets/images/Court/tennis1.jpg', 'Center Court', 1, true),
    ('the-smash-club', 'court-a', 'assets/images/Court/badminton5.jpg', 'Court A', 1, true)
) as data(venue_slug, court_slug, image_url, alt_text, sort_order, is_primary)
join public.venues v on v.slug = data.venue_slug
join public.courts c on c.venue_id = v.id and c.slug = data.court_slug
where not exists (
  select 1
  from public.court_images ci
  where ci.court_id = c.id
    and ci.image_url = data.image_url
);

insert into public.court_available_slots (court_id, time_slot_id)
select c.id, ts.id
from public.courts c
cross join public.time_slots ts
where ts.is_active = true
on conflict do nothing;
