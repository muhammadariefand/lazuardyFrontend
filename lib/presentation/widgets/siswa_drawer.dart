// lib/presentation/widgets/siswa_drawer.dart
// Drawer kiri — avatar, nama, 3 menu, footer versi
// + Dialog konfirmasi keluar (Image 4)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';

const _teal = Color(0xFF3AAFA9);
const _navy = Color(0xFF1E2D7D);

class SiswaDrawer extends StatelessWidget {
  final String nama;
  final String inisial;

  const SiswaDrawer({
    super.key,
    this.nama = 'Mardhika Murni Pramestika',
    this.inisial = 'M',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tombol tutup ────────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.textPrimary),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Avatar + nama ────────────────────────────────────
            Center(
              child: Column(children: [
                Container(
                  width: 80, height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB2EBF2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(inisial,
                      style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: _navy)),
                ),
                const SizedBox(height: 12),
                Text(nama,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ]),
            ),

            const SizedBox(height: 32),

            // ── Menu items ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                _MenuItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Hubungi Kami',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/hubungi-kami');
                  },
                ),
                const SizedBox(height: 12),
                _MenuItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Tentang Kami',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/tentang-kami');
                  },
                ),
                const SizedBox(height: 12),
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Keluar',
                  onTap: () => _showLogoutDialog(context),
                ),
              ]),
            ),

            const Spacer(),

            // ── Footer versi ─────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  'Lazuardy v1.0 · © 2026',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog konfirmasi keluar ─────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
            'Apakah Anda yakin ingin\nkeluar dari akun ini?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Semua sesi Anda akan\nberakhir setelah keluar.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(children: [
            // Tombol Batal
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Batal',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Ya, Keluar
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);   // tutup dialog
                  Navigator.pop(context); // tutup drawer
                  // TODO: panggil AuthCubit.logout()
                  // context.read<AuthCubit>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Ya, Keluar',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ── Menu item row ─────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
        ),
        child: Row(children: [
          Icon(icon, size: 22, color: AppColors.textPrimary),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textPrimary)),
        ]),
      ),
    );
  }
}