// lib/presentation/pages/siswa/beranda_siswa_page.dart
import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';

const _navy = Color(0xFF24326B);
const _teal = Color(0xFF2C8AA4);
const _starYellow = Color(0xFFFFB800);

class BerandaSiswaPage extends StatefulWidget {
  const BerandaSiswaPage({super.key});
  @override
  State<BerandaSiswaPage> createState() => _BerandaSiswaPageState();
}

class _BerandaSiswaPageState extends State<BerandaSiswaPage> {
  static const _nama = 'Mardhika Murni';
  static const _sesiTersisa = 5;
  static const _sesiTotal = 8;
  static const _sesiDigunakan = 3;
  // static const _hasWarning = true;
  // static const _warningCount = 1;
  // static const _warningMax = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _teal,
      bottomNavigationBar: SiswaBottomNav(currentIndex: 0, onTap: (i) {
        if (i == 1) Navigator.pushReplacementNamed(context, '/siswa/jadwal');
        if (i == 2) Navigator.pushReplacementNamed(context, '/siswa/laporan');
        if (i == 3) Navigator.pushReplacementNamed(context, '/siswa/profil');
      }),
      body: SafeArea(
        child: Column(children: [
          _buildAppBar(),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 16),
              // if (_hasWarning) ...[_buildWarningBanner(), const SizedBox(height: 12)],
              _buildKartuSesi(context),
              const SizedBox(height: 20),
              _buildMenuGrid(),
              const SizedBox(height: 24),
              _buildNotifikasiSection(),
              const SizedBox(height: 24),
              _buildRekomendasiSection(),
              const SizedBox(height: 32),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _buildAppBar() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(children: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 26), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
      const SizedBox(width: 16),
      IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 26), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
      const Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Row(mainAxisSize: MainAxisSize.min, children: [
          Text('Selamat datang ', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text('👋', style: TextStyle(fontSize: 13)),
        ]),
        const Text(_nama, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
    ]),
  );

  // Widget _buildWarningBanner() => Container(
  //   margin: const EdgeInsets.symmetric(horizontal: 16),
  //   padding: const EdgeInsets.all(16),
  //   decoration: BoxDecoration(
  //     color: const Color(0xFFFFF8E1),
  //     borderRadius: BorderRadius.circular(14),
  //     border: Border.all(color: const Color(0xFFFFE082)),
  //   ),
  //   child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     const Text('⚠️', style: TextStyle(fontSize: 18)),
  //     const SizedBox(width: 10),
  //     Expanded(child: RichText(text: TextSpan(
  //       style: const TextStyle(fontSize: 13, color: Color(0xFF92400E), height: 1.5),
  //       children: [
  //         TextSpan(text: 'Peringatan ($_warningCount/$_warningMax)\n', style: const TextStyle(fontWeight: FontWeight.w700)),
  //         const TextSpan(text: 'Anda telah menerima 1 peringatan.\nJika mencapai 3 peringatan, akun akan '),
  //         const TextSpan(text: 'disuspend selama 7 hari', style: TextStyle(fontWeight: FontWeight.w700)),
  //         const TextSpan(text: '.\nMohon gunakan platform sesuai ketentuan.'),
  //       ],
  //     ))),
  //   ]),
  // );

  Widget _buildKartuSesi(BuildContext context) {
    final progress = _sesiDigunakan / _sesiTotal;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Paket Tersisa', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text('$_sesiTersisa', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1)),
          const SizedBox(width: 4),
          Text('/$_sesiTotal', style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
        ]),
        Align(alignment: Alignment.centerRight, child: Text('Total: $_sesiTotal', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(
          value: progress, 
          minHeight: 10,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(_navy),
        )),
        const SizedBox(height: 14),
        
        // TOMBOL DENGAN NAVIGASI
        SizedBox(
          width: double.infinity, 
          height: 46, 
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/siswa/beli-paket');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _navy, 
              foregroundColor: Colors.white, 
              elevation: 0, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: const Text('Beli Paket', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _buildMenuGrid() {
    final items = [
      ('📚', 'Booking\n  ', '/siswa/booking/pilih-kategori'),
      ('🕐', 'Riwayat\nSesi', '/siswa/riwayat-sesi'),
      ('⭐', 'Riwayat\nUlasan Tutor', '/siswa/ulasan-tutor'),
      ('💳', 'Riwayat\nPembayaran', '/siswa/riwayat-pembayaran'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final w = (MediaQuery.of(context).size.width - 32 - 24) / 4;
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, item.$3),
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(item.$1, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 8),
                Text(item.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.3)),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotifikasiSection() {
    final notifs = [
      (Icons.access_time_rounded, 'Sesi dimulai 1 jam lagi', 'Matematika dengan Ibu Sarah pukul 14:00', '13:00'),
      (Icons.calendar_month_rounded, 'Booking diterima', 'Pak Ahmad menerima booking fisika anda', 'Kemarin'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Notifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          GestureDetector(onTap: () {}, child: const Row(children: [
            Text('Lihat semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
          ])),
        ]),
        const SizedBox(height: 12),
        ...notifs.map((n) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 38, height: 38,
                decoration: BoxDecoration(color: _teal.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
                child: Icon(n.$1, color: _teal, size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(n.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(n.$3, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ])),
              Text(n.$4, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ]),
          ),
        )),
      ]),
    );
  }

  Widget _buildRekomendasiSection() {
    final tutors = [
      ('Ibu Sarah', 'Matematika', 4.9, 127, '"Pengajar matematika dengan pengalaman lebih dari 3 tahun, fokus pada pemahaman konsep dan latihan soal efektif."', 'S'),
      ('Ibu Dewi', 'Fisika', 4.8, 98, '"Pengajar fisika dengan pengalaman lebih dari 3 tahun, fokus pada pemahaman konsep dan latihan soal efektif."', 'D'),
      ('Bapak Arief', 'Informatika', 4.8, 98, '"Pengajar informatika dengan pengalaman lebih dari 3 tahun, fokus pada pemahaman konsep algoritma dan latihan coding efektif."', 'D'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Rekomendasi Tutor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
          GestureDetector(onTap: () {}, child: const Row(children: [
            Text('Lihat semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
          ])),
        ],
      )),
      const SizedBox(height: 12),
      SizedBox(height: 200, child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: tutors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final t = tutors[i];
          return Container(
            width: 210, padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 48, height: 48,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(t.$6, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.grey.shade500))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(t.$2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: _starYellow, size: 13),
                    const SizedBox(width: 2),
                    Text('${t.$3}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    Text('  (${t.$4} ulasan)', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  ]),
                ])),
              ]),
              const SizedBox(height: 8),
              Text(t.$5, maxLines: 3, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600, height: 1.5, fontStyle: FontStyle.italic)),
            ]),
          );
        },
      )),
    ]);
  }
}