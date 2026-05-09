# Product Requirement Document (PRD)

## Aerobook - Aplikasi Mobile Booking Venue Olahraga

### Informasi Dokumen

| Item | Keterangan |
| --- | --- |
| Nama Produk | Aerobook |
| Jenis Produk | Aplikasi mobile booking venue olahraga |
| Platform Utama | Android |
| Framework | Flutter |
| Package ID Android | `com.ti24a6.app13` |
| Versi Saat Ini | `1.0.1+2` |
| Target Rilis | Google Play Console - Internal Testing |
| Scope Akademik | UTS: aplikasi tampilan/prototype tanpa database |
| Rencana Lanjutan | UAS: integrasi backend dan database |
| Status Data | Dummy data dan local assets |

---

## 1. Ringkasan Produk

Aerobook adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna menemukan venue olahraga, melihat detail fasilitas, memilih lapangan atau court, memilih jadwal, melakukan simulasi checkout, dan mendapatkan konfirmasi booking.

Pada versi UTS, Aerobook difokuskan sebagai aplikasi prototype yang menampilkan pengalaman booking secara lengkap dari awal sampai akhir. Aplikasi belum menggunakan database atau backend, tetapi seluruh halaman utama, navigasi, interaksi tombol, data dummy, dan asset visual sudah disusun agar menyerupai aplikasi booking yang siap dikembangkan ke tahap berikutnya.

Aerobook dibangun untuk menunjukkan bagaimana proses pemesanan lapangan dapat dibuat lebih praktis, terstruktur, dan mudah dipahami dibanding proses manual seperti bertanya melalui chat admin, mencatat jadwal secara manual, atau datang langsung ke venue.

---

## 2. Latar Belakang

Booking venue olahraga sering kali masih dilakukan secara manual. Pengguna harus mencari informasi venue dari berbagai sumber, bertanya ketersediaan jadwal kepada admin, lalu menunggu konfirmasi. Proses tersebut dapat memakan waktu dan membuat pengalaman booking terasa kurang efisien.

Selain itu, informasi penting seperti gambar lapangan, harga per jam, fasilitas, rating, dan status booking sering tidak tersedia dalam satu tampilan yang rapi. Pengguna membutuhkan aplikasi yang dapat menampilkan informasi tersebut secara jelas sebelum memutuskan untuk booking.

Aerobook hadir sebagai rancangan aplikasi mobile untuk menyederhanakan proses tersebut. Pada tahap UTS, aplikasi ini membuktikan alur pengalaman pengguna melalui tampilan dan interaksi. Pada tahap UAS, aplikasi dapat dikembangkan menjadi sistem dinamis yang terhubung ke backend dan database.

---

## 3. Problem Statement

Permasalahan utama yang ingin diselesaikan:

1. Pengguna sulit membandingkan venue karena informasi lokasi, harga, fasilitas, dan gambar tidak selalu tersusun rapi.
2. Proses memilih jadwal masih manual dan tidak memiliki visualisasi slot yang jelas.
3. Pengguna tidak selalu mendapatkan ringkasan booking sebelum melakukan pembayaran.
4. Aplikasi booking sederhana sering tidak menyediakan flow yang lengkap dari pencarian sampai konfirmasi sukses.
5. Untuk kebutuhan akademik, aplikasi perlu menunjukkan semua tombol dan alur utama dapat digunakan meskipun belum memakai database.

---

## 4. Tujuan Produk

### 4.1 Tujuan Utama

Membuat aplikasi mobile booking venue olahraga yang memberikan alur pemesanan lengkap, mudah dipahami, dan dapat diuji melalui Play Console Internal Testing.

### 4.2 Tujuan UTS

- Membuat aplikasi mobile dengan Flutter.
- Menghasilkan file `.aab` yang dapat diupload ke Google Play Console.
- Menyediakan UI yang merepresentasikan aplikasi booking venue olahraga.
- Memastikan semua tombol utama dapat diklik dan memiliki aksi.
- Menggunakan gambar lokal untuk venue, court, onboarding, avatar, logo, dan QR.
- Menyediakan dokumentasi PRD yang menjelaskan fitur, fungsi, tujuan, dan perilaku aplikasi.
- Menyiapkan kebutuhan dasar Play Store seperti package ID, app label, launcher icon, splash screen, dan internal testing build.

### 4.3 Tujuan UAS

