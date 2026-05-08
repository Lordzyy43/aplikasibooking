# Product Requirement Document (PRD)

## Aerobook - Mobile Venue Booking App

### Document Information

| Item | Detail |
| --- | --- |
| Product Name | Aerobook |
| Platform | Android mobile app |
| Framework | Flutter |
| Release Target | Play Console Internal Testing |
| Android Package ID | `com.ti24a6.app13` |
| Version | `1.0.0+1` |
| Project Scope | UTS: UI prototype with dummy/local data |
| Future Scope | UAS: backend and database integration |

---

## 1. Product Overview

Aerobook adalah aplikasi mobile untuk membantu pengguna mencari venue olahraga, melihat detail lapangan, memilih jadwal, melakukan simulasi checkout, dan melihat hasil booking. Pada tahap UTS, aplikasi difokuskan sebagai prototype mobile yang lengkap secara tampilan, navigasi, dan interaksi dasar tanpa database atau transaksi nyata.

Tujuan utama Aerobook adalah membuat proses booking lapangan terasa lebih cepat, jelas, dan modern dibanding proses manual seperti chat admin atau datang langsung ke venue.

---

## 2. Background and Problem Statement

Pengguna yang ingin menyewa lapangan olahraga sering mengalami kendala berikut:

- Informasi venue, fasilitas, harga, dan gambar lapangan tidak selalu tersedia dalam satu tempat.
- Proses pemilihan jadwal masih manual dan kurang praktis.
- Pengguna tidak memiliki tampilan ringkasan booking yang jelas sebelum melakukan pembayaran.
- Riwayat booking dan notifikasi promo/status belum terorganisir.

Aerobook menjawab masalah tersebut dengan menyediakan alur booking yang terstruktur dari onboarding sampai halaman sukses pembayaran.

---

## 3. Product Goals

### 3.1 Goals for UTS

- Membuat aplikasi mobile Flutter yang dapat dijalankan di Android.
- Menyediakan tampilan dan flow utama aplikasi booking venue.
- Memastikan semua button penting dapat diklik dan memberi aksi.
- Menggunakan asset lokal untuk gambar venue, court, onboarding, avatar, logo, dan QR.
- Menyiapkan aplikasi agar bisa dibuild menjadi `.aab` untuk Play Console Internal Testing.
- Menyediakan dokumen PRD sebagai panduan fitur, fungsi, tujuan, dan perilaku aplikasi.

### 3.2 Goals for UAS

- Menghubungkan aplikasi ke backend dan database.
- Mengubah data dummy menjadi data real dari server.
- Menambahkan autentikasi real.
- Menyimpan booking, user, payment status, dan notifikasi secara persisten.
- Menambahkan dashboard/admin panel jika dibutuhkan.

---

## 4. Target Users

| User Type | Description | Main Needs |
| --- | --- | --- |
| Casual Player | Pengguna yang sesekali menyewa lapangan | Cari venue cepat, lihat harga, booking mudah |
| Student / Group | Pengguna yang booking untuk latihan atau main bersama | Lihat jadwal, fasilitas, dan ringkasan biaya |
| Sports Enthusiast | Pengguna rutin bermain badminton atau tennis | Riwayat booking, rekomendasi venue, promo |
| Venue Admin (Future) | Pengelola venue pada fase backend | Kelola jadwal, court, harga, dan booking |

---

## 5. Product Scope

### 5.1 In Scope for Current Version

- Onboarding screen.
- Login dan register dummy.
- Home dashboard.
- Search bar dan kategori olahraga.
- Venue list.
- Venue detail.
- Court detail.
- Pemilihan jadwal.
- Checkout.
- Simulasi metode pembayaran.
- QR payment dummy.
- Payment success page.
- My Booking / history page.
- Notification page.
- Profile page.
- Local image assets.
- Release build configuration untuk internal testing.

### 5.2 Out of Scope for Current Version

- Database real.
- API/backend real.
- Payment gateway real.
- Real-time schedule availability.
- Push notification real.
- Upload foto profil real.
- Admin panel.
- Maps/geolocation real.

---

## 6. Current Technical Architecture

### 6.1 Tech Stack

| Layer | Technology |
| --- | --- |
| UI Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Styling | Custom `AppColors` and `AppTheme` |
| Responsive Layout | `flutter_screenutil` |
| Local Data | Service classes with dummy data |
| Image Source | Local assets |
| Build Target | Android App Bundle (`.aab`) |

### 6.2 Architecture Layers

