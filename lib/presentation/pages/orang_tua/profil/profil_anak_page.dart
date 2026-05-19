// lib/presentation/pages/orangtua/profil_anak_page.dart
// Image 6: Profil Anak
// - AppBar teal "Profil Anak"
// - Card header: avatar lingkaran + nama + email + no hp
// - Card "Detail Pribadi": Nama Lengkap, Kelas, Jenis Kelamin,
//   Tanggal Lahir, Nomor WhatsApp — semua read-only field
// - Card "Detail Alamat": Provinsi, Kota/Kabupaten, (dst)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class ProfilAnakPage extends StatelessWidget {
  const ProfilAnakPage({super.key});

  // ── Dummy data ─────────────────────────────────────────────────
  static const _namaLengkap    = 'Mardhika Murni Pramestika';
  static const _email          = 'mardhikatika@gmail.com';
  static const _noHp           = '089505086860';
  static const _kelas          = '3 SMA';
  static const _jenisKelamin   = 'Perempuan';
  static const _tanggalLahir   = '20/08/2005';
  static const _provinsi       = 'DI Yogyakarta';
  static const _kotaKabupaten  = 'Sleman';
  static const _kecamatan      = 'Ngaglik';
  static const _kelurahan      = 'Sumberrejo';
  static const _alamatLengkap  =
      'Jl. Melati Indah No. 24, RT 03/RW 05';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orangtua/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/orangtua/jadwal');
          if (i == 2) Navigator.pushReplacementNamed(context, '/orangtua/laporan');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── Card Header ─────────────────────────────
                  _buildHeaderCard(),
                  const SizedBox(height: 14),

                  // ── Card Detail Pribadi ──────────────────────
                  _buildSectionCard(
                    title: 'Detail Pribadi',
                    fields: [
                      _FieldItem('Nama Lengkap', _namaLengkap),
                      _FieldItem('Kelas', _kelas),
                      _FieldItem('Jenis Kelamin', _jenisKelamin),
                      _FieldItem('Tanggal Lahir', _tanggalLahir),
                      _FieldItem('Nomor WhatsApp', _noHp),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Card Detail Alamat ───────────────────────
                  _buildSectionCard(
                    title: 'Detail Alamat',
                    fields: [
                      _FieldItem('Provinsi', _provinsi),
                      _FieldItem('Kota/Kabupaten', _kotaKabupaten),
                      _FieldItem('Kecamatan', _kecamatan),
                      _FieldItem('Kelurahan', _kelurahan),
                      _FieldItem('Alamat Lengkap', _alamatLengkap),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: _teal,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Profil Anak',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Card Header ───────────────────────────────────────────────
  Widget _buildHeaderCard() {
    return _cardWrapper(
      child: Row(
        children: [
          // Avatar lingkaran
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFCFE3F3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _teal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _namaLengkap,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _email,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                SizedBox(height: 2),
                Text(
                  _noHp,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Section dengan list field ───────────────────────────
  Widget _buildSectionCard({
    required String title,
    required List<_FieldItem> fields,
  }) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...fields.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFieldRow(f.label, f.value),
              )),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDDDDDD)),
          ),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  // ── Shared ────────────────────────────────────────────────────
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _teal.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldItem {
  final String label;
  final String value;
  const _FieldItem(this.label, this.value);
}