- Menghubungkan aplikasi ke backend dan database.
- Mengubah dummy data menjadi data real.
- Menambahkan autentikasi user real.
- Menyimpan data booking secara persisten.
- Menyediakan validasi jadwal agar tidak terjadi bentrok booking.
- Menambahkan fitur admin atau pengelolaan venue jika diperlukan.

---

## 5. Target Pengguna

| Target Pengguna | Deskripsi | Kebutuhan Utama |
| --- | --- | --- |
| Pengguna kasual | Orang yang sesekali booking lapangan | Cari venue cepat, lihat harga, booking mudah |
| Mahasiswa atau komunitas | Kelompok yang bermain rutin | Pilih jadwal, lihat fasilitas, cek total biaya |
| Pemain olahraga rutin | Pengguna yang sering bermain badminton/tennis | Riwayat booking, rekomendasi venue, promo |
| Pengelola venue (fase UAS) | Admin yang mengelola lapangan | Kelola court, jadwal, harga, dan booking |

---

## 6. Ruang Lingkup Produk

### 6.1 Dalam Scope Versi UTS

Fitur yang termasuk dalam versi saat ini:

- Onboarding.
- Login dummy.
- Register dummy.
- Home dashboard.
- Search dan kategori olahraga.
- List venue.
- Detail venue.
- Detail court.
- Pemilihan jadwal.
- Checkout.
- Pemilihan metode pembayaran dummy.
- QR payment dummy.
- Payment success page.
- My Booking / riwayat booking.
- Notification page.
- Profile page.
- Local image assets.
- App label dan launcher icon Aerobook.
- Build `.aab` untuk internal testing.

### 6.2 Di Luar Scope Versi UTS

Fitur yang belum menjadi target versi saat ini:

- Database real.
- Backend/API real.
- Login/register real dengan server.
- Payment gateway.
- Push notification.
- Geolocation/maps real.
- Upload foto profil.
- Admin panel.
- Validasi jadwal antar banyak user secara real-time.

---

## 7. Asumsi dan Batasan

### 7.1 Asumsi

- Pengguna menggunakan perangkat Android.
- Aplikasi diuji melalui Google Play Console Internal Testing.
- Data venue, court, booking, dan notifikasi masih berasal dari dummy service.
- Koneksi internet tidak menjadi syarat utama untuk menampilkan data utama karena gambar dan data sudah lokal.
- Payment hanya simulasi dan tidak memproses uang real.

### 7.2 Batasan

- Data tidak tersimpan permanen setelah aplikasi ditutup.
- Status slot booking belum terhubung ke server.
- Aplikasi belum memiliki akun user real.
- QR payment hanya visual dummy.
- Review dan rating masih data simulasi.

---

## 8. User Journey Utama

Alur utama pengguna:

```text
Onboarding
-> Login / Register
-> Home
-> Browse Venue
-> Venue Detail
-> Court Detail
-> Select Time
-> Checkout
-> Payment
-> Payment Success
-> My Booking
```

Alur pendukung:

```text
Home -> Notification -> Lihat info promo/status booking
```

```text
Home -> Profile -> Lihat akun / menu profile / logout
```

---

## 9. Arsitektur Produk

### 9.1 Tech Stack

| Area | Teknologi |
| --- | --- |
| UI Framework | Flutter |
| Bahasa | Dart |
| State Management | Provider |
| Styling | `AppColors` dan `AppTheme` |
| Responsive Layout | `flutter_screenutil` |
| Local Data | Service class dummy |
| Image Handling | Local asset dan reusable image widget |
| Android Release | Android App Bundle (`.aab`) |

### 9.2 Struktur Layer

| Layer | Fungsi | Contoh |
| --- | --- | --- |
| Presentation Layer | Menampilkan halaman dan menerima input user | `lib/views`, `lib/widgets` |
| State Layer | Menyimpan state sementara aplikasi | `AuthProvider`, `AppDataProvider`, `BookingProvider` |
| Service Layer | Menyediakan data dummy | `GorService`, `BookingService` |
| Model Layer | Mendefinisikan struktur data | `VenueModel`, `BookingModel`, `UserModel` |
| Core Layer | Konfigurasi warna, theme, utility | `AppColors`, `AppTheme` |

---

## 10. Functional Requirements

### 10.1 Onboarding

**Tujuan:** Mengenalkan aplikasi kepada user sebelum masuk ke proses login/register.

**Fungsi:**

