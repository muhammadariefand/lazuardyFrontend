import 'package:flutter/material.dart';

class DummyBerandaPage extends StatelessWidget {
  // Variabel untuk membedakan ini beranda siapa (Siswa/Tutor/Orang Tua)
  final String roleTitle;

  const DummyBerandaPage({
    super.key, 
    required this.roleTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda $roleTitle'),
        backgroundColor: Colors.teal, // Menyesuaikan warna tema aplikasimu
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_rounded,
              size: 80,
              color: Colors.teal.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Selamat Datang, $roleTitle!',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ini adalah halaman beranda sementara untuk testing.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigasi kembali ke halaman login dan hapus riwayat halaman sebelumnya
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/login', 
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Keluar (Logout)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}