| Layer | Responsibility | Example Files |
| --- | --- | --- |
| Presentation | Menampilkan UI dan menerima interaksi user | `lib/views`, `lib/widgets` |
| Provider | Menyimpan state aplikasi selama session | `auth_provider.dart`, `app_data_provider.dart`, `booking_provider.dart` |
| Service | Menyediakan dummy/local data | `gor_service.dart`, `booking_service.dart` |
| Model | Struktur data aplikasi | `venue_model.dart`, `booking_model.dart`, `user_model.dart` |
| Core | Theme, warna, utility, constants | `app_theme.dart`, `app_colors.dart` |

---

## 7. User Journey

```text
Onboarding
-> Login / Register
-> Home
-> Search / Browse Venue
-> Venue Detail
-> Court Detail
-> Select Time
-> Checkout
-> Payment
-> Payment Success
-> My Booking
```

Alternative journey:

```text
Home
-> Notification
-> Promo / Booking Info
```

```text
Home
-> Profile
-> Account Menu / Logout
```

---

## 8. Functional Requirements

### 8.1 Onboarding

**Purpose:** Mengenalkan aplikasi sebelum user masuk ke halaman login.

**Requirements:**

- Menampilkan visual onboarding dari local asset.
- Menampilkan pesan singkat tentang booking venue.
- Menyediakan aksi untuk lanjut ke login/register.

**Expected Behavior:**

- Button utama mengarahkan user ke halaman autentikasi.
- Tampilan harus responsif pada layar Android umum.

---

### 8.2 Authentication

**Purpose:** Memberi simulasi akses user ke aplikasi.

**Requirements:**

- Login menerima email dan password.
- Register menerima nama, email, nomor telepon, dan password.
- Menampilkan validasi jika input kosong atau format tidak sesuai.
- Login/register berhasil akan membuat dummy user session.

**Expected Behavior:**

- Login berhasil mengarahkan user ke main screen.
- Register berhasil membuat user dummy.
- Forgot password menampilkan dialog/informasi dummy.
- Google login menampilkan feedback bahwa fitur tersedia pada versi backend.

**Current Constraint:**

- Tidak ada autentikasi server.
- Semua data user hanya berlaku selama aplikasi berjalan.

---

### 8.3 Home Dashboard

**Purpose:** Menjadi pusat navigasi untuk mencari venue dan melihat rekomendasi.

**Requirements:**

- Menampilkan greeting user.
- Menampilkan search bar.
- Menampilkan promo banner.
- Menampilkan kategori olahraga.
- Menampilkan venue recommended dan nearby.
- Menyediakan navigasi ke venue detail.

**Expected Behavior:**

- User dapat membuka halaman list venue.
- Kategori dan search memberi pengalaman eksplorasi.
- Promo/banner dapat diklik dan memberi feedback.

---

### 8.4 Venue List

**Purpose:** Menampilkan daftar venue yang bisa dipilih user.

**Requirements:**

- Menampilkan kartu venue dengan gambar, nama, lokasi, rating, jarak, dan harga.
- Mendukung filter/kategori.
- Mendukung state kosong jika hasil tidak ada.

**Expected Behavior:**

- Tap pada venue membuka venue detail.
- Filter mengubah tampilan daftar venue sesuai kategori.

---

### 8.5 Venue Detail

**Purpose:** Memberikan informasi lengkap tentang venue sebelum user memilih court.

**Requirements:**

- Menampilkan gallery gambar venue dari local assets.
- Menampilkan nama venue, lokasi, rating, fasilitas, harga, dan deskripsi.
- Menampilkan review user dummy dengan avatar lokal.
- Menampilkan daftar court yang tersedia.

**Current Venue Data:**

| Venue | Sport | Main Image |
| --- | --- | --- |
| Stadium Atelier | Badminton, Tennis | `assets/images/Venue/Venue1.jpg` |
| Grand Slam Arena | Tennis | `assets/images/Venue/Venue2.jpg` |
| The Smash Club | Badminton | `assets/images/Venue/Venue3.jpg` |

**Expected Behavior:**

- User dapat memilih court dari venue detail.
- Gallery dan fasilitas menggunakan asset yang sudah tersedia.

---

### 8.6 Court Detail

**Purpose:** Membantu user memilih court dan jam booking.

**Requirements:**

- Menampilkan gallery gambar court.
- Menampilkan detail court seperti jenis lantai, lampu, ventilasi, harga, dan environment.
- Menampilkan slot waktu tersedia dan slot yang sudah booked.
- User harus memilih slot sebelum lanjut checkout.

**Expected Behavior:**

- Slot available dapat dipilih.
- Slot booked memberi feedback bahwa jam tidak tersedia.
- Jika user belum memilih jam, aplikasi memberi peringatan.
- Button lanjut membawa user ke checkout setelah jam valid dipilih.

---

### 8.7 Checkout

**Purpose:** Menampilkan ringkasan booking sebelum pembayaran.

