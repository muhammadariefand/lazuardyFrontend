// lib/presentation/pages/tutor/formulir_profil_tutor_page.dart
// Formulir Profil — textarea deskripsi 300 char,
// grid jadwal 14 jam (08:00–21:00) × 7 hari (Sen–Min)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class FormulirProfilTutorPage extends StatefulWidget {
  const FormulirProfilTutorPage({super.key});

  @override
  State<FormulirProfilTutorPage> createState() =>
      _FormulirProfilTutorPageState();
}

class _FormulirProfilTutorPageState
    extends State<FormulirProfilTutorPage> {
  final _deskripsiCtrl = TextEditingController();
  static const _maxDeskripsi = 300;

  // Grid jadwal: Map<'jam-hari', bool>
  // jam index 0..13 → 08:00..21:00
  // hari index 0..6 → Sen..Min
  final Map<String, bool> _jadwal = {};

  static const _jamList = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00',
  ];

  static const _hariList = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  String _key(int jamIdx, int hariIdx) => '$jamIdx-$hariIdx';

  bool _isChecked(int jamIdx, int hariIdx) =>
      _jadwal[_key(jamIdx, hariIdx)] ?? false;

  void _toggleJadwal(int jamIdx, int hariIdx) {
    final key = _key(jamIdx, hariIdx);
    setState(() => _jadwal[key] = !(_jadwal[key] ?? false));
  }

  // Ambil jadwal yang dipilih sebagai list of Map
  List<Map<String, String>> get _selectedJadwal {
    final result = <Map<String, String>>[];
    for (final entry in _jadwal.entries) {
      if (entry.value) {
        final parts = entry.key.split('-');
        result.add({
          'jam': _jamList[int.parse(parts[0])],
          'hari': _hariList[int.parse(parts[1])],
        });
      }
    }
    return result;
  }

  void _onSimpan() async {
    if (_deskripsiCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskripsi wajib diisi'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedJadwal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 jadwal mengajar'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    // TODO: Submit ke use case / repository
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigasi ke OTP setelah semua form terisi
      Navigator.of(context).pushNamed(
        '/otp',
        arguments: {'context': 'register'},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Back ────────────────────────────────────
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    const SizedBox(height: 20),
                    const LogoWithName(),
                    const SizedBox(height: 28),

                    const Text('Formulir Profil Tutor',
                        style: AppTextStyles.heading2),

                    const SizedBox(height: 24),

                    // ── Deskripsi ────────────────────────────────
                    const Text('Deskripsi', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _buildDeskripsiField(),

                    const SizedBox(height: 24),

                    // ── Jadwal Mengajar ──────────────────────────
                    const Text('Jadwal Mengajar',
                        style: AppTextStyles.label),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih hari dan jam sesuai ketersediaanmu',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500),
                    ),

                    const SizedBox(height: 16),

                    // ── Grid Jadwal ──────────────────────────────
                    _buildScheduleGrid(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Tombol Simpan & Kirim (sticky) ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: PrimaryButton(
                label: 'Simpan & Kirim',
                onPressed: _onSimpan,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Textarea deskripsi dengan character counter ───────────────
  Widget _buildDeskripsiField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _deskripsiCtrl,
          maxLines: 5,
          maxLength: _maxDeskripsi,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
              null, // custom counter di bawah
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Ceritakan pengalamanmu...',
            hintStyle: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.bgWhite,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Character counter
        Text(
          '${_deskripsiCtrl.text.length}/$_maxDeskripsi',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // ── Schedule Grid 14 jam × 7 hari ────────────────────────────
  Widget _buildScheduleGrid() {
    // Column widths
    const double timeColWidth = 48;
    const double cellSize = 28.0;
    const double colSpacing = 8.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row (hari)
          Row(
            children: [
              SizedBox(width: timeColWidth), // spacer untuk kolom jam
              ..._hariList.map(
                (hari) => SizedBox(
                  width: cellSize + colSpacing,
                  child: Center(
                    child: Text(
                      hari,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Data rows (jam × hari)
          ..._jamList.asMap().entries.map((jamEntry) {
            final jamIdx = jamEntry.key;
            final jam = jamEntry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  // Kolom waktu
                  SizedBox(
                    width: timeColWidth,
                    child: Text(
                      jam,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  // Kolom checkbox per hari
                  ..._hariList.asMap().entries.map((hariEntry) {
                    final hariIdx = hariEntry.key;
                    final checked = _isChecked(jamIdx, hariIdx);

                    return SizedBox(
                      width: cellSize + colSpacing,
                      child: Center(
                        child: _ScheduleCheckbox(
                          checked: checked,
                          size: cellSize,
                          onTap: () =>
                              _toggleJadwal(jamIdx, hariIdx),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Schedule Checkbox Widget ──────────────────────────────────────
class _ScheduleCheckbox extends StatelessWidget {
  final bool checked;
  final double size;
  final VoidCallback onTap;

  const _ScheduleCheckbox({
    required this.checked,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: checked ? AppColors.primary : AppColors.bgWhite,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: checked
                ? AppColors.primary
                : AppColors.borderColor,
            width: 1.2,
          ),
        ),
        child: checked
            ? const Icon(Icons.check_rounded,
                color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}