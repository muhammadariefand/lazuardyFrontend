// lib/presentation/pages/siswa/detail_pribadi_siswa_page.dart
// Detail Pribadi — nama, dropdown kelas & jenis kelamin, tanggal lahir, WA

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

class DetailPribadiSiswaPage extends StatefulWidget {
  const DetailPribadiSiswaPage({super.key});

  @override
  State<DetailPribadiSiswaPage> createState() => _DetailPribadiSiswaPageState();
}

class _DetailPribadiSiswaPageState extends State<DetailPribadiSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  final _waCtrl = TextEditingController();

  String? _selectedKelas;
  String? _selectedJenisKelamin;
  bool _isLoading = false;

  // Data dropdown
  static const _kelasList = [
    'Kelas 1 SD', 'Kelas 2 SD', 'Kelas 3 SD', 'Kelas 4 SD',
    'Kelas 5 SD', 'Kelas 6 SD',
    'Kelas 7 SMP', 'Kelas 8 SMP', 'Kelas 9 SMP',
    'Kelas 10 SMA', 'Kelas 11 SMA', 'Kelas 12 SMA',
  ];

  static const _jenisKelaminList = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _tglLahirCtrl.dispose();
    _waCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tglLahirCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year.toString().substring(2)}';
      });
    }
  }

  void _onSelanjutnya() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Simpan data & navigasi ke halaman berikutnya
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Back Button ───────────────────────────────
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.textPrimary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                const SizedBox(height: 20),

                // ── Logo + Nama ───────────────────────────────
                const LogoWithName(),

                const SizedBox(height: 28),

                // ── Judul ─────────────────────────────────────
                const Text('Detail Pribadi', style: AppTextStyles.heading2),

                const SizedBox(height: 20),

                // ── Nama Lengkap ──────────────────────────────
                const Text('Nama Lengkap', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaCtrl,
                  enabled: !_isLoading,
                  textCapitalization: TextCapitalization.words,
                  decoration: AppTheme.inputDecoration(hint: 'Nama Anda'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nama lengkap wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Kelas (Dropdown) ──────────────────────────
                const Text('Kelas', style: AppTextStyles.label),
                const SizedBox(height: 8),
                _DropdownField(
                  hint: 'Pilih Kelas',
                  value: _selectedKelas,
                  items: _kelasList,
                  onChanged: (v) => setState(() => _selectedKelas = v),
                  validator: (v) =>
                      v == null ? 'Kelas wajib dipilih' : null,
                ),

                const SizedBox(height: 16),

                // ── Jenis Kelamin (Dropdown) ──────────────────
                const Text('Jenis Kelamin', style: AppTextStyles.label),
                const SizedBox(height: 8),
                _DropdownField(
                  hint: 'Pilih Jenis Kelamin',
                  value: _selectedJenisKelamin,
                  items: _jenisKelaminList,
                  onChanged: (v) =>
                      setState(() => _selectedJenisKelamin = v),
                  validator: (v) =>
                      v == null ? 'Jenis kelamin wajib dipilih' : null,
                ),

                const SizedBox(height: 16),

                // ── Tanggal Lahir ─────────────────────────────
                const Text('Tanggal Lahir', style: AppTextStyles.label),
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
                      size: 18,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Tanggal lahir wajib diisi';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Nomor WhatsApp ────────────────────────────
                const Text('Nomor WhatsApp', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _waCtrl,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: AppTheme.inputDecoration(
                    hint: 'Input Placeholder',
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nomor WhatsApp wajib diisi';
                    }
                    if (v.length < 9) {
                      return 'Nomor tidak valid';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 36),

                // ── Tombol Selanjutnya ────────────────────────
                PrimaryButton(
                  label: 'Selanjutnya',
                  onPressed: _onSelanjutnya,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Dropdown Field ─────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const _DropdownField({
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      icon: const Icon(
        Icons.keyboard_arrow_up_rounded,
        color: AppColors.textSecondary,
      ),
      decoration: AppTheme.inputDecoration(hint: hint),
      hint: Text(hint,
          style: const TextStyle(
              fontSize: 14, color: AppColors.textSecondary)),
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      dropdownColor: AppColors.bgWhite,
      borderRadius: BorderRadius.circular(12),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
    );
  }
}