- Menampilkan branding awal Aerobook.
- Menampilkan visual onboarding dari local asset.
- Mengarahkan user ke halaman autentikasi.

**Perilaku:**

- Ketika user menekan tombol mulai, aplikasi berpindah ke halaman login atau register.
- Tampilan harus tetap rapi pada ukuran layar Android umum.
- Onboarding tidak membutuhkan data dari backend.

**Acceptance Criteria:**

- User dapat membuka halaman onboarding tanpa error.
- Tombol onboarding dapat diklik.
- Gambar onboarding tampil dari local asset.

---

### 10.2 Login

**Tujuan:** Memberikan simulasi akses masuk ke aplikasi.

**Fungsi:**

- Menerima input email.
- Menerima input password.
- Menampilkan toggle visibility password.
- Menyediakan aksi forgot password dummy.
- Menyediakan aksi Google login dummy.

**Perilaku:**

- Jika input valid, user diarahkan ke main screen.
- Jika input kosong atau tidak sesuai, aplikasi menampilkan validasi.
- Forgot password menampilkan dialog/informasi.
- Google login menampilkan feedback bahwa fitur akan tersedia pada versi backend.

**Acceptance Criteria:**

- Button login dapat diklik.
- Login dummy berhasil membawa user ke home.
- Text field dapat menerima input.
- Password dapat ditampilkan/disembunyikan.

---

### 10.3 Register

**Tujuan:** Memberikan simulasi pembuatan akun baru.

**Fungsi:**

- Menerima input nama, email, nomor telepon, dan password.
- Melakukan validasi input dasar.
- Membuat dummy user session.

**Perilaku:**

- Jika data valid, user dianggap berhasil register.
- Jika data tidak valid, aplikasi memberi feedback.
- Register tidak mengirim data ke server pada versi UTS.

**Acceptance Criteria:**

- Semua field dapat diisi.
- Button register memiliki aksi.
- Register berhasil memberikan feedback/navigasi sesuai flow.

---

### 10.4 Home Dashboard

**Tujuan:** Menjadi halaman utama untuk memulai eksplorasi venue.

**Fungsi:**

- Menampilkan greeting user.
- Menampilkan search bar.
- Menampilkan promo banner.
- Menampilkan kategori olahraga.
- Menampilkan venue recommended.
- Menampilkan venue nearby.
- Menyediakan akses ke halaman notifikasi dan profile.

**Perilaku:**

- User dapat memilih kategori olahraga.
- User dapat membuka detail venue.
- Promo/banner memberi feedback saat diklik.
- Jika data kosong, aplikasi menampilkan empty state yang informatif.

**Acceptance Criteria:**

- Home tampil setelah login.
- Venue recommended dan nearby muncul.
- Setiap kartu venue dapat diklik.
- Navigasi bottom bar bekerja.

---

### 10.5 Venue List

**Tujuan:** Menampilkan daftar venue agar user dapat membandingkan pilihan.

**Fungsi:**

- Menampilkan daftar venue dalam bentuk kartu.
- Menampilkan informasi utama venue: nama, lokasi, rating, harga, jarak, dan gambar.
- Mendukung filter berdasarkan kategori olahraga.

**Perilaku:**

- Tap pada venue membuka detail venue.
- Filter mengubah daftar venue yang tampil.
- Jika hasil filter kosong, user melihat empty state.

**Acceptance Criteria:**

- Daftar venue tampil dari dummy data.
- Filter/kategori dapat digunakan.
- Venue detail dapat dibuka dari list.

---

### 10.6 Venue Detail

**Tujuan:** Memberikan informasi lengkap tentang venue sebelum user memilih court.

**Fungsi:**

- Menampilkan gallery venue.
- Menampilkan nama, lokasi, rating, harga, fasilitas, dan deskripsi.
- Menampilkan review user dummy.
- Menampilkan daftar court yang tersedia.

**Data Venue Saat Ini:**

| Venue | Jenis Olahraga | Fungsi Dalam App |
| --- | --- | --- |
| Stadium Atelier | Badminton, Tennis | Venue utama dengan beberapa court |
| Grand Slam Arena | Tennis | Venue tennis dengan center court |
| The Smash Club | Badminton | Venue badminton untuk latihan dan sparring |

**Perilaku:**

- Gallery venue dapat dilihat oleh user.
- Court card dapat diklik untuk membuka court detail.
- Review ditampilkan sebagai data dummy dengan avatar lokal.