**Requirements:**

- Menampilkan venue, court, tanggal, jam, durasi, dan total harga.
- Menampilkan pilihan metode pembayaran dummy.
- Menyediakan CTA untuk lanjut ke payment.

**Expected Behavior:**

- User dapat memilih metode pembayaran.
- User dapat melanjutkan ke halaman payment.
- Total harga ditampilkan dengan format Rupiah.

---

### 8.8 Payment Simulation

**Purpose:** Mensimulasikan proses pembayaran tanpa transaksi real.

**Requirements:**

- Menampilkan QR payment dari local asset.
- Menampilkan ringkasan pembayaran.
- Menyediakan aksi konfirmasi pembayaran.

**Expected Behavior:**

- User dapat menyelesaikan pembayaran dummy.
- Setelah selesai, user diarahkan ke payment success page.

**Constraint:**

- QR bukan transaksi real.
- Tidak ada integrasi payment gateway.

---

### 8.9 Payment Success

**Purpose:** Memberi konfirmasi bahwa booking berhasil.

**Requirements:**

- Menampilkan status berhasil.
- Menampilkan ringkasan booking.
- Menyediakan navigasi kembali ke home atau melihat booking.

**Expected Behavior:**

- Booking baru masuk ke data session aplikasi.
- User mendapat feedback visual bahwa proses selesai.

---

### 8.10 My Booking / History

**Purpose:** Menampilkan daftar booking aktif dan riwayat booking.

**Requirements:**

- Menampilkan booking upcoming.
- Menampilkan booking completed.
- Menampilkan detail ringkas booking.

**Expected Behavior:**

- User dapat melihat status booking.
- User dapat membuka detail booking jika tersedia.

---

### 8.11 Notification

**Purpose:** Memberikan informasi promo, reminder, dan status booking.

**Requirements:**

- Menampilkan daftar notifikasi dummy.
- Notifikasi dapat berupa booking, promo, atau reminder.

**Expected Behavior:**

- User dapat melihat informasi terbaru dari aplikasi.
- Saat booking berhasil, aplikasi dapat membuat notifikasi dummy.

---

### 8.12 Profile

**Purpose:** Menampilkan data user dan menu akun.

**Requirements:**

- Menampilkan nama, email, avatar, poin, dan wallet dummy.
- Menampilkan menu profile seperti edit profile, payment, support, dan settings.
- Menyediakan logout.

**Expected Behavior:**

- Menu profile memberi feedback berupa dialog/snackbar.
- Logout mengembalikan user ke onboarding/login flow.

---

## 9. Data Requirements

### 9.1 Venue Model

Data venue minimal terdiri dari:

- `id`
- `name`
- `location`
- `distanceKm`
- `imageUrl`
- `galleryUrls`
- `rating`
- `reviewCount`
- `pricePerHour`
- `sports`
- `amenities`
- `statusLabel`
- `description`
- `reviews`
- `courts`

### 9.2 Court Model

Data court minimal terdiri dari:

- `id`
- `name`
- `imageUrl`
- `galleryUrls`
- `surface`
- `environment`
- `pricePerHour`
- `specs`
- `availableTimes`
- `bookedTimes`

### 9.3 Booking Model

Data booking minimal terdiri dari:

- `id`
- `venueName`
- `venueLocation`
- `venueImageUrl`
- `courtName`
- `sport`
- `date`
- `startTime`
- `endTime`
- `totalPrice`
- `status`

---

## 10. Asset Requirements

Current asset groups:

| Asset Group | Path | Usage |
| --- | --- | --- |
| Avatar | `assets/Avatar/` | User avatar, QR payment |
| Venue Images | `assets/images/Venue/` | Venue gallery and detail |
| Court Images | `assets/images/Court/` | Court gallery and detail |
| Onboarding | `assets/images/onBoarding/` | Onboarding screen |
| Logos | `assets/logos/` | App logo and splash logo |

Requirements:

- Semua gambar utama harus menggunakan local asset agar aman untuk Play Store review dan tidak bergantung ke URL eksternal.
- Asset harus terdaftar di `pubspec.yaml`.
- Gambar harus memiliki nama file yang konsisten dan mudah dipetakan ke data dummy.
- Gambar tidak boleh hilang karena dapat menyebabkan blank/error pada UI.

---

## 11. UI/UX Requirements

### 11.1 Design Principles

- Clean and modern.
- Mobile-first.
- Mudah dipahami oleh user baru.
- Feedback jelas di setiap aksi.
- Warna mengikuti `AppColors`.
- Theme mengikuti `AppTheme`.
- Gambar venue/court menjadi elemen utama untuk membantu user memilih.

### 11.2 Interaction Requirements

