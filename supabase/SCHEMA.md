# Aerobook Supabase Schema

Rancangan ini memakai satu database global untuk aplikasi Aerobook, lalu aksesnya dikontrol dengan Supabase Auth, role di `roles`, RLS, dan RPC.

## Prinsip

- Auth tetap memakai `auth.users`.
- Data user aplikasi disimpan di `public.users`.
- Role aplikasi disimpan di `public.roles`, lalu `users.role_id` menentukan jenis role user.
- Customer bisa transaksi, owner hanya read-only untuk venue miliknya, admin mengelola master data.
- Venue, court, sport, amenity, image, dan slot dipisah agar tidak ada data berulang.
- Venue punya `owner_id` agar dashboard owner bisa membaca data venue/court/booking yang terkait dengannya.
- Jam operasional venue disimpan di `venue_operating_hours`, sehingga master `time_slots` tetap global tanpa duplikasi per venue.
- Peraturan venue disimpan di `venue_rules`, sehingga copy detail venue tidak perlu hardcode di frontend.
- Promo dan home banner disimpan di `promos` dan `home_banners`, sehingga konten home/marketing bisa diatur dari admin panel.
- Booking memakai `bookings` + `booking_slots`, sehingga satu booking bisa berisi beberapa slot.
- Partial unique index di `booking_slots(court_id, booking_date, time_slot_id)` untuk slot aktif mencegah double booking di level database.
- Slot booking yang `cancelled` atau `expired` otomatis dinonaktifkan agar slot bisa dipakai lagi tanpa menghapus histori booking.
- Rating court dicache di `courts.average_rating` dan `courts.review_count`, lalu diperbarui otomatis dari `reviews`.
- Venue/court hanya boleh punya satu primary image.
- Admin bisa mengelola galeri venue/court lewat RPC image management; primary image dipakai mobile sebagai hero/card, sedangkan semua image menjadi gallery/detail.
- Maintenance full-day dan per-slot dijaga unik agar tidak ada blokir jadwal dobel.

## Tables

- `roles`: master role aplikasi (`customer`, `owner`, `admin`).
- `users`: data user aplikasi yang terhubung ke `auth.users`.
- `sports`: master olahraga.
- `venues`: master venue.
- `venue_images`: galeri venue.
- `venue_operating_hours`: jam buka/tutup venue per hari.
- `venue_rules`: aturan/catatan venue yang tampil di detail venue.
- `amenities`: master fasilitas.
- `venue_amenities`: many-to-many venue dan fasilitas.
- `courts`: lapangan per venue dan sport.
- `court_images`: galeri court.
- `time_slots`: master slot jam.
- `court_available_slots`: slot yang tersedia secara normal untuk sebuah court.
- `court_maintenance`: blokir slot/date karena maintenance.
- `bookings`: header transaksi booking.
- `booking_slots`: detail slot yang dipesan.
- `payments`: pembayaran untuk booking.
- `promos`: master promo customer.
- `home_banners`: banner/konten promo di home customer.
- `reviews`: review setelah booking selesai.
- `notifications`: notifikasi user.

## Frontend Query Direction

- Sports/category chips: `sports`.
- Venue list/home: `venues` + `venue_images` + `courts` + `sports` + optional `home_banners`.
- Court detail: `courts` + `court_images` + `venues` + `sports`.
- Venue detail content: `venue_amenities` + `amenities` + `venue_rules`.
- Availability: RPC `get_court_availability(court_id, booking_date)`, sudah memperhitungkan `court_available_slots`, jam operasional venue, booking aktif, maintenance, dan past time.
- Checkout: panggil RPC `create_booking(court_id, booking_date, time_slot_ids)`.
- Promo display/validation: `promos`, atau RPC promo khusus jika frontend butuh validasi server-side sebelum booking.
- Payment: insert/update `payments`.
- My bookings: `bookings` filtered by current user.
- Notifications: `notifications` filtered by current user.
- Reviews: public read from `reviews`, insert only for user's finished booking.
- Owner web: RPC `owner_venues`, `owner_courts`, `owner_bookings`, `owner_payments`, `owner_reviews`.
- Admin web read-only: RPC `admin_dashboard_summary`, `admin_users`, `admin_venues`, `admin_courts`, `admin_bookings`, `admin_payments`, dan `admin_reviews`.
- Admin web actions: status RPC `admin_confirm_payment`, `admin_confirm_booking`, `admin_finish_booking`, `admin_cancel_booking`.

## Roles

### Customer

- Membaca katalog aktif: sports, venues, courts, images, amenities, dan time slots.
- Melihat availability lewat RPC `get_court_availability`.
- Membuat booking lewat RPC `create_booking`.
- Membuat payment pending untuk booking sendiri.
- Customer payment method dibatasi ke `qris`, `bank_transfer`, atau `e_wallet`. Method `cash` disiapkan untuk admin/offline flow.
- Membaca booking, booking slots, payment, user profile, dan notification miliknya sendiri.
- Membuat review hanya untuk booking miliknya yang sudah `finished`.

### Owner

- Read-only.
- Membaca venue dengan `venues.owner_id = auth.uid()`.
- Membaca court, image, slot availability, maintenance, booking, payment, review, dan customer user profile yang terkait dengan venue miliknya.
- Untuk panel web, gunakan RPC read-only: `owner_venues`, `owner_courts`, `owner_bookings`, `owner_payments`, dan `owner_reviews`.
- Tidak memiliki policy insert/update/delete untuk master data atau transaksi.

### Admin

