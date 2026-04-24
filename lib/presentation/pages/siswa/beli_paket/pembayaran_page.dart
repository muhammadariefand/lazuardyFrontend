// lib/presentation/pages/siswa/pembayaran_page.dart
// Pilih metode pembayaran bank

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _priceRed = Color(0xFFE53E3E);

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});
  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  String? _selectedBank;

  static const _bankList = [
    _Bank('BCA', 'Bank BCA', '🔵'),
    _Bank('BRI', 'Bank BRI', '🔵'),
    _Bank('BNI', 'Bank BNI', '🔵'),
    _Bank('BSI', 'Bank BSI', '🟢'),
    _Bank('MANDIRI', 'Bank Mandiri', '🟡'),
  ];

  // Warna & singkatan bank
  static const _bankColors = {
    'BCA': Color(0xFF003D7C),
    'BRI': Color(0xFF00529B),
    'BNI': Color(0xFFFF6600),
    'BSI': Color(0xFF1A7C3E),
    'MANDIRI': Color(0xFF003087),
  };

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _onLanjutBayar() {
    if (_selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih metode pembayaran'),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }
    Navigator.pushNamed(context, '/siswa/kode-pembayaran',
        arguments: {'bank': _selectedBank});
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data paket dari argument
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final judul = 'Paket 8 Sesi'; // fallback
    final harga = 400000;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Pembayaran',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total Pembayaran',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            Text(_formatRupiah(harga),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _priceRed)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _onLanjutBayar,
              style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text('Lanjut Bayar',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 4),

          // Ringkasan pesanan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _teal.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8)
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('Ringkasan Pesanan',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                          child: Text('📚',
                              style: TextStyle(fontSize: 20))),
                    ),
                    const SizedBox(width: 10),
                    Text(judul,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ]),
                  Text(_formatRupiah(harga),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _priceRed)),
                ],
              ),
              const SizedBox(height: 6),
              const Text('4 sesi x Rp 50.000/sesi',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),

          const SizedBox(height: 16),

          // Pilih metode pembayaran
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _teal.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8)
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text('Pilih Metode Pembayaran',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              ..._bankList.map((bank) => Column(children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedBank = bank.kode),
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        child: Row(children: [
                          // Radio
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedBank == bank.kode
                                    ? _teal
                                    : Colors.grey.shade400,
                                width: _selectedBank == bank.kode ? 0 : 1.5,
                              ),
                              color: _selectedBank == bank.kode
                                  ? _teal
                                  : Colors.white,
                            ),
                            child: _selectedBank == bank.kode
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 13)
                                : null,
                          ),
                          const SizedBox(width: 14),

                          // Logo bank (teks warna-warni sebagai placeholder)
                          Container(
                            width: 44,
                            height: 28,
                            decoration: BoxDecoration(
                              color: (_bankColors[bank.kode] ?? _teal)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: (_bankColors[bank.kode] ?? _teal)
                                      .withOpacity(0.3)),
                            ),
                            alignment: Alignment.center,
                            child: Text(bank.kode,
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        _bankColors[bank.kode] ?? _teal)),
                          ),
                          const SizedBox(width: 12),

                          Text(bank.nama,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary)),
                        ]),
                      ),
                    ),
                    if (_bankList.last.kode != bank.kode)
                      Divider(height: 1, color: Colors.grey.shade200),
                  ])),
            ]),
          ),

          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _Bank {
  final String kode, nama, icon;
  const _Bank(this.kode, this.nama, this.icon);
}