// lib/presentation/pages/siswa/batalkan_sesi_page.dart

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

class BatalkanSesiPage extends StatefulWidget {
  const BatalkanSesiPage({super.key});
  @override
  State<BatalkanSesiPage> createState() => _BatalkanSesiPageState();
}

class _BatalkanSesiPageState extends State<BatalkanSesiPage> {
  String? _selectedAlasan;
  final _lainnyaCtrl = TextEditingController();
  bool _isLoading = false;

  static const _alasanList = [
    'Ada keperluan mendadak',
    'Jadwal bentrok dengan kegiatan lain',
    'Kondisi kesehatan tidak memungkinkan',
    'Lainnya',
  ];

  @override
  void dispose() {
    _lainnyaCtrl.dispose();
    super.dispose();
  }

  void _onKonfirmasi() {
    if (_selectedAlasan == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih alasan pembatalan'),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    // LOGIKA BARU: Jika pilih 'Lainnya', ambil teks dari controller
    String alasanFinal = _selectedAlasan!;
    if (_selectedAlasan == 'Lainnya' && _lainnyaCtrl.text.isNotEmpty) {
      alasanFinal = _lainnyaCtrl.text;
    }

    Navigator.pushNamed(
      context, 
      '/siswa/konfirmasi-pembatalan',
      arguments: {'alasan': alasanFinal}, // Mengirim Map<String, String>
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _teal, foregroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Batalkan Sesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: SizedBox(height: 52, child: ElevatedButton(
          onPressed: _onKonfirmasi,
          style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white, elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text('Konfirmasi Pembatalan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Kartu ringkasan sesi
          _buildSesiSummary(),
          const SizedBox(height: 16),

          // // Warning peringatan
          // _buildWarning(),
          // const SizedBox(height: 16),

          // Kebijakan pembatalan
          _buildKebijakan(),
          const SizedBox(height: 16),

          // Alasan pembatalan
          _buildAlasanSection(),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildSesiSummary() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(children: [
      Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center, child: Text('S', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.grey.shade500))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Ibu Sarah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _teal)),
          const Text('Matematika', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Row(children: [
            _pill('Offline', const Color(0xFFFFEBEE), const Color(0xFFE53E3E)),
            const SizedBox(width: 8),
            _pill('WhatsApp', const Color(0xFF25D366), Colors.white, icon: Icons.chat_rounded),
          ]),
        ])),
        _pill('Terjadwal', const Color(0xFFFFF8E1), const Color(0xFFF59E0B)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        const Text('14:00 - 15:00', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        const SizedBox(width: 14),
        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        const Text('Rabu, 1 April 2026', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
      ]),
    ]),
  );

  Widget _pill(String label, Color bg, Color textColor, {IconData? icon}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, size: 11, color: textColor), const SizedBox(width: 3)],
      Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
    ]));

  // Widget _buildWarning() => Container(
  //   padding: const EdgeInsets.all(14),
  //   decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(12),
  //     border: Border.all(color: const Color(0xFFFFE082))),
  //   child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //     const Text('⚠️', style: TextStyle(fontSize: 16)),
  //     const SizedBox(width: 8),
  //     const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
  //       Text('Peringatan (1/3)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
  //       SizedBox(height: 4),
  //       Text('Anda akan menerima 1 peringatan.\nJika mencapai 3 peringatan, akun akan ',
  //         style: TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4)),
  //       Text('disuspend selama 7 hari', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E))),
  //       Text('.\nMohon gunakan platform sesuai ketentuan.', style: TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4)),
  //     ])),
  //   ]),
  // );

  Widget _buildKebijakan() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Kebijakan Pembatalan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      _kebijakanRow(Icons.check_circle_outline, const Color(0xFF4CAF50), 'Cancel ≥ 12 jam: Kuota dikembalikan, tanpa penalti'),
      _kebijakanRow(Icons.cancel_outlined, const Color(0xFFE53E3E), 'Cancel < 12 jam: Kuota hangus, tanpa warning'),
      _kebijakanRow(Icons.warning_amber_rounded, const Color(0xFFF59E0B), 'No Show: Kuota hangus + 1 warning'),
      _kebijakanRow(Icons.warning_amber_rounded, const Color(0xFFF59E0B), '3 warning = Suspend 7 hari'),
    ]),
  );

  Widget _kebijakanRow(IconData icon, Color color, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4))),
    ]));

  Widget _buildAlasanSection() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Alasan Pembatalan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      ..._alasanList.map((alasan) {
        final isSelected = _selectedAlasan == alasan;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => setState(() => _selectedAlasan = alasan),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? _teal : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(alasan, style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary)),
            ),
          ),
        );
      }),
      // TextField lainnya muncul jika pilih "Lainnya"
      if (_selectedAlasan == 'Lainnya') ...[
        const SizedBox(height: 4),
        TextField(
          controller: _lainnyaCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Jelaskan Alasan Pembatalan',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            filled: true, fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    ]),
  );
}