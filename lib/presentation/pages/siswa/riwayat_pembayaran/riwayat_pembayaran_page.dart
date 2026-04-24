// lib/presentation/pages/siswa/riwayat_pembayaran_page.dart
// Riwayat Pembayaran — list kartu paket, badge Berhasil/Gagal, harga merah

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _priceRed = Color(0xFFE53E3E);
const _green = Color(0xFF4CAF50);

enum _PaymentStatus { berhasil, gagal, menunggu }

class RiwayatPembayaranPage extends StatelessWidget {
  const RiwayatPembayaranPage({super.key});

  static const _list = [
    _PaymentItem(
      paket: 'Paket 8 Sesi',
      bank: 'Bank BCA',
      tanggal: '1 Maret 2026',
      harga: 400000,
      status: _PaymentStatus.berhasil,
    ),
    _PaymentItem(
      paket: 'Paket 4 Sesi',
      bank: 'Bank Mandiri',
      tanggal: '15 Februari 2026',
      harga: 200000,
      status: _PaymentStatus.berhasil,
    ),
    _PaymentItem(
      paket: 'Paket 8 Sesi',
      bank: 'Bank Mandiri',
      tanggal: '15 Februari 2026',
      harga: 400000,
      status: _PaymentStatus.gagal,
    ),
  ];

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write('.');
      buf.write(str[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Riwayat Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      body: _list.isEmpty
          ? _buildEmpty()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) =>
                  _PaymentCard(item: _list[i], formatRupiah: _formatRupiah),
            ),
    );
  }

  Widget _buildEmpty() => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('💳', style: TextStyle(fontSize: 48)),
      SizedBox(height: 12),
      Text('Belum ada riwayat pembayaran',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary)),
    ]),
  );
}

// ── Kartu pembayaran ──────────────────────────────────────────────
class _PaymentCard extends StatelessWidget {
  final _PaymentItem item;
  final String Function(int) formatRupiah;
  const _PaymentCard({required this.item, required this.formatRupiah});

  Color get _badgeColor {
    switch (item.status) {
      case _PaymentStatus.berhasil: return _green;
      case _PaymentStatus.gagal:    return _priceRed;
      case _PaymentStatus.menunggu: return const Color(0xFFF59E0B);
    }
  }

  String get _badgeLabel {
    switch (item.status) {
      case _PaymentStatus.berhasil: return 'Berhasil';
      case _PaymentStatus.gagal:    return 'Gagal';
      case _PaymentStatus.menunggu: return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _teal.withOpacity(0.4), width: 1.2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Row atas: nama paket + badge status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.paket,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: _teal)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _badgeColor.withOpacity(0.3)),
              ),
              child: Text(_badgeLabel,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, color: _badgeColor)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row bawah: bank+tanggal + harga
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.bank,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(item.tanggal,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ]),
            Text(
              formatRupiah(item.harga),
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: _priceRed),
            ),
          ],
        ),
      ]),
    );
  }
}

// ── Model ─────────────────────────────────────────────────────────
class _PaymentItem {
  final String paket, bank, tanggal;
  final int harga;
  final _PaymentStatus status;
  const _PaymentItem({
    required this.paket,
    required this.bank,
    required this.tanggal,
    required this.harga,
    required this.status,
  });
}