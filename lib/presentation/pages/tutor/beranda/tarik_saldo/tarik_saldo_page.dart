// lib/presentation/pages/tutor/tarik_saldo_page.dart
// Tarik Saldo (normal)
//   - Card saldo tersedia + info bank
//   - Card ajukan penarikan: input jumlah + tombol Tarik Saldo
//   - Banner info proses admin
//   - Riwayat Penarikan: list card (approved / rejected)
// Dialog sukses "Penarikan Diajukan"
//   - Icon centang hijau
//   - Judul + deskripsi
//   - Tombol "Kembali Ke Tarik Saldo"

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

// ── Model riwayat ─────────────────────────────────────────────────
enum StatusPenarikan { approved, pending, rejected }

class _RiwayatData {
  final int jumlah;
  final String tanggal;
  final StatusPenarikan status;

  const _RiwayatData({
    required this.jumlah,
    required this.tanggal,
    required this.status,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class TarikSaldoPage extends StatefulWidget {
  const TarikSaldoPage({super.key});

  @override
  State<TarikSaldoPage> createState() => _TarikSaldoPageState();
}

class _TarikSaldoPageState extends State<TarikSaldoPage> {
  final _jumlahCtrl = TextEditingController();
  bool _isLoading = false;

  // ── Dummy data ─────────────────────────────────────────────────
  static const _saldo       = 1200000;
  static const _namaBank    = 'Bank BCA';
  static const _noRekening  = '12345678900';

  static const _riwayatList = [
    _RiwayatData(
      jumlah: 500000,
      tanggal: '25 Maret 2026, 10:31',
      status: StatusPenarikan.approved,
    ),
    _RiwayatData(
      jumlah: 500000,
      tanggal: '24 Maret 2026, 16:39',
      status: StatusPenarikan.approved,
    ),
    _RiwayatData(
      jumlah: 500000,
      tanggal: '22 Maret 2026, 17:22',
      status: StatusPenarikan.rejected,
    ),
  ];

  @override
  void dispose() {
    _jumlahCtrl.dispose();
    super.dispose();
  }

  // ── Format Rupiah ─────────────────────────────────────────────
  String _rp(int v) {
    final s = v.toString();
    final b = StringBuffer('Rp ');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
    }
    return b.toString();
  }

  // ── Aksi tarik ────────────────────────────────────────────────
  Future<void> _tarikSaldo() async {
    final raw = int.tryParse(_jumlahCtrl.text.trim());
    if (raw == null || raw <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan jumlah penarikan yang valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (raw > _saldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah melebihi saldo tersedia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulate API
    if (!mounted) return;
    setState(() => _isLoading = false);

    _jumlahCtrl.clear();
    _showSuksesDialog();
  }

  // ── Dialog sukses (Image 3) ───────────────────────────────────
  void _showSuksesDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon centang hijau
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF2E7D32), width: 3),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF2E7D32),
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Penarikan Diajukan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Admin akan memproses penarikan Anda.\nStatus akan diupdate melalui notifikasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Tombol kembali
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kembali Ke Tarik Saldo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),

                  // ── Card Saldo ────────────────────────────────
                  _buildSaldoCard(),
                  const SizedBox(height: 14),

                  // ── Card Ajukan Penarikan ─────────────────────
                  _buildAjukanCard(),
                  const SizedBox(height: 14),

                  // ── Banner Info ───────────────────────────────
                  _buildInfoBanner(),
                  const SizedBox(height: 24),

                  // ── Riwayat Penarikan ─────────────────────────
                  const Text(
                    'Riwayat Penarikan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._riwayatList.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildRiwayatCard(r),
                    ),
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
  Widget _buildAppBar() {
    return Container(
      color: _teal,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 4,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 24),
          ),
          const Text(
            'Tarik Saldo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Saldo ────────────────────────────────────────────────
  Widget _buildSaldoCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 22, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text(
                'Saldo Tersedia',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Nominal
          Text(
            _rp(_saldo),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Info bank
          Text(
            _namaBank,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            _noRekening,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Ajukan Penarikan ─────────────────────────────────────
  Widget _buildAjukanCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ajukan Penarikan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // Input jumlah
          TextField(
            controller: _jumlahCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Masukan jumlah (contoh: 500000)',
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.attach_money_rounded,
                  color: AppColors.textSecondary, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: _teal, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Tombol Tarik Saldo
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _tarikSaldo,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.attach_money_rounded,
                      size: 20, color: Colors.white),
              label: const Text(
                'Tarik Saldo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Banner Info ───────────────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              size: 20, color: Color(0xFFF57C00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Admin akan memproses penarikan dalam 1-3 hari kerja. '
              'Status dapat dipantau di riwayat di bawah ini.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Riwayat ──────────────────────────────────────────────
  Widget _buildRiwayatCard(_RiwayatData r) {
    final isApproved = r.status == StatusPenarikan.approved;
    final isPending  = r.status == StatusPenarikan.pending;

    final Color iconColor = isApproved
        ? const Color(0xFF2E7D32)
        : isPending
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    final IconData iconData = isApproved
        ? Icons.check_circle_outline_rounded
        : isPending
            ? Icons.hourglass_top_rounded
            : Icons.cancel_outlined;

    final String statusLabel = isApproved
        ? 'Approved'
        : isPending
            ? 'Pending'
            : 'Rejected';

    final Color badgeBg = isApproved
        ? const Color(0xFFE8F5E9)
        : isPending
            ? const Color(0xFFFFF8E1)
            : const Color(0xFFFFEBEE);

    final Color badgeText = isApproved
        ? const Color(0xFF2E7D32)
        : isPending
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(iconData, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _rp(r.jumlah),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  r.tanggal,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Badge status
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeText,
              ),
            ),
          ),
        ],
      ),
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
        border: Border.all(color: _teal.withOpacity(0.5)),
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