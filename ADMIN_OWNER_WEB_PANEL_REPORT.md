# Aerobook Admin & Owner Web Panel Detailed Report

Report ini menjadi pegangan development web panel Aerobook di dalam repository `apkbooking`, karena Supabase schema, migrations, dan seed sudah berada di project ini.

Tujuan web panel:

- Admin mengelola operasional, catalog venue/court, booking, payment, user, dan review.
- Owner memonitor venue miliknya secara read-only.
- Customer tetap memakai Flutter mobile app.
- Frontend web memakai Supabase anon key, bukan service role.
- Semua akses sensitif tetap dikontrol oleh Supabase Auth, role table, RLS, dan RPC guard.

## Recommended Directory

Karena panel akan dibuat di repo yang sama dengan Supabase, gunakan folder terpisah agar dependency Flutter dan React tidak tercampur.

```txt
D:\PROJECT\MOBILE\Aerobook\apkbooking\web-panel
```

Struktur ideal:

```txt
apkbooking/
  lib/                 # Flutter mobile app
  supabase/            # Supabase config, migrations, seed
  web-panel/           # React admin/owner panel
    app/
    public/
    package.json
    vite.config.ts
```

Jangan taruh `package.json` React di root `apkbooking` karena root ini sudah dipakai Flutter.

## Current Backend Baseline

Backend saat ini memakai Supabase.

- Auth: Supabase Auth.
- App user table: `public.users`.
- Role table: `public.roles`.
- Role relasi: `users.role_id -> roles.id`.
- Role tersedia:
  - `customer`
  - `admin`
  - `owner`
- Booking dibuat lewat RPC `create_booking`.
- Admin/owner web sebaiknya mengakses data lewat RPC khusus, bukan join kompleks langsung dari frontend.

Catatan schema penting:

- `public.users` tidak punya kolom `email`.
- Email user dibaca dari `auth.users`, biasanya sudah disediakan oleh RPC admin/owner.
- Untuk current logged-in user di frontend, email bisa diambil dari `supabase.auth.getSession().user.email`.

## Web Stack

Gunakan:

```txt
React + Vite + TypeScript
React Router SPA mode
Supabase JS
TanStack Query
React Hook Form
Zod
Tailwind CSS
lucide-react
clsx + tailwind-merge
Biome
```

Alasan:

- Dashboard internal tidak butuh SEO.
- SPA cocok untuk Supabase client-side auth.
- TanStack Query cocok untuk RPC read/mutation + cache invalidation.
- React Hook Form + Zod cocok untuk form admin catalog.
- Biome cukup untuk format/lint awal tanpa setup ESLint panjang.

## Environment

File `web-panel/.env`:

```env
VITE_SUPABASE_URL=https://bncnqdpiefocyzqurlsj.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

Rules:

- Jangan commit `.env`.
- `.env.example` boleh commit, tapi key harus placeholder.
- Jangan pakai service role di frontend.
- Service role hanya boleh untuk script lokal/admin/server yang tidak masuk browser bundle.

## Auth Flow

Login web:

1. User input email/password.
2. Frontend call `supabase.auth.signInWithPassword`.
3. Ambil `auth.user.id` dan `auth.user.email`.
4. Fetch profile role:

```ts
supabase
  .from("users")
  .select("id,full_name,roles(name)")
  .eq("id", user.id)
  .maybeSingle();
