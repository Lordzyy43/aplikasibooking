# 📘 Product Requirement Document (PRD)

## Aerobook — Premium Venue Reservation Platform

---

## 🧭 1. Product Overview

**ApkBooking** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memfasilitasi proses **pencarian, pemesanan, dan pengelolaan venue olahraga (GOR)** dalam satu sistem terintegrasi.

> 🎯 **Tujuan Utama**
>
> - Menyederhanakan proses booking venue
> - Mengurangi friksi dalam pencarian jadwal
> - Memberikan pengalaman pengguna yang cepat, intuitif, dan efisien

---

## ❗ 2. Problem Statement

Pengguna saat ini menghadapi beberapa kendala utama:

- ❌ Sulit menemukan venue terdekat dengan informasi yang jelas
- ❌ Proses booking masih manual dan tidak efisien
- ❌ Tidak ada sistem tracking booking yang terpusat

---

## 💡 3. Solution Approach

ApkBooking menghadirkan solusi berbasis sistem terintegrasi:

- 🔍 **Discovery System** → Pencarian venue berdasarkan kategori & lokasi
- 📅 **Booking System** → Alur pemesanan terstruktur dan mudah
- 💳 **Payment Simulation** → Representasi proses pembayaran
- 📊 **Booking Tracking** → Monitoring status booking user

---

## 🧱 4. Technical Architecture

### ⚙️ Core Stack

- Flutter SDK (UI Framework)
- Provider (State Management)

### 🧩 Struktur Layer

- **Presentation Layer** → UI & reusable widgets
- **State Layer** → Provider (auth, booking, app data)
- **Service Layer** → API abstraction (booking_service, gor_service)
- **Model Layer** → Entity (user, venue, booking, category, dll)

---

## 🚀 5. Feature & Functional Requirements

### 🔐 5.1 Authentication & Onboarding

Fitur:

- Onboarding untuk pengenalan aplikasi
- Login & Register user

Perilaku sistem:

- ⚠️ Input kosong → validasi muncul
- ❌ Login gagal → tampilkan error message
- ✅ Login berhasil → redirect ke Home

---

### 🔎 5.2 Discovery & Venue Exploration

Fitur:

- Home dashboard (header, search bar, promo banner)
- Filter berdasarkan kategori olahraga
- Daftar venue:
  - 📍 Nearby
  - ⭐ Recommended

Perilaku sistem:

- 🔄 Loading → tampilkan skeleton/loading indicator
- 📭 Data kosong → tampilkan empty state
- 🔍 Search → hasil filtering secara dinamis

---

### 🏟️ 5.3 Venue Detail & Exploration

Fitur:

- Detail informasi venue
- Daftar lapangan (court)

Perilaku:

- 📸 Gallery menggunakan carousel
- ℹ️ Informasi mencakup harga, fasilitas, dan lokasi

---

### 📅 5.4 Booking System (Core Feature)

#### 🔁 Alur Booking:

```
Home → Venue Detail → Court Detail → Checkout → Payment → Success
```

#### Input wajib:

- Tanggal
- Waktu
- Durasi

#### Perilaku sistem:

- 💰 Harga dihitung otomatis
- ❌ Slot tidak tersedia → tidak bisa dipilih
- ⚠️ Input tidak lengkap → tombol disabled

---

### 💳 5.5 Payment Simulation

Fitur:

- Pemilihan metode pembayaran (dummy)

Perilaku:

- Setelah submit → redirect ke halaman sukses
- Tidak ada transaksi real (simulation only)

---

### 📂 5.6 Booking Management

User dapat:

- Melihat booking aktif
- Melihat riwayat booking

Status:

- ⏳ Pending
- ✅ Completed

---

### 🔔 5.7 Notification System

Fitur:

- Informasi promo
- Update status booking

Perilaku:

- Tidak real-time (static/mock data)

---

### 👤 5.8 Profile Management

Fitur:

- Mengelola data user
- Preferensi aplikasi

---

## 🎨 6. UI/UX & Component Behavior

### 🎯 Design Principles

- Minimal friction (booking cepat)
- Konsistensi desain
- Feedback di setiap aksi

### ⚙️ Component Behavior

- 🔘 Button → disabled jika input belum valid
- 🔄 Loading → menggunakan shimmer/loading state
- ❌ Error → ditampilkan inline (tidak mengganggu UX)

---

## 🗺️ 7. User Journey

```
Onboarding → Login → Home → Search → Filter →
Venue Detail → Court → Checkout → Payment → Success → My Booking
```

Perilaku tambahan:

- 🔁 State tersimpan selama session aktif
- 🔙 Navigasi konsisten antar halaman

---

## 📦 8. Non-Functional Requirements

- ⚡ Performance → load < 2 detik
- 📱 Responsiveness → mendukung berbagai ukuran layar
- 🧩 Maintainability → struktur modular
- 📈 Scalability → siap integrasi backend real

---

## 📲 9. Deployment Requirements

- App Icon sesuai branding

- Screenshot:
  - Home
  - Detail Venue
  - Checkout
  - Profile

- ✅ Semua navigasi berjalan tanpa error

---

## ⚠️ 10. Limitations & Constraints

- Data masih dummy (belum real API)
- Belum ada concurrency handling
- Payment belum terintegrasi gateway

---

## 🧠 Final Notes

Dokumen ini merupakan **panduan utama pengembangan ApkBooking**, mencakup:

- Tujuan aplikasi
- Fitur dan fungsi
- Perilaku sistem
- Alur pengguna

Dokumen ini digunakan sebagai referensi oleh developer, designer, dan reviewer dalam proses pengembangan aplikasi.

---
