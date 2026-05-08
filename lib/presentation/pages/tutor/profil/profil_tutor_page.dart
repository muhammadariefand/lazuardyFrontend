// lib/presentation/pages/tutor/profil_tutor_page.dart
// Profil Tutor — view-only
// Perbedaan vs Profil Siswa:
//   + Field "Pilih Bank" dan "Nomor Rekening" di Detail Pribadi
//   - Tidak ada field "Kelas" (khusus siswa)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);

class ProfilTutorPage extends StatelessWidget {
  const ProfilTutorPage({super.key});

  // ── Data dummy — ganti dengan data dari Cubit ─────────────────
  static const _namaAkun  = 'Sarah Aulia Putri';
  static const _email     = 'sarahauliaputri@gmail.com';
  static const _wa        = '089505087870';
  static const _inisial   = 'S';

  static const _detailPribadi = [
    _FieldView('Nama Lengkap',  'Sarah Nur Aisyah'),
    _FieldView('Jenis Kelamin', 'Perempuan'),
    _FieldView('Tanggal Lahir', '25/08/1995'),
    _FieldView('Nomor WhatsApp','089505086860'),
    _FieldView('Pilih Bank',    'Mandiri'),
    _FieldView('Nomor Rekening','1234567890'),
  ];

  static const _detailAlamat = [
    _FieldView('Provinsi',        'DI Yogyakarta'),
    _FieldView('Kota/Kabupaten',  'Kab. Sleman'),
    _FieldView('Kecamatan',       'Depok'),
    _FieldView('Desa/Kelurahan',  'Caturtunggal'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/tutor/jadwal');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutor/konfirmasi-booking');
        },
      ),
      body: Column(children: [
        // ── Teal header ─────────────────────────────────────────
        Container(
          color: _teal,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Profil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ),

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const SizedBox(height: 8),

            // ── Kartu header user ────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _teal.withOpacity(0.4)),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 8)],
              ),
              child: Row(children: [
                // Avatar lingkaran
                Container(
                  width: 64, height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB2EBF2), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(_inisial,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w700,
                          color: _navy)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(_namaAkun,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const Text(_email,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Text(_wa,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  // Tombol Edit Profil
                  SizedBox(
                    width: 110, height: 32,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/tutor/edit-profil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Edit Profil',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ])),
              ]),
            ),

            const SizedBox(height: 16),

            // ── Detail Pribadi ───────────────────────────────────
            _buildSection('Detail Pribadi', _detailPribadi),
            const SizedBox(height: 16),

            // ── Detail Alamat ────────────────────────────────────
            _buildSection('Detail Alamat', _detailAlamat),
            const SizedBox(height: 24),
          ]),
        )),
      ]),
    );
  }

  Widget _buildSection(String title, List<_FieldView> fields) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4)),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        ...fields.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.label,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(f.value,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary)),
            ),
          ]),
        )),
      ]),
    );
  }
}

class _FieldView {
  final String label, value;
  const _FieldView(this.label, this.value);
}