```

5. Redirect:
   - `admin` ke `/admin`
   - `owner` ke `/owner`
   - `customer` ke `/forbidden`
6. Route guard:
   - admin-only route hanya role `admin`
   - owner-only route hanya role `owner`
   - customer ditolak dari web panel

## Route Plan

Base:

```txt
/login
/forbidden
```

Admin:

```txt
/admin
/admin/bookings
/admin/payments
/admin/users
/admin/venues
/admin/courts
/admin/sports
/admin/time-slots
/admin/availability
/admin/maintenance
/admin/reviews
```

Owner:

```txt
/owner
/owner/venues
/owner/courts
/owner/bookings
/owner/payments
/owner/reviews
```

## Existing Admin Read RPC

Sudah ada:

```txt
admin_dashboard_summary()
admin_users()
admin_venues()
admin_courts()
admin_bookings()
admin_payments()
admin_reviews()
```

Pemakaian:

- Dashboard: `admin_dashboard_summary()`
- User table: `admin_users()`
- Venue table: `admin_venues()`
- Court table: `admin_courts()`
- Booking table: `admin_bookings()`
- Payment table: `admin_payments()`
- Review table: `admin_reviews()`

## Existing Admin Transaction Action RPC

Sudah ada:

```txt
admin_confirm_payment(p_payment_id uuid)
admin_confirm_booking(p_booking_id uuid)
admin_finish_booking(p_booking_id uuid)
admin_cancel_booking(p_booking_id uuid, p_reason text default null)
```

Expected UI:

- Payment `pending` -> tombol `Confirm payment`.
- Booking `pending_payment` -> tombol `Confirm booking`, `Cancel booking`.
- Booking `confirmed` -> tombol `Finish booking`, `Cancel booking`.
- Booking `finished/cancelled/expired` -> no actions.

Semua action wajib pakai confirmation dialog.

## Existing Admin Catalog RPC

Sudah ditambahkan melalui migration:

```txt
admin_owners()
admin_sports()
admin_create_venue(...)
admin_update_venue(...)
admin_create_court(...)
admin_update_court(...)
```

Fungsi:

- `admin_owners()` untuk dropdown owner saat create/edit venue.
- `admin_sports()` untuk dropdown sport saat create/edit court.
- `admin_create_venue()` membuat venue baru.
- `admin_update_venue()` update venue.
- `admin_create_court()` membuat court baru.
- `admin_update_court()` update court.

UI minimal:

- `/admin/venues`
  - table venue
  - create venue modal
  - edit venue modal
  - owner dropdown
  - status open/closed
- `/admin/courts`
  - table court
  - create court modal
  - edit court modal
  - venue dropdown
  - sport dropdown
  - status active/inactive/maintenance

## Admin Features Needed

### Admin MVP

Status: prioritas tertinggi.

- Login.
- Role guard.
- Admin dashboard summary.
- Bookings table.
- Payments table.
- Confirm payment.
- Confirm booking.
- Finish booking.
- Cancel booking.

### Admin Catalog

Status: setelah transaction MVP stabil.

- Venues list.
- Create/edit venue.
- Courts list.
- Create/edit court.
- Sports list.
- Create/edit sport.
- Time slots list.
- Create/edit time slots.
- Court availability assignment.
- Court maintenance calendar/list.

### Admin Users

Needed:

- User list from `admin_users()`.
- Filter by role.
- Search email/name/phone.
- View booking/payment summary.
- Optional later: assign role customer/owner/admin through guarded RPC.

Do not allow direct user role update from browser table without RPC guard.

### Admin Reviews

Needed:

- Review list from `admin_reviews()`.
- Filter rating.
- Filter venue/court.
- Optional moderation action later if product requires it.

### Admin Reports

Later:

- Revenue by venue.
- Revenue by date range.
- Booking count by sport/court.
- Top venue/court.
- Pending payment queue.

## Owner Existing Read RPC

Sudah ada:

```txt
owner_venues()
owner_courts()
owner_bookings()
owner_payments()
owner_reviews()
```

Owner access principle:

- Owner hanya melihat venue yang `venues.owner_id = auth.uid()`.
- Owner tidak membuat/update/delete data.
- Owner tidak mengubah booking/payment.
- Owner panel read-only.

## Owner Features Needed

### Owner MVP

- Login sebagai owner.
- Role guard owner.
- Dashboard summary sederhana.
- Venue list.
- Court list.
- Booking list.
- Payment/revenue list.
- Review list.

### Owner Dashboard

Karena belum ada `owner_dashboard_summary()`, opsi:

1. Frontend derive dari RPC existing:
   - count venues dari `owner_venues()`
   - count courts dari `owner_courts()`
   - count bookings dari `owner_bookings()`
   - revenue dari `owner_payments()`
   - reviews dari `owner_reviews()`

2. Tambah RPC khusus:

```txt
owner_dashboard_summary()
```

Rekomendasi: mulai dari derive frontend dulu, tambah RPC jika performa mulai terasa.

## Suggested Frontend API Layer

Wrapper RPC:

```ts
import { supabase } from "~/lib/supabase";

export async function callRpc<T>(
  name: string,
  params?: Record<string, unknown>
): Promise<T> {
  const { data, error } = await supabase.rpc(name, params ?? {});

  if (error) {
    throw error;
  }

  return data as T;
}
```

Query pattern:

```ts
useQuery({
  queryKey: ["admin", "bookings"],
  queryFn: getAdminBookings,
});
```

Mutation pattern:

```ts
useMutation({
  mutationFn: confirmPayment,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ["admin", "payments"] });
    queryClient.invalidateQueries({ queryKey: ["admin", "bookings"] });
    queryClient.invalidateQueries({ queryKey: ["admin", "dashboard-summary"] });
  },
});
```

## Suggested Frontend Folder Structure

```txt
web-panel/
  app/
    components/
      confirm-dialog.tsx
      dashboard-shell.tsx
      query-state.tsx
      status-badge.tsx
    features/
      admin/
        admin-api.ts
      auth/
        auth-provider.tsx
        require-role.tsx
      owner/
        owner-api.ts
    lib/
      env.ts
      format.ts
      rpc.ts
      supabase.ts
      utils.ts
    providers/
      query-provider.tsx
    routes/
      login.tsx
      forbidden.tsx
      admin.tsx
      owner.tsx
      admin/
      owner/