**Acceptance Criteria:**

- Detail venue tampil lengkap.
- Gambar venue tampil dari asset lokal.
- Court dapat dipilih.

---

### 10.7 Court Detail

**Tujuan:** Membantu user memilih lapangan dan jadwal booking.

**Fungsi:**

- Menampilkan gallery court.
- Menampilkan spesifikasi court.
- Menampilkan harga per jam.
- Menampilkan slot waktu.
- Menandai slot yang sudah booked.

**Perilaku:**

- Slot available dapat dipilih.
- Slot booked tidak dapat digunakan sebagai jadwal booking.
- Jika user menekan lanjut tanpa memilih jam, aplikasi memberi peringatan.
- Jika slot valid dipilih, user dapat lanjut ke checkout.

**Acceptance Criteria:**

- User dapat memilih jam tersedia.
- Slot booked memberikan feedback.
- Button lanjut bekerja sesuai kondisi.

---

### 10.8 Checkout

**Tujuan:** Memberikan ringkasan booking sebelum user masuk ke pembayaran.

**Fungsi:**

- Menampilkan detail venue.
- Menampilkan court yang dipilih.
- Menampilkan tanggal dan jam.
- Menampilkan total harga.
- Menampilkan pilihan metode pembayaran dummy.

**Perilaku:**

- User dapat memilih metode pembayaran.
- Total harga ditampilkan dalam format Rupiah.
- Button lanjut membawa user ke payment page.

**Acceptance Criteria:**

- Ringkasan booking tampil jelas.
- Metode pembayaran dapat dipilih.
- User dapat lanjut ke payment.

---

### 10.9 Payment

**Tujuan:** Mensimulasikan proses pembayaran.

**Fungsi:**

- Menampilkan QR payment dummy.
- Menampilkan ringkasan pembayaran.
- Menyediakan aksi konfirmasi pembayaran.

**Perilaku:**

- User melihat QR sebagai instruksi simulasi pembayaran.
- Setelah konfirmasi, user diarahkan ke payment success.
- Tidak ada transaksi uang real.

**Acceptance Criteria:**

- QR tampil dari local asset.
- Button pembayaran dapat diklik.
- User dapat mencapai halaman success.

---

### 10.10 Payment Success

**Tujuan:** Memberikan bukti bahwa proses booking selesai.

**Fungsi:**

- Menampilkan status booking berhasil.
- Menampilkan ringkasan booking.
- Menyediakan navigasi ke home atau my booking.

**Perilaku:**

- Setelah pembayaran dummy, booking dianggap berhasil.
- Aplikasi memberi feedback visual.
- User dapat melanjutkan ke halaman lain.

**Acceptance Criteria:**

- Halaman success tampil setelah payment.
- Informasi booking terbaca jelas.
- Navigasi setelah success bekerja.

---

### 10.11 My Booking / History

**Tujuan:** Menampilkan booking user.

**Fungsi:**

- Menampilkan booking aktif/upcoming.
- Menampilkan booking selesai/completed.
- Menampilkan informasi venue, court, tanggal, jam, dan status.

**Perilaku:**

- Booking dummy tampil sebagai data awal.
- Booking baru dari flow payment dapat ditambahkan ke session app.
- Jika tidak ada data, aplikasi menampilkan empty state.

**Acceptance Criteria:**

- Halaman booking dapat dibuka.
- Booking aktif dan riwayat dapat dibedakan.
- Informasi booking mudah dibaca.

---

### 10.12 Notification

**Tujuan:** Menampilkan informasi terkait promo, reminder, dan booking.

**Fungsi:**

- Menampilkan daftar notifikasi.
- Membedakan tipe notifikasi booking, promo, dan reminder.
- Menampilkan status unread/read jika tersedia.

**Perilaku:**

- Notifikasi berasal dari dummy data.
- Saat booking berhasil, aplikasi dapat menambahkan notifikasi dummy.

**Acceptance Criteria:**

- Halaman notifikasi tampil.
- Data notifikasi muncul.
- Empty state tersedia jika tidak ada notifikasi.

---

### 10.13 Profile

**Tujuan:** Menampilkan informasi akun dan menu pendukung.

**Fungsi:**

- Menampilkan avatar user.
- Menampilkan nama, email, points, dan wallet dummy.
- Menampilkan menu profile seperti edit profile, payment method, support, dan settings.
- Menyediakan logout.

**Perilaku:**

