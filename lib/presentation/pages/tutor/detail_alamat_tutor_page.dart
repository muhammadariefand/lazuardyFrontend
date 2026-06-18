import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/shared_widget.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_registration/tutor_registration_state.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';

class DetailAlamatTutorPage extends StatefulWidget {
  const DetailAlamatTutorPage({super.key});

  @override
  State<DetailAlamatTutorPage> createState() => _DetailAlamatTutorPageState();
}

class _DetailAlamatTutorPageState extends State<DetailAlamatTutorPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegionCubit>().fetchProvinces();
    });
  }

  void _onSelanjutnya() {
    if (_formKey.currentState?.validate() ?? false) {
      final regionState = context.read<RegionCubit>().state;

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

      context.read<TutorRegistrationCubit>().saveAddress(
            province: regionState.selectedProvince!.name,
            regency: regionState.selectedRegency!.name,
            district: regionState.selectedDistrict!.name,
            subdistrict: regionState.selectedSubdistrict!.name,
          );
      Navigator.of(context).pushNamed('/tutor/formulir-pendaftaran');
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

              // ── Tombol Selanjutnya (sticky bottom) ───────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: BlocBuilder<TutorRegistrationCubit, TutorRegistrationState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: 'Selanjutnya',
                      onPressed: _onSelanjutnya,
                      isLoading: state is TutorRegistrationLoading,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper: satu blok label + dropdown ──────────────────────
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
                  .map((item) => DropdownMenuItem<RegionEntity>(
                        value: item,
                        child: Text(item.name),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}