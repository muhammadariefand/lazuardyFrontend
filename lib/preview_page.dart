// import 'package:flutter/material.dart';
// // Import file halaman kamu
// import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_alamat_siswa_page.dart';
// // Import theme agar tampilannya tidak berantakan
// import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

// void main() {
//   runApp(const TestAlamatApp());
// }

// class TestAlamatApp extends StatelessWidget {
//   const TestAlamatApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Menggunakan theme asli projectmu agar komponen widget terlihat benar
//       theme: AppTheme.lightTheme, 
//       home: const DetailAlamatPage(),
//       // Tambahkan route dummy jika kamu ingin mengetes tombol "Selanjutnya"
//       routes: {
//         '/otp': (context) => const Scaffold(body: Center(child: Text('Halaman OTP'))),
//       },
//     );
//   }
// }