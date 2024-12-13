# RaeBook  

Aplikasi RaeBook adalah platform untuk membaca buku digital dengan berbagai fitur seperti katalog buku, pencarian, dan sistem bookmark. Aplikasi ini dikembangkan menggunakan Flutter untuk mendukung pengalaman pengguna yang mulus di perangkat Android dan iOS.  

## Fitur Utama  
- **Katalog Buku**  
  Jelajahi koleksi buku digital yang tersedia berdasarkan kategori atau genre.  
- **Pencarian Buku**  
  Cari buku berdasarkan judul tertentu.  
- **Pembaca Buku Bawaan**  
  Nikmati pengalaman membaca langsung di aplikasi.  
- **Bookmark dan Catatan**  
  Simpan halaman favorit atau tambahkan catatan untuk referensi di masa depan. 

## Instalasi  
### Prasyarat  
Pastikan Anda telah menginstal:  
- Flutter SDK ([Panduan Instalasi Flutter](https://flutter.dev/docs/get-started/install))  
- Android Studio atau Xcode untuk emulasi perangkat.  

### Langkah Instalasi  
1. **Clone repositori ini**  
   ```bash
   git clone https://github.com/reynaldiarya/RaeBook.git
   cd RaeBook
   ```

2. **Instal Dependensi**  
   Jalankan perintah berikut untuk menginstal semua paket yang diperlukan:  
   ```bash
   flutter pub get
   ```

3. **Konfigurasi API**  
   - Pastikan backend API Anda berjalan dengan baik. Proyek backend dapat ditemukan di repositori berikut: [RaeBook-Backend](https://github.com/reynaldiarya/RaeBook-Backend).  
   - Jalankan server backend dengan mengikuti panduan di repositori tersebut.  
   - Setelah backend berjalan, perbarui file konfigurasi `lib/src/api.dart` aplikasi Flutter Anda untuk menggunakan URL API backend:  
     ```env
     static const String apiUrl = "domainanda";
     ```  
     - Ganti `domainanda` dengan URL server backend Anda jika menggunakan hosting atau IP publik.


4. **Jalankan Aplikasi**  
   Jalankan aplikasi di emulator atau perangkat fisik:  
   ```bash
   flutter run
   ```

## Lisensi  
Proyek ini dilisensikan di bawah MIT License. Lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.  

## Kontak  
Jika Anda memiliki pertanyaan atau umpan balik, silakan hubungi kami di **email@domain.com**.  
```

README ini mencakup deskripsi aplikasi, fitur utama, teknologi yang digunakan, langkah instalasi, dan informasi tambahan yang relevan untuk pengembang dan pengguna. Anda dapat menyesuaikan bagian-bagian tertentu seperti nama repositori atau fitur sesuai dengan kebutuhan proyek Anda.
