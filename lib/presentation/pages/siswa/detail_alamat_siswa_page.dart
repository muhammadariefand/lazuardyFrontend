// lib/presentation/pages/siswa/detail_alamat_siswa_page.dart
// Detail Alamat — 4 dropdown bertingkat Provinsi→Kota→Kecamatan→Desa
// Dropdown bawah dikunci sampai dropdown atasnya dipilih (cascading)

import 'package:flutter/material.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';
import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';

class DetailAlamatSiswaPage extends StatefulWidget {
  const DetailAlamatSiswaPage({super.key});

  @override
  State<DetailAlamatSiswaPage> createState() => _DetailAlamatSiswaPageState();
}

class _DetailAlamatSiswaPageState extends State<DetailAlamatSiswaPage> {
  final _formKey = GlobalKey<FormState>();

  // State pilihan
  String? _selectedProvinsi;
  String? _selectedKota;
  String? _selectedKecamatan;
  String? _selectedDesa;

  // ── Data statis (ganti dengan API call nyata) ──────────────────
  static const _provinsiList = [
    'DI Yogyakarta', 'DKI Jakarta', 'Jawa Barat', 'Jawa Tengah',
    'Jawa Timur', 'Banten', 'Bali', 'Sumatera Utara',
    'Sumatera Selatan', 'Kalimantan Timur',
  ];

  static const Map<String, List<String>> _kotaByProvinsi = {
    'DI Yogyakarta': ['Kota Yogyakarta', 'Sleman', 'Bantul', 'Kulon Progo', 'Gunungkidul'],
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Utara', 'Jakarta Barat', 'Jakarta Selatan', 'Jakarta Timur'],
    'Jawa Barat': ['Kota Bandung', 'Kota Bogor', 'Kota Bekasi', 'Depok', 'Cimahi'],
    'Jawa Tengah': ['Kota Semarang', 'Kota Solo', 'Kota Magelang', 'Cilacap', 'Purwokerto'],
    'Jawa Timur': ['Kota Surabaya', 'Kota Malang', 'Kota Kediri', 'Sidoarjo', 'Gresik'],
  };

  static const Map<String, List<String>> _kecamatanByKota = {
    'Kota Yogyakarta': ['Danurejan', 'Gedongtengen', 'Gondokusuman', 'Gondomanan', 'Jetis'],
    'Sleman': ['Depok', 'Mlati', 'Gamping', 'Godean', 'Moyudan'],
    'Bantul': ['Bantul', 'Sewon', 'Kasihan', 'Pajangan', 'Pandak'],
    'Kota Bandung': ['Coblong', 'Sukasari', 'Sukajadi', 'Cidadap', 'Cibeunying'],
    'Kota Surabaya': ['Gubeng', 'Wonokromo', 'Rungkut', 'Sukolilo', 'Tambaksari'],
  };

  static const Map<String, List<String>> _desaByKecamatan = {
    'Danurejan': ['Bausasran', 'Suryatmajan', 'Tegalpanggung'],
    'Depok': ['Catur Tunggal', 'Condong Catur', 'Maguwoharjo', 'Sariharjo'],
    'Bantul': ['Bantul', 'Ringinharjo', 'Trirenggo', 'Palbapang'],
    'Coblong': ['Cipaganti', 'Dago', 'Lebak Gede', 'Lebak Siliwangi'],
    'Gubeng': ['Airlangga', 'Baratajaya', 'Gubeng', 'Kertajaya'],
  };

  // Helper: ambil list berdasarkan pilihan level atas
  List<String> get _kotaList =>
      _selectedProvinsi != null
          ? (_kotaByProvinsi[_selectedProvinsi] ?? [])
          : [];

  List<String> get _kecamatanList =>
      _selectedKota != null
          ? (_kecamatanByKota[_selectedKota] ?? [])
          : [];

  List<String> get _desaList =>
      _selectedKecamatan != null
          ? (_desaByKecamatan[_selectedKecamatan] ?? [])
          : [];