- Menu dummy memberi feedback melalui dialog atau snackbar.
- Logout menghapus dummy session dan mengarahkan user keluar dari main flow.

**Acceptance Criteria:**

- Profile dapat dibuka.
- Menu profile dapat diklik.
- Logout bekerja.

---

## 11. Data Requirements

### 11.1 User

Data user minimal:

- `id`
- `name`
- `email`
- `phone`
- `avatarUrl`
- `walletBalance`
- `points`

### 11.2 Venue

Data venue minimal:

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

### 11.3 Court

Data court minimal:

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

### 11.4 Booking

Data booking minimal:

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

### 11.5 Notification

Data notification minimal:

- `id`
- `title`
- `subtitle`
- `timeLabel`
- `type`
- `isUnread`

---

## 12. Business Rules

Aturan perilaku aplikasi:

1. User harus melewati login/register dummy sebelum masuk ke main app.
2. Venue dapat dibuka dari home atau venue list.
3. User harus memilih court sebelum masuk ke court detail.
4. User harus memilih slot waktu yang available sebelum checkout.
5. Slot yang booked tidak boleh dipakai untuk booking.
6. Total harga mengikuti harga court per jam dan durasi yang dipilih.
7. Payment pada versi UTS hanya simulasi.
8. Setelah payment dummy berhasil, aplikasi menampilkan payment success.
9. Booking berhasil dapat ditambahkan ke session app.
10. Semua tombol utama harus memberi aksi berupa navigasi, snackbar, dialog, atau perubahan state.

---

## 13. UI/UX Requirements

### 13.1 Prinsip Desain

- Tampilan bersih, modern, dan mudah dipahami.
- Warna mengikuti konfigurasi `AppColors`.
- Typography dan komponen mengikuti `AppTheme`.
- Gambar venue dan court menjadi elemen penting untuk membantu user mengambil keputusan.
- Setiap aksi user harus memiliki feedback.
- Layout harus nyaman digunakan di layar Android.

### 13.2 Komponen Wajib

- Button utama.
- Input field.
- Search bar.
- Venue card.
- Court card.
- Category/filter chip.
- Payment method selector.
- Empty state.
- Snackbar/dialog feedback.
- Bottom navigation.

### 13.3 Error dan Empty State

Aplikasi harus menampilkan feedback jika:

- Input login/register kosong.
- User belum memilih slot waktu.
- User memilih slot yang booked.
- Data list kosong.
- Fitur belum tersedia karena masih dummy.

---

## 14. Asset Requirements

| Asset Group | Path | Kegunaan |
| --- | --- | --- |
| Avatar | `assets/Avatar/` | Avatar user dan QR dummy |
| Venue | `assets/images/Venue/` | Gambar venue dan fasilitas |
| Court | `assets/images/Court/` | Gambar court badminton dan tennis |
| Onboarding | `assets/images/onBoarding/` | Visual onboarding |
| Logo | `assets/logos/` | Logo app, splash, launcher icon |

Requirement asset:

- Semua gambar utama harus berasal dari local asset.
- Path asset harus terdaftar di `pubspec.yaml`.
- Asset tidak boleh bergantung pada URL eksternal.
- Nama file sebaiknya konsisten agar mudah dipetakan ke data dummy.
- Logo harus tampil sebagai launcher icon dan splash screen.

---

## 15. Non-Functional Requirements

| Requirement | Target |
| --- | --- |
| Performance | App terasa ringan dan tidak lambat pada perangkat Android umum |
| Reliability | Tidak ada missing asset pada flow utama |
| Usability | User dapat memahami flow booking tanpa instruksi tambahan |
| Maintainability | Struktur kode modular dan mudah dikembangkan |
| Responsiveness | UI tetap rapi pada berbagai ukuran layar |
| Offline Readiness | Data dummy dan asset lokal tetap tampil tanpa koneksi internet |
| Build Quality | `flutter analyze` harus bersih |
| Release Readiness | AAB release berhasil dibuat, signed, dan dapat diupload ke Play Console |

---

## 16. Release Requirements

### 16.1 Android Internal Testing

| Item | Value |
| --- | --- |
| App Label | Aerobook |
| Package ID | `com.ti24a6.app13` |
| Version Name | `1.0.1` |
| Version Code | `2` |
| Format Build | `.aab` |
| Track | Internal Testing |
| Signing | Release signing dengan upload keystore |

