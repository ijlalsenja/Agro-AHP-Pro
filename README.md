# Agro-AHP Pro: Microservices-Based Maintenance Decision System

**Nama:** Muhammad Ijlal Senja Pratama  
**NIM:** 206230010 
**Studi Kasus:** Pabrik Pengolahan Kakao  

---

## Deskripsi Proyek
Agro-AHP Pro adalah sistem pendukung keputusan (DSS) berbasis mobile yang membantu manajer pemeliharaan di pabrik pengolahan kakao untuk memprioritaskan perbaikan mesin secara matematis menggunakan metode AHP (Analytic Hierarchy Process). Sistem ini menggunakan arsitektur Client-Server untuk memisahkan komputasi berat (Python Backend) dan antarmuka pengguna (Flutter Frontend).

## Arsitektur Sistem
1.  **Backend (AHP Engine)**: Python Flask dan NumPy (di Google Colab) untuk perhitungan matriks dan Eigenvector.
2.  **Bridge**: GitHub Gist sebagai penyimpan konfigurasi URL dinamis (Ngrok).
3.  **Frontend**: Aplikasi Flutter sebagai dashboard visualisasi dan input data.

## Fitur Utama
*   **Input Pairwise Comparison**: Antarmuka slider 1-9 (Skala Saaty) yang intuitif.
*   **Real-time Calculation**: Perhitungan bobot prioritas dan Consistency Ratio (CR) di Cloud.
*   **Validasi Konsistensi**: Peringatan otomatis jika input user tidak konsisten (CR > 0.1).
*   **Visualisasi Hasil**: Grafik batang dan ranking prioritas mesin.

## Persiapan & Instalasi

### 1. Backend (Google Colab)
1.  Buka file `backend/ahp_engine.ipynb` di Google Colab.
2.  Jalankan semua cell (Runtime > Run all).
3.  Salin URL Ngrok yang muncul di output terakhir (contoh: `https://xxxx.ngrok-free.app`).

### 2. Konfigurasi (GitHub Gist)
1.  Buat [GitHub Gist](https://gist.github.com) baru bernama `config.json`.
2.  Isi dengan: `{"base_url": "URL_NGROK_ANDA"}`.
3.  Klik "Raw" dan salin URL-nya.
4.  Paste URL tersebut ke dalam kode Flutter di `lib/services/api_service.dart`.

### 3. Frontend (Flutter)
**PENTING**: Kode Flutter ada di dalam folder `frontend`.
**Cara Mudah:** Klik dua kali file `JALANKAN_APLIKASI.bat`.

**Cara Manual:**
1.  Buka terminal.
2.  Ketik `cd frontend` (Masuk ke folder frontend).
3.  Ketik `flutter run` (Jalankan aplikasi).
4.  Jika ingin build APK: `flutter build apk --release`.

## Masalah Umum (Troubleshooting)
*   **Error: No pubspec.yaml file found**: Anda belum masuk ke folder `frontend`. Ketik `cd frontend` dulu.
*   **Koneksi Error**: Cek apakah URL Ngrok di Gist sudah diupdate dengan yang terbaru dari Google Colab.
*   **Data Tidak Konsisten**: CR > 0.1 artinya input anda tidak logis secara matematis, silakan perbaiki slider.

## Link Penting
*   **Google Colab**: [Link Notebook](https://colab.research.google.com/...) *(Upload file ipynb anda dan share linknya)*
*   **GitHub Gist**: [Link Gist](https://gist.github.com/...)
*   **Demo Video**: [Link Video]

---
© 2024 Muhammad Ijlal Senja Pratama.



