// lib/presentation/pages/tutor/detail_pribadi_tutor_page.dart
// Detail Pribadi — Nama, Jenis Kelamin, Tgl Lahir,
// No WA, Pilih Bank (dropdown), Nomor Rekening

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';

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
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year.toString().substring(2)}';
      });
    }
  }

  void _onSelanjutnya() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed('/tutor/formulir-pendaftaran');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: AppTextStyles.label);
}