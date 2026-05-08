// lib/presentation/pages/tutor/profil_mengajar_page.dart
// — AppBar icon pensil, semua read-only
// — AppBar icon simpan, slot aktif bisa dihapus (×),
//                       slot tersedia bisa ditambah (+)
// Sections:
//  1. Deskripsi Mengajar  (card, teks)
//  2. Metode Mengajar     (card, toggle Online / Offline)
//  3. Atur Slot Ketersediaan
//     - 7 tombol hari (Sen–Min) dengan badge jumlah slot
//     - "Slot Aktif - <hari>" → chips jam aktif (view: plain, edit: + ×)
//     - "Tambah slot"        → grid jam yang bisa diklik (hanya edit mode)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';

const _teal = Color(0xFF3AAFA9);

// ── Slot per hari ─────────────────────────────────────────────────
class _HariSlot {
  final String label; // 'Sen', 'Sel', …
  final String namaLengkap; // 'Senin', 'Selasa', …
  List<String> aktif; // jam yang sudah dipilih

  _HariSlot({
    required this.label,
    required this.namaLengkap,
    required this.aktif,
  });
}

// ── Page ──────────────────────────────────────────────────────────
class ProfilMengajarPage extends StatefulWidget {
  const ProfilMengajarPage({super.key});

  @override
  State<ProfilMengajarPage> createState() => _ProfilMengajarPageState();
}

class _ProfilMengajarPageState extends State<ProfilMengajarPage> {
  // ── State ─────────────────────────────────────────────────────
  bool _isEditMode = false;
  bool _onlineAktif = false;
  bool _offlineAktif = true;
  int _selectedHariIdx = 0;

  late final TextEditingController _deskripsiCtrl;

  // Semua jam yang tersedia untuk ditambahkan
  static const _allSlots = [
    '08:00', '09:00', '10:00', '11:00',
    '12:00', '13:00', '14:00', '15:00',
    '16:00', '17:00', '18:00', '19:00',
    '20:00', '21:00',
  ];

  final List<_HariSlot> _hariList = [
    _HariSlot(label: 'Sen', namaLengkap: 'Senin',  aktif: ['14:00', '16:00']),
    _HariSlot(label: 'Sel', namaLengkap: 'Selasa', aktif: []),
    _HariSlot(label: 'Rab', namaLengkap: 'Rabu',   aktif: []),
    _HariSlot(label: 'Kam', namaLengkap: 'Kamis',  aktif: []),
    _HariSlot(label: 'Jum', namaLengkap: 'Jumat',  aktif: ['16:00']),
    _HariSlot(label: 'Sab', namaLengkap: 'Sabtu',  aktif: []),
    _HariSlot(label: 'Min', namaLengkap: 'Minggu', aktif: ['16:00']),
  ];

  @override
  void initState() {
    super.initState();
    _deskripsiCtrl = TextEditingController(
      text:
          'Saya adalah tutor Matematika dan Fisika berpengalaman 5 tahun. '
          'Mengajar dengan metode yang menyenangkan dan mudah dipahami. '
          'Fokus pada pemahaman konsep, bukan hafalan.',
    );
  }

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  // ── Slot helpers ──────────────────────────────────────────────
  _HariSlot get _selectedHari => _hariList[_selectedHariIdx];

  List<String> get _availableSlots => _allSlots
      .where((s) => !_selectedHari.aktif.contains(s))
      .toList();

  void _addSlot(String jam) {
    setState(() {
      _selectedHari.aktif = [..._selectedHari.aktif, jam]
        ..sort();
    });
  }

  void _removeSlot(String jam) {
    setState(() {
      _selectedHari.aktif =
          _selectedHari.aktif.where((s) => s != jam).toList();
    });
  }

