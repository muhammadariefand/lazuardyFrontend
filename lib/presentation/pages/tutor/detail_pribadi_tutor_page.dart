// lib/presentation/pages/tutor/detail_pribadi_tutor_page.dart
// Detail Pribadi — Nama, Jenis Kelamin, Tgl Lahir,
// No WA, Pilih Bank (dropdown), Nomor Rekening

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_state.dart';

class DetailPribadiTutorPage extends StatefulWidget {
  const DetailPribadiTutorPage({super.key});

  @override
  State<DetailPribadiTutorPage> createState() =>
      _DetailPribadiTutorPageState();
}

class _DetailPribadiTutorPageState extends State<DetailPribadiTutorPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _rekeningCtrl = TextEditingController();

  String? _selectedJenisKelamin;
  String? _selectedBank;
  PlatformFile? _profileImage;
  bool _isLoading = false;

  static const _jenisKelaminList = ['Laki-laki', 'Perempuan'];

  static const _bankList = [
    'BCA', 'BNI', 'BRI', 'Mandiri', 'BSI',
    'CIMB Niaga', 'Danamon', 'Permata', 'BTN', 'Maybank',
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _tglLahirCtrl.dispose();
    _waCtrl.dispose();
    _rekeningCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1960),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _tglLahirCtrl.text =
            '${picked.year.toString()}-'
            '${picked.month.toString().padLeft(2, '0')}-'
            '${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _profileImage = result.files.single;
      });
    }
  }

  void _onSelanjutnya() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedJenisKelamin == null || _selectedBank == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih Jenis Kelamin dan Bank terlebih dahulu'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      
      context.read<TutorRegistrationCubit>().validateBank(
        name: _namaCtrl.text,
        gender: _selectedJenisKelamin!,
        dob: _tglLahirCtrl.text,
        waNumber: _waCtrl.text,
        bankCode: _selectedBank!,
        accountNumber: _rekeningCtrl.text,
        profilePhoto: _profileImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TutorRegistrationCubit, TutorRegistrationState>(
      listener: (context, state) {
        if (state is TutorRegistrationLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is BankAccountValid) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nama Pemilik Rekening: ${state.accountHolderName}'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.of(context).pushNamed('/tutor/detail-alamat');
          } else if (state is TutorRegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgWhite,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Back ────────────────────────────────
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

                      const Text('Detail Pribadi',
                          style: AppTextStyles.heading2),
                      const SizedBox(height: 20),

                      // ── Foto Profil ────────────────────────
                      _buildLabel('Foto Profil'),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E7EB),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0xFF6B7280),
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Pilih foto JPG atau PNG maksimal 5 MB',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text(
                                'Unggah Foto',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (_profileImage != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _profileImage!.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Nama Lengkap ─────────────────────────
                      _buildLabel('Nama Lengkap'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _namaCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            AppTheme.inputDecoration(hint: 'Nama Anda'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // ── Jenis Kelamin ────────────────────────
                      _buildLabel('Jenis Kelamin'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedJenisKelamin,
                        onChanged: (v) =>
                            setState(() => _selectedJenisKelamin = v),
                        decoration: AppTheme.inputDecoration(
                            hint: 'Pilih Jenis Kelamin'),
                        icon: const Icon(Icons.keyboard_arrow_up_rounded,
                            color: AppColors.textSecondary),
                        hint: const Text('Pilih Jenis Kelamin',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                        dropdownColor: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(12),
                        validator: (v) =>
                            v == null ? 'Jenis kelamin wajib dipilih' : null,
                        items: _jenisKelaminList
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e)))
                            .toList(),
                      ),

                      const SizedBox(height: 16),

                      // ── Tanggal Lahir ────────────────────────
                      _buildLabel('Tanggal Lahir'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tglLahirCtrl,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: AppTheme.inputDecoration(
                          hint: 'dd/mm/yy',
                          prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.textSecondary,
                              size: 18),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Tanggal lahir wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // ── Nomor WhatsApp ────────────────────────
                      _buildLabel('Nomor WhatsApp'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _waCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: AppTheme.inputDecoration(
                          hint: '08xxx',
                          prefixIcon: const Icon(Icons.phone_outlined,
                              color: AppColors.textSecondary, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Nomor WhatsApp wajib diisi';
                          }
                          if (v.length < 9) return 'Nomor tidak valid';
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ── Pilih Bank ────────────────────────────
                      _buildLabel('Pilih Bank'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedBank,
                        onChanged: (v) =>
                            setState(() => _selectedBank = v),
                        decoration:
                            AppTheme.inputDecoration(hint: 'Pilih Bank'),
                        icon: const Icon(Icons.keyboard_arrow_up_rounded,
                            color: AppColors.textSecondary),
                        hint: const Text('Pilih Bank',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                        dropdownColor: AppColors.bgWhite,
                        borderRadius: BorderRadius.circular(12),
                        validator: (v) =>
                            v == null ? 'Bank wajib dipilih' : null,
                        items: _bankList
                            .map((e) => DropdownMenuItem(
                                value: e, child: Text(e)))
                            .toList(),
                      ),

                      const SizedBox(height: 16),

                      // ── Nomor Rekening ────────────────────────
                      _buildLabel('Nomor Rekening'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _rekeningCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: AppTheme.inputDecoration(
                          hint: 'Nomor Rekening untuk Pembayaran',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Nomor rekening wajib diisi';
                          }
                          if (v.length < 8) {
                            return 'Nomor rekening tidak valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // ── Tombol Selanjutnya (sticky) ───────────────
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
      ),
    ));
  }


  Widget _buildLabel(String text) =>
      Text(text, style: AppTextStyles.label);
}