# Latihan Responsi Pemrograman Mobile: Aplikasi Harry Potter
**NIM:** 124240180  
**Framework:** Flutter (Dart)

Aplikasi mobile Harry Potter dengan fitur autentikasi (SharedPreferences), pemanggilan REST API (Characters & Spells), penyimpanan lokal favorit (Hive), dan notifikasi lokal (Immediate Notification via `flutter_local_notifications`).

---

## Fitur & Pemenuhan Kriteria

### 1. Halaman Login View (20 pts)
- **Hardcoded Login:** Logika validasi username dan password.
  - Akun demo:
    - Username: `124240180` | Password: `124240180`
- **Session Management:** Status login dan username disimpan ke `SharedPreferences`.
- **Auto-Login:** Saat aplikasi dibuka, jika session login masih tersimpan, langsung diarahkan ke halaman Karakter.
- **SnackBar Notifikasi (Top Position):** Menampilkan SnackBar floating di bagian atas layar (dengan swipe-to-dismiss ke atas) saat login berhasil atau gagal.
- **Navigasi:** Masuk ke Character View saat login sukses.

### 2. Halaman Character View & Detail Character (20 pts)
- **Data dari API:** Mengambil data karakter dari endpoint `https://potterapi-fedeperin.vercel.app/en/characters`.
- **List Karakter:** Menampilkan thumbnail karakter, nama lengkap, nama panggilan (nickname), asrama Hogwarts dengan warna khas, dan aktor pemeran.
- **Pencarian & Filter:** Tersedia kotak pencarian nama/aktor dan filter asrama (All, Gryffindor, Slytherin, Ravenclaw, Hufflepuff).
- **Halaman Detail Karakter:** Menampilkan seluruh properti karakter:
  - Foto Karakter (Hero/Header)
  - Index ID
  - Nama Lengkap (`fullName`)
  - Nama Panggilan (`nickname`)
  - Asrama Hogwarts (`hogwartsHouse`)
  - Pemeran (`interpretedBy`)
  - Tanggal Lahir (`birthdate`)
  - Anak (`children`)
  - URL Gambar (`image`)

### 3. Halaman Spells View (20 pts)
- **Data dari API:** Mengambil data mantra/sihir dari endpoint `https://potterapi-fedeperin.vercel.app/en/spells`.
- **Tombol Favorit:** Tombol favorite dapat di-toggle untuk menambahkan atau menghapus mantra dari Hive Box.
- **SnackBar Feedback (Top Position):** Menampilkan SnackBar konfirmasi di bagian atas layar saat mantra berhasil ditambahkan atau dihapus dari favorit.
- **Navigasi Favorite:** Terdapat tombol navigasi pada AppBar menuju halaman **Favorite Spells View**.

### 4. Halaman Favorite Spells View (20 pts)
- **Penyimpanan Hive:** Menampilkan seluruh sihir yang telah ditambahkan ke favorit dari penyimpanan lokal Hive.
- **Hapus Favorit:** Pengguna dapat menghapus item dari daftar favorit.
- **Immediate Notification:** Ketika mantra favorit dihapus, aplikasi memicu notifikasi lokal secara langsung (*Immediate Notification*) menggunakan `flutter_local_notifications`.

### 5. Logout (20 pts)
- **Tombol Logout:** Tersedia di AppBar halaman Karakter dan Sihir (Spells).
- **Dialog Konfirmasi & SnackBar (Top Position):** Konfirmasi sebelum logout, menghapus session `SharedPreferences`, kembali ke Login View, dan menampilkan SnackBar floating di atas layar "Berhasil logout".

---

## Struktur Folder

```
lib/
├── main.dart
├── models/
│   ├── character_model.dart
│   └── spell_model.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── hive_service.dart
│   └── notification_service.dart
├── widgets/
│   └── top_snackbar.dart
└── views/
    ├── login_view.dart
    ├── main_navigation_view.dart
    ├── characters/
    │   ├── character_view.dart
    │   └── character_detail_view.dart
    └── spells/
        ├── spells_view.dart
        └── favorite_spells_view.dart
```

---

## Dependensi

- `http`: Pengambilan data API REST
- `shared_preferences`: Penyimpanan session login
- `hive` & `hive_flutter`: Penyimpanan lokal data spell favorit
- `flutter_local_notifications`: Immediate notification saat menghapus favorit

---

## Cara Menjalankan

1. Pastikan Flutter SDK sudah terpasang (`flutter doctor`).
2. Pasang dependensi:
   ```bash
   flutter pub get
   ```
3. Jalankan pengujian unit & widget:
   ```bash
   flutter test
   ```
4. Jalankan aplikasi pada perangkat/emulator:
   ```bash
   flutter run
   ```
