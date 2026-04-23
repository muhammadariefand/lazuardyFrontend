// lib/presentation/pages/siswa/booking/pilih_kategori_page.dart
// Pilih Kategori → tap Akademik → expand jenjang & mapel

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

// ── Data mapel per jenjang ─────────────────────────────────────────
const _mapelSD = ['Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'PKN', 'IPA', 'IPS', 'Informtika'];
const _mapelSMP = ['Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'PKN', 'IPA', 'IPS', 'Informtika'];
const _mapelSMA = ['Matematika', 'Fisika', 'Kimia', 'Bioogi', 'Bahasa Indonesia', 'Bahasa Inggris',
  'Ekonomi', 'Sosiologi', 'Geografi', 'PKN', 'Sejarah', 'Informatika'];
const _mapelUmum = ['Mengaji'];

class PilihKategoriPage extends StatefulWidget {
  const PilihKategoriPage({super.key});
  @override
  State<PilihKategoriPage> createState() => _PilihKategoriPageState();
}

class _PilihKategoriPageState extends State<PilihKategoriPage> {
  // State expand per kategori
  bool _akademikExpanded = false;
  bool _umumExpanded = false;

  // State pilihan
  String? _selectedJenjang;
  String? _selectedMapel;
  String? _expandedKategori; // 'akademik' or 'umum'

  List<String> get _currentMapelList {
    if (_expandedKategori == 'umum') return _mapelUmum;
    switch (_selectedJenjang) {
      case 'SD': return _mapelSD;
      case 'SMP': return _mapelSMP;
      case 'SMA': return _mapelSMA;
      default: return _mapelSD;
    }
  }

  void _onKategoriTap(String kategori) {
    setState(() {
      if (_expandedKategori == kategori) {
        // Toggle off
        _expandedKategori = null;
        _selectedJenjang = null;
        _selectedMapel = null;
      } else {
        _expandedKategori = kategori;
        _selectedJenjang = kategori == 'akademik' ? 'SD' : null;
        _selectedMapel = null;
        // Jika umum langsung expand mapel
        if (kategori == 'umum') _selectedMapel = null;
      }
    });
  }

  void _onLanjutkan() {
    if (_selectedMapel == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih mata pelajaran terlebih dahulu'),
        backgroundColor: Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ));
      return;
    }
    Navigator.pushNamed(context, '/siswa/booking/pilih-tutor',
        arguments: {
          'kategori': _expandedKategori,
          'jenjang': _selectedJenjang,
          'mapel': _selectedMapel,
        });
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
            onPressed: () => Navigator.pop(context)),
        title: const Text('Pilih Kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: _selectedMapel != null
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
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Lanjutkan',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            )
          : const SizedBox.shrink(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 4),
          const Text('Piiih Kategori Pembeajaran',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // ── Kartu Akademik ────────────────────────────────────
          _buildKategoriCard(
            icon: '📚',
            title: 'Akademik',
            subtitle: 'Matematika, Fisika, Kimia, dll.',
            isExpanded: _expandedKategori == 'akademik',
            onTap: () => _onKategoriTap('akademik'),
          ),

          // ── Expand: Jenjang + Mapel Akademik ─────────────────
          if (_expandedKategori == 'akademik') ...[
            const SizedBox(height: 20),
            _buildJenjangSection(),
            const SizedBox(height: 20),
            _buildMapelSection(),
          ],

          const SizedBox(height: 16),

          // ── Kartu Umum ────────────────────────────────────────
          _buildKategoriCard(
            icon: '📖',
            title: 'Umum',
            subtitle: 'Mengaji',
            isExpanded: _expandedKategori == 'umum',
            onTap: () => _onKategoriTap('umum'),
          ),

          // ── Expand: Mapel Umum ────────────────────────────────
          if (_expandedKategori == 'umum') ...[
            const SizedBox(height: 20),
            _buildMapelSection(),
          ],

          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  // ── Kartu kategori ─────────────────────────────────────────────
  Widget _buildKategoriCard({
    required String icon,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded ? _teal : _teal.withOpacity(0.4),
            width: isExpanded ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
                color: isExpanded
                    ? _teal.withOpacity(0.1)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Colors.grey.shade400, size: 22),
        ]),
      ),
    );
  }

  // ── Chip jenjang SD/SMP/SMA ─────────────────────────────────────
  Widget _buildJenjangSection() {
    const jenjangList = ['SD', 'SMP', 'SMA'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Pilih Jenjang',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      Row(children: jenjangList.map((j) {
        final isSelected = _selectedJenjang == j;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedJenjang = j;
              _selectedMapel = null; // reset mapel saat ganti jenjang
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? _teal : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isSelected ? _teal : _teal.withOpacity(0.5),
                    width: isSelected ? 1.5 : 1.2),
              ),
              child: Text(j,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary)),
            ),
          ),
        );
      }).toList()),
    ]);
  }

  // ── Chip mapel ──────────────────────────────────────────────────
  Widget _buildMapelSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Pilih Mata Pelajaran',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 10),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _currentMapelList.map((mapel) {
          final isSelected = _selectedMapel == mapel;
          return GestureDetector(
            onTap: () => setState(() => _selectedMapel = mapel),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? _teal : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: isSelected ? _teal : _teal.withOpacity(0.5),
                    width: isSelected ? 1.5 : 1.2),
              ),
              child: Text(mapel,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : AppColors.textPrimary)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}