```

## Build Order From Current Point

Recommended next development order:

1. Create `apkbooking/web-panel`.
2. Port current panel foundation:
   - SPA config
   - Supabase client
   - RPC wrapper
   - Query provider
   - Auth provider
   - Role guard
3. Implement admin MVP:
   - dashboard
   - bookings
   - payments
   - payment/booking actions
4. Implement admin catalog:
   - venues list/create/edit
   - courts list/create/edit
5. Implement sports management:
   - `admin_sports()`
   - `admin_create_sport()`
   - `admin_update_sport()`
6. Implement time slots:
   - `admin_time_slots()`
   - `admin_create_time_slot()`
   - `admin_update_time_slot()`
7. Implement court availability:
   - assign available slots per court
   - bulk apply slots
8. Implement maintenance:
   - create maintenance date/time slot
   - list maintenance
   - remove maintenance
9. Implement owner read-only panel.
10. Add fresh/reset dev script after all flows are clear.

## Missing Backend Contract Still Needed

Recommended migrations to add next:

```txt
admin_create_sport(...)
admin_update_sport(...)
admin_time_slots()
admin_create_time_slot(...)
admin_update_time_slot(...)
admin_court_available_slots(p_court_id uuid)
admin_set_court_available_slots(p_court_id uuid, p_time_slot_ids uuid[])
admin_court_maintenance()
admin_create_court_maintenance(...)
admin_delete_court_maintenance(...)
```

Optional:

```txt
owner_dashboard_summary()
admin_update_user_role(...)
```

## Fresh/Reset Plan

Fresh/reset sebaiknya dibuat setelah admin panel sudah bisa input master data lengkap.

Jangan buat tombol reset di frontend production.

Opsi aman:

### Local Supabase

```bash
supabase db reset
```

Ini mirip:

```bash
php artisan migrate:fresh --seed
```

### Remote Dev/Demo

Buat script lokal khusus dengan service role atau database connection.

Target reset:

- Clear transaction data:
  - reviews
  - payments
  - booking_slots
  - bookings
  - notifications
- Optional clear catalog:
  - court_maintenance
  - court_available_slots
  - courts
  - venue_amenities
  - venue_images
  - venues
- Preserve:
  - roles
  - auth demo accounts
  - users admin/owner/customer demo if still needed
  - sports/time_slots if treated as base seed

Fresh script harus eksplisit bernama dev/demo only, misalnya:

```txt
scripts/fresh-demo-data.ts
```

## Demo Accounts

```txt
admin1@example.com / password123
owner1@example.com / password123
customer1@example.com / password123
```

Expected:

- Admin masuk `/admin`.
- Owner masuk `/owner`.
- Customer ditolak ke `/forbidden`.

## Current Known Verified Behavior

Sudah pernah diverifikasi:

- Admin login berhasil.
- Owner login berhasil.
- Customer login berhasil tapi ditolak dari web panel.
- `admin_dashboard_summary()` berjalan.
- `admin_bookings()` berjalan.
- `admin_payments()` berjalan.
- `admin_venues()` berjalan.
- `admin_courts()` berjalan.
- `owner_venues()` berjalan.
- `owner_courts()` berjalan.
- `owner_bookings()` berjalan.
- `owner_payments()` berjalan.
- `owner_reviews()` berjalan.
- `admin_confirm_payment()` berhasil mengubah pending payment menjadi paid.
- `admin_finish_booking()` berhasil mengubah confirmed booking menjadi finished.
- `admin_create_venue()` dan `admin_update_venue()` berhasil smoke test.
- `admin_create_court()` dan `admin_update_court()` berhasil smoke test.

## Immediate Next Step

Jika web panel dibuat ulang di `apkbooking/web-panel`, langkah berikutnya:

1. Scaffold React Router SPA di `apkbooking/web-panel`.
2. Copy pola foundation dari current prototype.
3. Connect auth + admin dashboard.
4. Port admin bookings/payments/actions.
5. Port admin venues/courts create/edit.
6. Baru lanjut sports/time slots/availability.

Urutan ini menjaga panel tetap usable sambil backend contract bertambah rapi.
