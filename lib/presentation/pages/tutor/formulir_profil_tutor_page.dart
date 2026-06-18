// lib/presentation/pages/tutor/formulir_profil_tutor_page.dart
// FIXED: (1) _buildJenjangChips → _buildMetodeChips ditambahkan
//        (2) Validasi _selectedMetode di _onSimpan()
//        (3) Route '/otp' → '/tutor/otp'
//        (4) Counter deskripsi berubah merah di 90% limit

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_state.dart';

class FormulirProfilTutorPage extends StatefulWidget {
  const FormulirProfilTutorPage({super.key});

  @override
  State<FormulirProfilTutorPage> createState() =>
      _FormulirProfilTutorPageState();
}

class _FormulirProfilTutorPageState extends State<FormulirProfilTutorPage> {
  // ── Kelas & Subject (Dihapus sesuai permintaan) ────────────────

  // ── Metode Pembelajaran (single select) ───────────────────────
  String? _selectedMetode;
  static const _metodeList = ['Online', 'Offline'];

  // ── Deskripsi ─────────────────────────────────────────────────
  final _deskripsiCtrl = TextEditingController();
  static const _maxDeskripsi = 300;

  // ── Grid Jadwal: key = 'jamIdx-hariIdx' ──────────────────────
  final Map<String, bool> _jadwal = {};

  static const _jamList = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00',
  ];

  static const _hariList = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────
  String _key(int jamIdx, int hariIdx) => '$jamIdx-$hariIdx';

  bool _isChecked(int jamIdx, int hariIdx) =>
      _jadwal[_key(jamIdx, hariIdx)] ?? false;

  void _toggleJadwal(int jamIdx, int hariIdx) {
    final key = _key(jamIdx, hariIdx);
    setState(() => _jadwal[key] = !(_jadwal[key] ?? false));
  }

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

  // ── Validasi & Submit ─────────────────────────────────────────
  void _onSimpan() {

    // FIX 1: Validasi metode
    if (_selectedMetode == null) {
      _showError('Pilih metode pembelajaran terlebih dahulu');
      return;
    }

    // FIX 2: Validasi deskripsi
    if (_deskripsiCtrl.text.trim().isEmpty) {
      _showError('Deskripsi wajib diisi');
      return;
    }

    // FIX 3: Validasi jadwal
    if (_selectedJadwal.isEmpty) {
      _showError('Pilih minimal 1 jadwal mengajar');
      return;
    }

    context.read<TutorRegistrationCubit>().submitRegistration(
          learningMethods: [_selectedMetode!],
          bio: _deskripsiCtrl.text,
          schedules: _selectedJadwal,
        );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TutorRegistrationCubit, TutorRegistrationState>(
      listener: (context, state) {
        if (state is TutorRegistrationLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is TutorRegistrationSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil('/tutor/menunggu-verifikasi', (route) => false);
          } else if (state is TutorRegistrationError) {
            _showError(state.message);
          }
        }
      },
      child: Scaffold(
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

                    // ── Back ─────────────────────────────────────
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

                    // ── Metode Pembelajaran ──────────────────────
                    const Text('Metode Pembelajaran',
                        style: AppTextStyles.label),
                    const SizedBox(height: 10),
                    _buildMetodeChips(), // FIX 5: method yang benar

                    const SizedBox(height: 20),

                    // ── Deskripsi ────────────────────────────────
                    const Text('Deskripsi', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _buildDeskripsiField(),

                    const SizedBox(height: 24),

                    // ── Jadwal Mengajar ──────────────────────────
                    const Text('Jadwal Mengajar', style: AppTextStyles.label),
                    const SizedBox(height: 4),
                    Text(
                      'Pilih hari dan jam sesuai ketersediaanmu',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 16),
                    _buildScheduleGrid(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Tombol sticky bottom ──────────────────────────────
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
    ));
  }

  // ── FIX: Method ini yang sebelumnya TIDAK ADA (root cause error) ──
  Widget _buildMetodeChips() {
    return Row(
      children: _metodeList.map((metode) {
        final isSelected = _selectedMetode == metode;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => setState(() => _selectedMetode = metode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.bgWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.borderColor,
                  width: isSelected ? 1.5 : 1.2,
                ),
              ),
              child: Text(
                metode,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color:
                      isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Textarea deskripsi + counter warna dinamis ─────────────────
  Widget _buildDeskripsiField() {
    final currentLen = _deskripsiCtrl.text.length;
    // Counter merah saat >= 90% dari limit
    final isNearLimit = currentLen >= (_maxDeskripsi * 0.9).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _deskripsiCtrl,
          maxLines: 5,
          maxLength: _maxDeskripsi,
          buildCounter: (_, {required currentLength,
                required isFocused, maxLength}) => null,
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
              borderSide: const BorderSide(
                  color: AppColors.borderColor, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$currentLen/$_maxDeskripsi',
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                isNearLimit ? FontWeight.w600 : FontWeight.normal,
            color: isNearLimit ? AppColors.errorRed : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  // ── Grid jadwal 14 jam × 7 hari ───────────────────────────────
  Widget _buildScheduleGrid() {
    const double timeColWidth = 52;
    const double cellSize = 28.0;
    const double colSpacing = 8.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header hari
          Row(
            children: [
              SizedBox(width: timeColWidth),
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

          // Rows jam
          ..._jamList.asMap().entries.map((jamEntry) {
            final jamIdx = jamEntry.key;
            final jam = jamEntry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: timeColWidth,
                    child: Text(
                      jam,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  ..._hariList.asMap().entries.map((hariEntry) {
                    final hariIdx = hariEntry.key;
                    final checked = _isChecked(jamIdx, hariIdx);
                    return SizedBox(
                      width: cellSize + colSpacing,
                      child: Center(
                        child: _ScheduleCheckbox(
                          checked: checked,
                          size: cellSize,
                          onTap: () => _toggleJadwal(jamIdx, hariIdx),
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

// ── Schedule Checkbox ──────────────────────────────────────────────
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
            color: checked ? AppColors.primary : AppColors.borderColor,
            width: 1.2,
          ),
        ),
        child: checked
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}