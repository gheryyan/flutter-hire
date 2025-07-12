# Flutter Hire

📱 Aplikasi manajemen lowongan kerja berbasis Flutter — simple CRUD untuk lowongan dan manajemen akun rekruter.

---

## ✨ Deskripsi
Proyek ini adalah aplikasi Flutter sederhana yang memungkinkan rekruter untuk:
- Menambahkan, mengedit, dan menghapus lowongan kerja.
- Melihat daftar lowongan kerja yang sudah dibuat.
- Melihat dan mengedit profil rekruter.
- Logout dari akun.

Data saat ini masih disimpan secara **lokal (SQLite)**, belum terhubung ke backend atau API.

---

## 🔧 Tech Stack
- **Flutter** (Framework untuk aplikasi mobile multiplatform)
- **Dart** (Bahasa pemrograman)
- **SQLite** (via sqflite untuk penyimpanan lokal)
- **Shared Preferences** (untuk menyimpan data login)
- State Management: bawaan Flutter (StatefulWidget)

---

## 📋 Fitur
✅ CRUD (Create, Read, Update, Delete) Lowongan kerja  
✅ Profil Rekruter & Logout  
🚧 Rencana ke depan:
- ✨ Mahasiswa bisa login dan melamar lowongan.
- ✨ Notifikasi untuk lamaran masuk.
- ✨ Integrasi API untuk sinkronisasi data.

---

## 🚀 Cara Menjalankan
1 Clone repository ini:
```bash
git clone https://github.com/gheryyan/flutter-hire.git
2 Masuk ke folder proyek:

bash
Copy
Edit
cd flutter-hire
3 Install dependency:

bash
Copy
Edit
flutter pub get
4 Jalankan aplikasi:

bash
Copy
Edit
flutter run