- Semua button utama harus memiliki aksi.
- Aksi dummy harus tetap memberi feedback melalui snackbar, dialog, atau navigasi.
- State kosong harus ditampilkan dengan empty state, bukan layar kosong.
- Slot booked tidak boleh diperlakukan sama dengan slot available.
- Checkout tidak boleh lanjut jika user belum memilih jadwal.

---

## 12. Non-Functional Requirements

| Requirement | Target |
| --- | --- |
| Performance | App terasa ringan pada Android umum |
| Responsiveness | Layout menyesuaikan berbagai ukuran layar |
| Maintainability | Struktur folder modular dan mudah dikembangkan |
| Reliability | Tidak ada missing asset pada flow utama |
| Build Quality | `flutter analyze` harus bersih |
| Release Readiness | AAB release berhasil dibuat dan signed |
| Offline Tolerance | Data dummy dan asset lokal tetap tampil tanpa koneksi internet |

---

## 13. Release Requirements for Internal Testing

### 13.1 Android Configuration

| Item | Value |
| --- | --- |
| App Label | Aerobook |
| Package ID | `com.ti24a6.app13` |
| Build Format | Android App Bundle (`.aab`) |
| Signing | Release signing with upload keystore |
| Target Track | Play Console Internal Testing |

### 13.2 Required Play Console Materials

- App icon.
- App name: Aerobook.
- Short description.
- Full description.
- Phone screenshots.
- Privacy policy if required by Play Console.
- Data safety form.
- Internal tester email/list.
- Signed `.aab` file.

### 13.3 Current Release Artifact

Current generated release artifact:

```text
build/app/outputs/bundle/release/app-release.aab
```

---

## 14. Success Metrics

For UTS/demo:

- App dapat dibuka di Android.
- User dapat melewati onboarding, login/register, home, venue detail, court detail, checkout, payment, dan success page.
- Semua button utama memberi aksi.
- Gambar venue/court/logo/QR tampil dari local asset.
- AAB berhasil diupload ke Play Console Internal Testing.
- PRD menjelaskan fitur, fungsi, tujuan, dan perilaku aplikasi.

For future UAS:

- User dapat register/login real.
- Data venue dan court berasal dari database.
- Booking tersimpan ke database.
- Status jadwal dapat dicek secara real-time atau near real-time.
- Payment status dapat disimpan dan diverifikasi.

---

## 15. Limitations

Current version limitations:

- Data masih dummy/local.
- Tidak ada backend aktif.
- Tidak ada database.
- Tidak ada transaksi payment real.
- Tidak ada push notification.
- Tidak ada validasi jadwal antar user.
- Login/register belum menggunakan server authentication.

Alasan limitation ini diterima untuk UTS:

- Requirement UTS hanya mewajibkan tampilan mobile Flutter, semua button bisa diklik, dokumentasi Play Store, dan PRD.
- Database/backend baru menjadi target pada UAS.

---

## 16. Future Backend Plan

Pada fase UAS, Aerobook dapat dikembangkan dengan dua opsi backend:

### Option A: Supabase

Use case:

- Cepat untuk prototype.
- Auth, database, storage, dan API tersedia dalam satu platform.
- Cocok untuk tugas kampus yang butuh implementasi backend lebih cepat.

Possible tables:

- `users`
- `venues`
- `courts`
- `court_schedules`
- `bookings`
- `payments`
- `notifications`
- `reviews`

### Option B: Laravel

Use case:

- Cocok jika ingin backend lebih custom.
- Cocok jika ingin membuat admin panel.
- Lebih fleksibel untuk business rules kompleks.

Possible modules:

- Auth API.
- Venue management.
- Court management.
- Booking API.
- Payment status API.
- Notification API.
- Admin dashboard.

Recommendation for UAS:

- Jika waktu terbatas, gunakan Supabase.
- Jika ingin nilai plus dari sisi backend custom, gunakan Laravel.

---

## 17. Open Items

Item yang perlu diselesaikan setelah PRD ini:

- Generate launcher icon final dari logo Aerobook.
- Ambil screenshot Play Store dari emulator/real device.
- Siapkan short description dan full description Play Store.
- Siapkan privacy policy sederhana.
- Perbaiki automated test agar sesuai flow terbaru.
- Pertimbangkan hapus dependency yang belum dipakai jika tidak diperlukan.

---

## 18. Final Notes

PRD ini menjadi acuan pengembangan Aerobook untuk fase UTS dan landasan pengembangan UAS. Versi UTS berfokus pada tampilan, pengalaman pengguna, navigasi, asset lokal, dan kesiapan internal testing. Versi UAS akan memperluas aplikasi menjadi sistem booking yang terhubung dengan backend dan database.