- Full access via RLS untuk master data dan transaksi.
- Satu-satunya role yang dapat create/update/delete catalog seperti venues, courts, slots, amenities, maintenance, dan notification.
- Dapat mengubah status booking/payment.
- Untuk panel web, gunakan RPC read-only: `admin_dashboard_summary`, `admin_users`, `admin_venues`, `admin_courts`, `admin_bookings`, `admin_payments`, dan `admin_reviews`.
- Untuk action status, gunakan RPC: `admin_confirm_payment`, `admin_confirm_booking`, `admin_finish_booking`, dan `admin_cancel_booking`.
- Untuk catalog/content management, gunakan RPC admin khusus sport, venue, court, time slot, court slot, maintenance, amenities, venue rules, promos, home banners, dan image management.

## Web Admin Read Contract

- `admin_dashboard_summary`: ringkasan jumlah users, venues, courts, bookings, pending payments, paid revenue, dan reviews.
- `admin_users`: list user dengan email auth, role, wallet, points, jumlah booking, dan total spent.
- `admin_venues`: list venue dengan owner, jumlah court, jumlah booking, dan revenue paid.
- `admin_courts`: list court dengan venue, sport, harga, status, rating, dan jumlah booking.
- `admin_bookings`: list booking dengan customer, venue, court, slot labels, status booking, dan status payment.
- `admin_payments`: list payment dengan booking code, method, status, amount, customer, venue, dan court.
- `admin_reviews`: list review dengan booking code, customer, venue, court, rating, dan comment.
- Semua RPC admin memanggil guard `require_admin()`, sehingga role `customer` dan `owner` tidak bisa mengakses kontrak admin.

## Web Admin Mutation Contract

- Sport: `admin_create_sport`, `admin_update_sport`.
- Venue/court: `admin_create_venue`, `admin_update_venue`, `admin_create_court`, `admin_update_court`.
- Operating hours: `admin_venue_operating_hours`, `admin_set_venue_operating_hours`.
- Time slots: `admin_time_slots`, `admin_create_time_slot`, `admin_update_time_slot`.
- Court slot assignment: `admin_court_available_slots`, `admin_set_court_available_slots`.
- Maintenance: `admin_court_maintenance`, `admin_create_court_maintenance`, `admin_delete_court_maintenance`.
- Amenities: `admin_amenities`, `admin_create_amenity`, `admin_update_amenity`, `admin_venue_amenities`, `admin_set_venue_amenities`.
- Venue rules: `admin_venue_rules`, `admin_create_venue_rule`, `admin_update_venue_rule`, `admin_delete_venue_rule`.
- Promo: `admin_promos`, `admin_create_promo`, `admin_update_promo`, `admin_delete_promo`.
- Home banner: `admin_home_banners`, `admin_create_home_banner`, `admin_update_home_banner`, `admin_delete_home_banner`.
- Semua mutation RPC admin memakai `require_admin()` dan dipanggil dari frontend dengan anon key + session user admin.

## RLS Summary

- Public can read active/open catalog data and reviews.
- Users can read/update their own user profile.
- Users can read their own bookings and booking slots. Booking creation happens through RPC so price and selected slots are validated by the database.
- Users can read/create payments for their own bookings.
- Users can read/update their own notifications.
- Users can create reviews only for their own finished bookings.
- Owners can read data related to their assigned venues only.
- Admins can manage all tables.

## Operating Hours

- `time_slots` tetap menjadi master global slot jam.
- `venue_operating_hours` menentukan jam buka/tutup venue per hari (`day_of_week` 0-6 mengikuti PostgreSQL `extract(dow)`: 0 Sunday, 6 Saturday).
- `court_available_slots` menentukan slot global mana yang aktif untuk court tertentu.
- `get_court_availability` akan memberi reason `outside_operating_hours` jika slot berada di luar jam buka venue atau venue ditandai closed pada hari tersebut.
- Jika venue belum memiliki row operating hours, availability tidak dibatasi oleh jam venue agar data lama tetap aman.
- Admin web memakai RPC `admin_venue_operating_hours` dan `admin_set_venue_operating_hours` untuk membaca/menyimpan jam operasional.

## Catalog Control

- `/admin/time-slots` mengelola master jam global.
- `/admin/court-slots` menentukan slot mana yang aktif untuk tiap court.
- `/admin/maintenance` memblokir court full-day atau per slot.
- `/admin/amenities` mengelola master fasilitas.
- `/admin/venue-content` memasang fasilitas ke venue dan mengelola rules/catatan venue.
- `/admin/promos` mengelola promo customer.
- `/admin/banners` mengelola banner home customer.
- Dengan ini data yang biasanya dummy di user side bisa dimasukkan ulang dari admin panel terlebih dahulu.

## Image Management

- `venue_images` menyimpan gambar venue: `image_url`, `alt_text`, `sort_order`, dan `is_primary`.
- `court_images` menyimpan gambar court: `image_url`, `alt_text`, `sort_order`, dan `is_primary`.
- File upload admin memakai Supabase Storage bucket public `venue-images` dan `court-images`; write/delete tetap dibatasi role admin lewat storage policies.
- Mobile memakai primary image sebagai `imageUrl` untuk card/hero, lalu semua image terurut sebagai `galleryUrls`.
- Admin web memakai RPC:
  - `admin_venue_images`, `admin_create_venue_image`, `admin_update_venue_image`, `admin_delete_venue_image`.
  - `admin_court_images`, `admin_create_court_image`, `admin_update_court_image`, `admin_delete_court_image`.
- Saat image diset primary, RPC otomatis mematikan primary image lama agar unique rule tetap aman.
- Jika primary image dihapus, RPC otomatis menjadikan image tersisa paling awal sebagai primary.
