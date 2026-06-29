# Smoke Store & Smoke Money

* **Nama:** Sadam Irham Marami
* **NIM:** 1123150087
* **Kelas:** TIS SE P1
* **Mata Kuliah:** Pemrograman Mobile Lanjutan
* **Penilaian:** Ujian Akhir Semester (UAS) Semester 6 - Global Institute Bina Sarana Global

---

## 📌 Deskripsi Sistem

Sistem ini terdiri dari dua proyek aplikasi terintegrasi yang saling terhubung melalui mekanisme **Deep Linking (App Links)**:

1. **Store Smoke (`smoker-app-sadamirham`)**: Aplikasi e-commerce (toko) tempat pelanggan dapat memilih produk, memasukkannya ke dalam keranjang, dan melakukan proses checkout pesanan.
2. **Smoke Money (`project`)**: Aplikasi dompet digital (E-Money) bertindak sebagai penyedia pembayaran. Saat pelanggan memilih metode pembayaran "Smoke Money" di toko, aplikasi Smoke Money akan diluncurkan melalui skema deep link untuk memproses PIN, otentikasi biometrik, verifikasi 2FA, dan menyelesaikan transaksi.

---

## 🛠️ Arsitektur Proyek (Clean Architecture)

Aplikasi dibangun menggunakan prinsip **Clean Architecture** yang memisahkan kode ke dalam lapisan-lapisan yang independen dan mudah diuji (*testable*):

```
lib/
├── core/             # Konfigurasi aplikasi, utilitas global, rute (Routing), & tema (Theme)
├── data/             # Lapisan Data: DataSource (Local/Remote API), Model (JSON Parsing), & Implementasi Repositori
├── domain/           # Lapisan Bisnis: Entitas (Model Murni), Use Case, & Abstraksi Repositori (Kontrak)
├── presentation/     # Lapisan UI: Halaman (Pages), Komponen Visual (Widgets), & State Management (Bloc/Provider)
└── injection/        # Dependency Injection (DI) Setup menggunakan Service Locator
```

### 1. Data Layer (`data/`)
* **Data Sources**: Penghubung langsung ke API eksternal (Dio Client) atau penyimpanan lokal (`FlutterSecureStorage`).
* **Models**: Struktur data JSON parser yang mewakili respon API sebelum dipetakan menjadi Entitas bisnis.
* **Repositories (Implementation)**: Mengimplementasikan logika pemuatan data dari domain kontrak (menyambungkan DataSource ke Use Cases).

### 2. Domain Layer (`domain/`)
* **Entities**: Objek bisnis murni yang tidak bergantung pada framework/library luar.
* **Use Cases**: Logika bisnis spesifik aplikasi (contoh: *Topup*, *Transfer*, *Payment*, *Verify OTP*).
* **Repositories (Contracts)**: Interface penentu fungsi data yang dibutuhkan oleh domain.

### 3. Presentation Layer (`presentation/`)
* **State Management**: Mengelola perubahan status UI (menggunakan `flutter_bloc` / `Provider`).
* **Pages & Widgets**: Komponen visual penyusun antarmuka aplikasi.

---

## 🔗 Integrasi Pembayaran (Deep Linking)

Alur pembayaran antar aplikasi diintegrasikan secara mulus via custom scheme deep link:

* **Skema Pembayaran (`smokemoney://pay`)**:
  * Dipicu dari `Store Smoke` ke `Smoke Money` dengan parameter detail pesanan (`merchant_id`, `merchant_name`, `amount`, `reference`, dan `callback`).
  * Konfigurasi di Android dideklarasikan pada intent-filter berkas [AndroidManifest.xml](file:///home/nafisah/uas-sadam-1123150087/project/android/app/src/main/AndroidManifest.xml).
  
* **Skema Callback (`smokestore://callback`)**:
  * Dipicu dari `Smoke Money` kembali ke `Store Smoke` untuk mengirimkan status penyelesaian transaksi (`success`, `failed`, atau `cancelled`).

---

## 🚀 Cara Menjalankan Aplikasi

### Langkah 1: Jalankan Backend API
Pastikan kedua backend server (Go API) telah berjalan:
```bash
# Untuk backend Smoke Store
cd be-smoke-store
go run main.go

# Untuk backend Smoke Money
cd be-smoke-money
go run main.go
```

### Langkah 2: Jalankan Aplikasi Mobile (Flutter)
Jalankan aplikasi di perangkat emulator/fisik secara bersamaan:

```bash
# Jalankan aplikasi toko (Store Smoke)
cd smoker-app-sadamirham
flutter run

# Jalankan aplikasi dompet (Smoke Money)
cd project
flutter run
```