  // ── Save ─────────────────────────────────────────────────────
  void _simpan() {
    setState(() => _isEditMode = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mengajar berhasil disimpan'),
        backgroundColor: _teal,
        behavior: SnackBarBehavior.floating,
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
                children: [
                  _buildDeskripsiCard(),
                  const SizedBox(height: 14),
                  _buildMetodeCard(),
                  const SizedBox(height: 14),
                  _buildSlotCard(),
                  const SizedBox(height: 32),
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
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white, size: 24),
          ),
          const Expanded(
            child: Text(
              'Profil Mengajar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          // Pensil (view) ↔ Simpan (edit)
          IconButton(
            onPressed: () {
              if (_isEditMode) {
                _simpan();
              } else {
                setState(() => _isEditMode = true);
              }
            },
            icon: Icon(
              _isEditMode
                  ? Icons.save_outlined
                  : Icons.edit_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Deskripsi ───────────────────────────────────────────
  Widget _buildDeskripsiCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deskripsi Mengajar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _isEditMode
              ? TextField(
                  controller: _deskripsiCtrl,
                  minLines: 4,
                  maxLines: 8,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: _teal.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: _teal, width: 1.5),
                    ),
                  ),
                )
              : Text(
                  _deskripsiCtrl.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
        ],
      ),
    );
  }

  // ── Card: Metode ──────────────────────────────────────────────
  Widget _buildMetodeCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Mengajar',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _metodeButton(
                icon: Icons.videocam_outlined,
                label: 'Online',
                isActive: _onlineAktif,
                onTap: _isEditMode
                    ? () => setState(() => _onlineAktif = !_onlineAktif)
                    : null,
              ),
              const SizedBox(width: 12),
              _metodeButton(
                icon: Icons.location_on_outlined,
                label: 'Offline',
                isActive: _offlineAktif,
                onTap: _isEditMode
                    ? () => setState(() => _offlineAktif = !_offlineAktif)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metodeButton({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? _teal : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? _teal : const Color(0xFFCCCCCC),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color: isActive ? Colors.white : AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Card: Slot Ketersediaan ───────────────────────────────────
  Widget _buildSlotCard() {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atur Slot Ketersediaan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // ── 7 tombol hari ──────────────────────────────────
          _buildHariSelector(),
          const SizedBox(height: 18),

          // ── Slot Aktif ─────────────────────────────────────
          Text(
            'Slot Aktif - ${_selectedHari.namaLengkap}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          _buildAktifChips(),
          const SizedBox(height: 18),

          // ── Tambah slot ────────────────────────────────────
          if (_availableSlots.isNotEmpty) ...[
            const Text(
              'Tambah slot',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            _buildTambahSlotGrid(),
          ],
        ],
      ),
    );
  }

  // 7 tombol hari
  Widget _buildHariSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_hariList.length, (i) {
        final hari = _hariList[i];
        final isSelected = _selectedHariIdx == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedHariIdx = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? _teal : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? _teal : const Color(0xFFCCCCCC),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hari.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color:
                        isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${hari.aktif.length} slot',
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? Colors.white.withOpacity(0.85)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Slot aktif — view: plain chip, edit: chip + tombol ×
  Widget _buildAktifChips() {
    final aktif = _selectedHari.aktif;

    if (aktif.isEmpty) {
      return Text(
        'Belum ada slot aktif',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary.withOpacity(0.7),
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: aktif.map((jam) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _teal.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _teal.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule_rounded, size: 15, color: _teal),
              const SizedBox(width: 5),
              Text(
                jam,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _teal,
                ),
              ),
              if (_isEditMode) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _removeSlot(jam),
                  child: const Icon(Icons.cancel_rounded,
                      size: 16, color: Colors.red),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // Grid jam yang bisa ditambahkan (hanya edit mode)
  Widget _buildTambahSlotGrid() {
    // Di view mode tetap tampil tapi tidak bisa diklik
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableSlots.map((jam) {
        return GestureDetector(
          onTap: _isEditMode ? () => _addSlot(jam) : null,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded,
                    size: 14,
                    color: _isEditMode
                        ? AppColors.textPrimary
                        : AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  jam,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _isEditMode
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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