### 16.2 Dokumen dan Materi Play Store

Materi yang perlu disiapkan:

- App name: Aerobook.
- App icon.
- Screenshot aplikasi.
- Short description.
- Full description.
- Data safety form.
- Privacy policy jika diminta.
- Tester list atau email tester.
- File `.aab` terbaru.

### 16.3 Artifact Build

File AAB release:

```text
build/app/outputs/bundle/release/app-release.aab
```

---

## 17. Acceptance Criteria Keseluruhan

Aplikasi dianggap memenuhi kebutuhan UTS jika:

- Aplikasi dapat diinstall dan dibuka di Android.
- Nama app dan icon launcher tampil sebagai Aerobook.
- User dapat melewati onboarding.
- User dapat login/register dummy.
- User dapat melihat home dashboard.
- User dapat membuka venue list dan venue detail.
- User dapat membuka court detail.
- User dapat memilih slot waktu available.
- User dapat lanjut ke checkout.
- User dapat melakukan payment dummy.
- User dapat melihat payment success.
- User dapat membuka my booking, notification, dan profile.
- Semua button utama memiliki aksi.
- Tidak ada missing image pada flow utama.
- AAB dapat diupload ke Play Console Internal Testing.
- PRD menjelaskan fitur, fungsi, tujuan, dan perilaku aplikasi secara mendalam.

---

## 18. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi |
| --- | --- | --- |
| Asset hilang atau path salah | Gambar tidak tampil | Gunakan local asset yang terdaftar di `pubspec.yaml` |
| Version code sama saat upload ulang | Play Console menolak AAB | Naikkan version code sebelum build ulang |
| Keystore hilang | Sulit update app di Play Console | Backup `upload-keystore.jks` dan `key.properties` |
| Data dummy tidak persisten | Booking hilang setelah app restart | Jelaskan sebagai batasan UTS |
| Test otomatis belum sesuai flow terbaru | CI/testing gagal | Update test sesuai data dan flow terbaru |
| Backend belum tersedia | Fitur real belum bisa berjalan | Masukkan ke scope UAS |

---

## 19. Rencana Pengembangan UAS

Pada fase UAS, Aerobook dapat dikembangkan menjadi aplikasi yang terhubung ke backend dan database.

### 19.1 Opsi Backend: Supabase

Kelebihan:

- Cocok untuk pengembangan cepat.
- Menyediakan auth, database, storage, dan API.
- Mengurangi kebutuhan membuat backend dari nol.

Tabel yang dapat dibuat:

- `users`
- `venues`
- `courts`
- `court_schedules`
- `bookings`
- `payments`
- `notifications`
- `reviews`

### 19.2 Opsi Backend: Laravel

Kelebihan:

- Cocok untuk backend custom.
- Dapat dibuat admin panel.
- Lebih fleksibel untuk aturan bisnis kompleks.

Module yang dapat dibuat:

- Auth API.
- Venue API.
- Court API.
- Booking API.
- Payment status API.
- Notification API.
- Admin dashboard.

### 19.3 Rekomendasi

Jika target UAS mengejar implementasi cepat dan stabil, Supabase lebih cocok. Jika target UAS ingin menunjukkan kemampuan backend custom dan admin panel, Laravel lebih menarik.

---

## 20. Future Enhancement

Fitur yang dapat ditambahkan setelah versi UTS:

- Login/register real.
- Edit profile real.
- Search venue berbasis database.
- Filter berdasarkan lokasi, harga, rating, dan jenis olahraga.
- Maps integration.
- Jadwal court real-time.
- Payment gateway.
- Push notification.
- Review dan rating real.
- Favorite venue.
- Voucher/promo system.
- Admin panel untuk venue owner.

---

## 21. Kesimpulan

Aerobook adalah prototype aplikasi booking venue olahraga yang dirancang untuk memenuhi kebutuhan UTS berupa aplikasi mobile Flutter, dokumentasi Play Store, tombol yang dapat diklik, dan PRD. Aplikasi ini sudah memiliki flow utama yang lengkap dari onboarding hingga payment success.

Walaupun versi saat ini belum memakai backend dan database, struktur fitur dan data sudah disiapkan agar dapat dikembangkan pada fase UAS. Dengan demikian, Aerobook tidak hanya menjadi tampilan statis, tetapi juga rancangan produk yang memiliki arah pengembangan jelas menuju aplikasi booking yang lebih real dan dinamis.