  void _onDaftar(Map<String, dynamic> dataPribadi) {
    if (_formKey.currentState?.validate() ?? false) {
      // Validasi data pribadi yang diperlukan
      final email = dataPribadi['email'] as String?;
      final password = dataPribadi['password'] as String?;
      final name = dataPribadi['name'] as String?;
      final classIdRaw = dataPribadi['classId'];
      final gender = dataPribadi['gender'] as String?;
      final dateOfBirth = dataPribadi['date_of_birth'] as String?;
      final telephoneNumber = dataPribadi['telephone_number'] as String?;

      // Validasi field yang required
      if (email == null || password == null || name == null ||
          classIdRaw == null || gender == null || dateOfBirth == null ||
          telephoneNumber == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data pribadi tidak lengkap. Silakan ulangi dari awal.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Konversi classId ke int
      final classId = classIdRaw is int ? classIdRaw : int.tryParse(classIdRaw.toString());
      if (classId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID kelas tidak valid.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final request = RegisterStudentRequest(
        email: email,
        password: password,
        name: name,
        classId: classId,
        gender: gender,
        dateOfBirth: dateOfBirth,
        telephoneNumber: telephoneNumber,
        province: _selectedProvinsi ?? '',
        regency: _selectedKota ?? '',
        district: _selectedKecamatan ?? '',
        subdistrict: _selectedDesa ?? '',
      );

      context.read<AuthCubit>().studentRegister(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataPribadi = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi Berhasil!'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pushNamedAndRemoveUntil('/siswa/beranda', (route) => false);
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: AppColors.errorRed),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
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

                          // ── Back Button ─────────────────────────
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),

                          const SizedBox(height: 20),

                          // ── Logo + Nama ──────────────────────────
                          const LogoWithName(),

                          const SizedBox(height: 28),

                          // ── Judul ────────────────────────────────
                          const Text('Detail Alamat',
                              style: AppTextStyles.heading2),

                          const SizedBox(height: 20),

                          // ── Provinsi ─────────────────────────────
                          _buildDropdownSection(
                            label: 'Provinsi',
                            hint: 'Pilih Provinsi',
                            value: _selectedProvinsi,
                            items: _provinsiList,
                            isEnabled: true,
                            onChanged: (v) => setState(() {
                              _selectedProvinsi = v;
                              // Reset pilihan bawah
                              _selectedKota = null;
                              _selectedKecamatan = null;
                              _selectedDesa = null;
                            }),
                            validator: (v) =>
                                v == null ? 'Provinsi wajib dipilih' : null,
                          ),

                          const SizedBox(height: 16),

                          // ── Kota/Kabupaten ────────────────────────
                          _buildDropdownSection(
                            label: 'Kota/Kabupaten',
                            hint: 'Pilih Kota/Kabupaten',
                            value: _selectedKota,
                            items: _kotaList,
                            isEnabled: _selectedProvinsi != null,
                            onChanged: (v) => setState(() {
                              _selectedKota = v;
                              _selectedKecamatan = null;
                              _selectedDesa = null;
                            }),
                            validator: (v) =>
                                v == null ? 'Kota/Kabupaten wajib dipilih' : null,
                          ),

                          const SizedBox(height: 16),

                          // ── Kecamatan ─────────────────────────────
                          _buildDropdownSection(
                            label: 'Kecamatan',
                            hint: 'Pilih Kecamatan',
                            value: _selectedKecamatan,
                            items: _kecamatanList,
                            isEnabled: _selectedKota != null,
                            onChanged: (v) => setState(() {
                              _selectedKecamatan = v;
                              _selectedDesa = null;
                            }),
                            validator: (v) =>
                                v == null ? 'Kecamatan wajib dipilih' : null,
                          ),

                          const SizedBox(height: 16),

                          // ── Desa/Kelurahan ────────────────────────
                          _buildDropdownSection(
                            label: 'Desa/Kelurahan',
                            hint: 'Pilih Desa/Kelurahan',
                            value: _selectedDesa,
                            items: _desaList,
                            isEnabled: _selectedKecamatan != null,
                            onChanged: (v) =>
                                setState(() => _selectedDesa = v),
                            validator: (v) =>
                                v == null ? 'Desa/Kelurahan wajib dipilih' : null,
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // ── Tombol Daftar Sekarang (sticky bottom) ───────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: PrimaryButton(
                      label: 'Daftar Sekarang',
                      onPressed: () => _onDaftar(dataPribadi),
                      isLoading: state is AuthLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper: satu blok label + dropdown ──────────────────────
  Widget _buildDropdownSection({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required bool isEnabled,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Opacity(
          opacity: isEnabled ? 1.0 : 0.45,
          child: IgnorePointer(
            ignoring: !isEnabled,
            child: DropdownButtonFormField<String>(
              value: value,
              onChanged: onChanged,
              validator: validator,
              icon: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: AppColors.textSecondary,
              ),
              decoration: AppTheme.inputDecoration(hint: hint),
              hint: Text(
                hint,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              dropdownColor: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(12),
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}