// lib/presentation/pages/siswa/beli_paket_page.dart
// Beli Paket Sesi — list 4 paket dengan radio button

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);
const _priceRed = Color(0xFFE53E3E);

class BeliPaketPage extends StatefulWidget {
  const BeliPaketPage({super.key});
  @override
  State<BeliPaketPage> createState() => _BeliPaketPageState();
}

class _BeliPaketPageState extends State<BeliPaketPage> {
  int? _selectedIndex;

  static const _paketList = [
    _Paket(
      judul: 'Paket 4 Sesi',
      deskripsi: 'Cocok untuk kebutuhan belajar ringan',
      harga: 200000,
      hargaPerSesi: 50000,
      jumlahSesi: 4,
    ),
    _Paket(
      judul: 'Paket 8 Sesi',
      deskripsi: 'Cocok untuk belajar rutin',
      harga: 400000,
      hargaPerSesi: 50000,
      jumlahSesi: 8,
    ),
    _Paket(
      judul: 'Paket 12 Sesi',
      deskripsi: 'Cocok untuk persiapan ujian',
      harga: 600000,
      hargaPerSesi: 50000,
      jumlahSesi: 12,
    ),
    _Paket(
      judul: 'Paket 16 Sesi',
      deskripsi: 'Cocok untuk belajar intensif & konsisten',
      harga: 800000,
      hargaPerSesi: 50000,
      jumlahSesi: 16,
    ),
  ];

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  void _onLanjutkan() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih paket terlebih dahulu'),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }
    Navigator.pushNamed(
      context,
      '/siswa/pembayaran',
      arguments: {'paket': _paketList[_selectedIndex!]},
    );
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
        title: const Text(
          'Beli Paket Sesi',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: _selectedIndex != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _onLanjutkan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Lanjutkan',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            )
          : const SizedBox.shrink(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          const Text(
            'Piiih Paket  sesi yang sesuai dengan kebutuhan belajar Anda',
            style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
          const SizedBox(height: 20),

          // List kartu paket
          ..._paketList.asMap().entries.map((entry) {
            final i = entry.key;
            final paket = entry.value;
            final isSelected = _selectedIndex == i;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? _teal : _teal.withOpacity(0.35),
                      width: isSelected ? 1.8 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? _teal.withOpacity(0.1)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: ikon + judul + radio
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ikon buku 📚
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('📚',
                                  style: TextStyle(fontSize: 26)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(paket.judul,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary)),
                                const SizedBox(height: 2),
                                Text(paket.deskripsi,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          // Radio button
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? _teal : Colors.grey.shade400,
                                width: isSelected ? 0 : 1.5,
                              ),
                              color: isSelected ? _teal : Colors.white,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 14)
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Harga merah besar
                      Text(
                        _formatRupiah(paket.harga),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _priceRed,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Harga per sesi + jumlah sesi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_formatRupiah(paket.hargaPerSesi)}/sesi',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                          Text(
                            '${paket.jumlahSesi} sesi',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}

// ── Model Paket ────────────────────────────────────────────────────
class _Paket {
  final String judul, deskripsi;
  final int harga, hargaPerSesi, jumlahSesi;
  const _Paket({
    required this.judul,
    required this.deskripsi,
    required this.harga,
    required this.hargaPerSesi,
    required this.jumlahSesi,
  });
}