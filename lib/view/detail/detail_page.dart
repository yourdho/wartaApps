import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // untuk back button
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logos_warta.png',
          height: 36,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gambar berita
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/barca.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Kategori
          const Text(
            'OLAHRAGA',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),

          // Judul
          const Text(
            'STY Sebut Pemain Lelah, Pastikan Rotasi di Indonesia vs Laos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Sumber dan waktu
          const Text(
            'CNN Indonesia • Rabu, 11 Des 2024 - 18:22 WIB',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Isi berita
          const Text(
            '''Jakarta, CNN Indonesia – Pelatih Timnas Indonesia, Shin Tae Yong menyebut dirinya akan merotasi pemain saat menghadapi Laos pada laga terakhir grup Piala AFF 2024 di Stadion Manahan, Solo pada Kamis (12/12) pukul 20.00 WIB.

Jadwal Indonesia vs Laos akan berlangsung di Stadion Manahan, Solo. Meskipun semua pemain siap bertanding, STY ingin menjaga kebugaran pemain dengan merotasi tim.

“Kami akan mencoba untuk lebih segar, saya akan berusaha untuk merotasi pemain agar tidak kelelahan, sebab ini fase-fase yang ketat,” kata STY dalam jumpa pers, Rabu (11/12).

STY juga menilai performa pemain muda cukup menjanjikan, namun ia tetap akan menyusun tim utama dengan pengalaman.

Timnas Indonesia membutuhkan tiga poin pada laga ini demi memastikan posisi teratas grup A dan menghindari tim kuat di babak semifinal Piala AFF 2024.

“Meski kami pemain muda, pola pikir dan mental harus lebih baik. Kami berikan yang terbaik untuk negara,” ujar Shin.

Laos sendiri saat ini berada di peringkat paling bawah klasemen sementara Grup A. Indonesia wajib menang agar bisa lolos dengan status juara grup dan menghindari Vietnam di semifinal.''',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 16),

          // Gambar tambahan
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/barca.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
