// lib/presentation/pages/tutor/formulir_pendaftaran_tutor_page.dart
// Formulir Pendaftaran — chip Jenjang (single),
// chip Mapel (multi), upload CV/KTP/Ijazah

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_cubit.dart';

class FormulirPendaftaranTutorPage extends StatefulWidget {
  const FormulirPendaftaranTutorPage({super.key});

  @override
  State<FormulirPendaftaranTutorPage> createState() =>
      _FormulirPendaftaranTutorPageState();
}

class _FormulirPendaftaranTutorPageState
    extends State<FormulirPendaftaranTutorPage> {
  // ── State Jenjang (single select) ─────────────────────────────
  String? _selectedJenjang;
  static const _jenjangList = ['SD', 'SMP', 'SMA', 'Umum'];

  // ── State Mata Pelajaran (multi select) ───────────────────────
  final Set<String> _selectedMapel = {};
  static const _mapelList = [
    'Matematika', 'Fisika', 'Kimia',
    'Biologi', 'B. Indonesia', 'B. Inggris',
    'Ekonomi', 'Sosiologi', 'Geografi',
    'PKN', 'Sejarah', 'Informatika',
    'Mengaji'
  ];

  // ── State Upload Files ─────────────────────────────────────────
  PlatformFile? _cvFile;
  PlatformFile? _ktpFile;
  PlatformFile? _ijazahFile;

  bool _isLoading = false;

  // Validasi minimal
  bool get _isValid =>
      _selectedJenjang != null &&
      _selectedMapel.isNotEmpty &&
      _cvFile != null &&
      _ktpFile != null &&
      _ijazahFile != null;

  // Simulasi file picker dihapus, menggunakan file_picker yang sesungguhnya
  Future<PlatformFile?> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: type == 'cv' || type == 'ijazah' ? FileType.custom : FileType.image,
      allowedExtensions: type == 'cv' || type == 'ijazah' ? ['pdf', 'doc', 'docx'] : null,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files.single;
    }
    return null;
  }

  void _onSelanjutnya() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Lengkapi semua field sebelum melanjutkan'),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<TutorRegistrationCubit>().saveDocuments(
          cv: _cvFile!,
          idCard: _ktpFile!,
          certificate: _ijazahFile!,
        );

    Navigator.of(context).pushNamed('/tutor/formulir-profil');
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

                    // ── Back ──────────────────────────────────
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

                    const Text('Formulir Pendaftaran Tutor',
                        style: AppTextStyles.heading2),
                    const SizedBox(height: 20),

                    // ── Jenjang Mengajar (single chip) ────────
                    const Text('Jenjang Mengajar',
                        style: AppTextStyles.label),
                    const SizedBox(height: 10),
                    _buildJenjangChips(),

                    const SizedBox(height: 20),

                    // ── Mata Pelajaran (multi chip) ────────────
                    const Text('Mata Pelajaran',
                        style: AppTextStyles.label),
                    const SizedBox(height: 10),
                    _buildMapelChips(),

                    const SizedBox(height: 24),

                    // ── Upload CV ─────────────────────────────
                    const Text('CV', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _UploadField(
                      hint: 'Upload file PDF/DOC',
                      icon: Icons.description_outlined,
                      onTap: () async {
                        final file = await _pickFile('cv');
                        if (file != null) {
                          setState(() => _cvFile = file);
                        }
                      },
                      fileName: _cvFile?.name,
                    ),

                    const SizedBox(height: 16),

                    // ── Upload Foto KTP ───────────────────────
                    const Text('Foto KTP', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _UploadField(
                      hint: 'Upload foto KTP (JPG/PNG)',
                      icon: Icons.badge_outlined,
                      onTap: () async {
                        final file = await _pickFile('ktp');
                        if (file != null) {
                          setState(() => _ktpFile = file);
                        }
                      },
                      fileName: _ktpFile?.name,
                    ),

                    const SizedBox(height: 16),

                    // ── Upload Ijazah ─────────────────────────
                    const Text('Ijazah', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _UploadField(
                      hint: 'Upload foto ijazah terakhir',
                      icon: Icons.school_outlined,
                      onTap: () async {
                        final file = await _pickFile('ijazah');
                        if (file != null) {
                          setState(() => _ijazahFile = file);
                        }
                      },
                      fileName: _ijazahFile?.name,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Tombol Selanjutnya (sticky) ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: PrimaryButton(
                label: 'Selanjutnya',
                onPressed: _onSelanjutnya,
                isLoading: _isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Jenjang: single select chips ─────────────────────────────
  Widget _buildJenjangChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _jenjangList.map((jenjang) {
        final isSelected = _selectedJenjang == jenjang;
        return _SelectableChip(
          label: jenjang,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedJenjang = jenjang),
        );
      }).toList(),
    );
  }

  // ── Mapel: multi select chips ─────────────────────────────────
  Widget _buildMapelChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _mapelList.map((mapel) {
        final isSelected = _selectedMapel.contains(mapel);
        return _SelectableChip(
          label: mapel,
          isSelected: isSelected,
          onTap: () => setState(() {
            if (isSelected) {
              _selectedMapel.remove(mapel);
            } else {
              _selectedMapel.add(mapel);
            }
          }),
        );
      }).toList(),
    );
  }
}

// ── Selectable Chip Widget ────────────────────────────────────────
class _SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary : AppColors.bgWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.borderColor,
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected
                ? FontWeight.w600
                : FontWeight.w400,
            color:
                isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ── Upload Field Widget ───────────────────────────────────────────
class _UploadField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final String? fileName;
  final VoidCallback onTap;

  const _UploadField({
    required this.hint,
    required this.icon,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: hasFile
              ? AppColors.primaryLight
              : AppColors.bgWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: hasFile
                ? AppColors.primary
                : AppColors.borderColor,
            width: hasFile ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasFile ? Icons.check_circle_outline : icon,
              color: hasFile
                  ? AppColors.primary
                  : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasFile ? fileName! : hint,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasFile
                      ? FontWeight.w500
                      : FontWeight.w400,
                  color: hasFile
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              hasFile ? Icons.edit_outlined : Icons.upload_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}