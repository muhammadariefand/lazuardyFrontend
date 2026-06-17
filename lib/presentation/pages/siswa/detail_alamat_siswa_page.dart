import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';

class DetailAlamatSiswaPage extends StatefulWidget {
  const DetailAlamatSiswaPage({super.key});

  @override
  State<DetailAlamatSiswaPage> createState() => _DetailAlamatSiswaPageState();
}

class _DetailAlamatSiswaPageState extends State<DetailAlamatSiswaPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegionCubit>().fetchProvinces();
    });
  }

  void _onDaftar(Map<String, dynamic> dataPribadi) {
    if (_formKey.currentState?.validate() ?? false) {
      // Ambil state terkini dari RegionCubit
      final regionState = context.read<RegionCubit>().state;

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

      // Pastikan semua wilayah sudah terpilih
      if (regionState.selectedProvince == null ||
          regionState.selectedRegency == null ||
          regionState.selectedDistrict == null ||
          regionState.selectedSubdistrict == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap lengkapi semua pilihan wilayah alamat Anda.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Request API dengan mengirim 'name' wilayahnya saja sesuai kontrak JSON
      final request = RegisterStudentRequest(
        email: email,
        password: password,
        name: name,
        classId: classId,
        gender: gender,
        dateOfBirth: dateOfBirth,
        telephoneNumber: telephoneNumber,
        province: regionState.selectedProvince!.name,
        regency: regionState.selectedRegency!.name,
        district: regionState.selectedDistrict!.name,
        subdistrict: regionState.selectedSubdistrict!.name,
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
        listener: (context, authState) {
          if (authState is RegisterStudentSuccess || authState is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi Berhasil!'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pushNamedAndRemoveUntil('/siswa/beranda', (route) => false);
          }
          if (authState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(authState.error), backgroundColor: AppColors.errorRed),
            );
          }
        },
        builder: (context, authState) {
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
                            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),

                          const SizedBox(height: 20),

                          // ── Logo + Nama ──────────────────────────
                          const LogoWithName(),

                          const SizedBox(height: 28),

                          // ── Judul ────────────────────────────────
                          const Text('Detail Alamat', style: AppTextStyles.heading2),

                          const SizedBox(height: 20),

                          // ── Dropdown Wilayah (Dibungkus RegionCubit) ──
                          BlocBuilder<RegionCubit, RegionState>(
                            builder: (context, regionState) {
                              return Column(
                                children: [
                                  // ── Provinsi ──
                                  _buildDropdownSection(
                                    label: 'Provinsi',
                                    hint: regionState.isLoading 
                                        ? 'Sedang memuat...' 
                                        : (regionState.provinces.isEmpty ? 'Gagal memuat data / Kosong' : 'Pilih Provinsi'),
                                    value: regionState.selectedProvince,
                                    items: regionState.provinces,
                                    // Tetap aktifkan jika sedang loading agar user bisa melihat hint "Sedang memuat"
                                    isEnabled: !regionState.isLoading && regionState.provinces.isNotEmpty, 
                                    onChanged: (v) {
                                      if (v != null) {
                                        context.read<RegionCubit>().selectProvince(v);
                                      }
                                    },
                                    validator: (v) => v == null ? 'Provinsi wajib dipilih' : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Kota/Kabupaten ──
                                  _buildDropdownSection(
                                    label: 'Kota/Kabupaten',
                                    hint: 'Pilih Kota/Kabupaten',
                                    value: regionState.selectedRegency,
                                    items: regionState.regencies,
                                    isEnabled: regionState.regencies.isNotEmpty,
                                    onChanged: (v) {
                                      if (v != null) {
                                        // Cukup panggil ini, Cubitmu akan otomatis ambil data Kecamatan
                                        context.read<RegionCubit>().selectRegency(v);
                                      }
                                    },
                                    validator: (v) => v == null ? 'Kota/Kabupaten wajib dipilih' : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Kecamatan ──
                                  _buildDropdownSection(
                                    label: 'Kecamatan',
                                    hint: 'Pilih Kecamatan',
                                    value: regionState.selectedDistrict,
                                    items: regionState.districts,
                                    isEnabled: regionState.districts.isNotEmpty,
                                    onChanged: (v) {
                                      if (v != null) {
                                        // Cukup panggil ini, Cubitmu akan otomatis ambil data Desa
                                        context.read<RegionCubit>().selectDistrict(v);
                                      }
                                    },
                                    validator: (v) => v == null ? 'Kecamatan wajib dipilih' : null,
                                  ),

                                  const SizedBox(height: 16),

                                  // ── Desa/Kelurahan ──
                                  _buildDropdownSection(
                                    label: 'Desa/Kelurahan',
                                    hint: 'Pilih Desa/Kelurahan',
                                    value: regionState.selectedSubdistrict,
                                    items: regionState.subdistricts,
                                    isEnabled: regionState.subdistricts.isNotEmpty,
                                    onChanged: (v) {
                                      if (v != null) {
                                        context.read<RegionCubit>().selectSubdistrict(v);
                                      }
                                    },
                                    validator: (v) => v == null ? 'Desa/Kelurahan wajib dipilih' : null,
                                  ),
                                ],
                              );
                            },
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
                      isLoading: authState is AuthLoading,
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

  // ── Helper: satu blok label + dropdown yang diubah menerima RegionEntity ──
  Widget _buildDropdownSection({
    required String label,
    required String hint,
    required RegionEntity? value,
    required List<RegionEntity> items,
    required bool isEnabled,
    required ValueChanged<RegionEntity?> onChanged,
    required FormFieldValidator<RegionEntity>? validator,
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
            child: DropdownButtonFormField<RegionEntity>(
              value: items.contains(value) ? value : null, // Mencegah crash jika value tidak ada di dalam list (saat reset)
              onChanged: onChanged,
              validator: validator,
              icon: const Icon(
                Icons.keyboard_arrow_up_rounded,
                color: AppColors.textSecondary,
              ),
              decoration: AppTheme.inputDecoration(hint: hint),
              hint: Text(
                hint,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              dropdownColor: AppColors.bgWhite,
              borderRadius: BorderRadius.circular(12),
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<RegionEntity>(
                  value: item,
                  child: Text(item.name), // Menampilkan string .name ke user
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}