import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_state.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';


class EditProfilSiswaPage extends StatefulWidget {
  const EditProfilSiswaPage({super.key});
  @override
  State<EditProfilSiswaPage> createState() => _EditProfilSiswaPageState();
}

class _EditProfilSiswaPageState extends State<EditProfilSiswaPage> {
  final _namaCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();

  int? _classId;
  String? _kelas;
  String? _jenisKelamin;

  // We add 'kelas 1' to match JSON for simplicity, and some mock regions
  static const _kelasList = [
    'kelas 1','Kelas 1 SD','Kelas 2 SD','Kelas 3 SD','Kelas 4 SD','Kelas 5 SD','Kelas 6 SD',
    'Kelas 7 SMP','Kelas 8 SMP','Kelas 9 SMP',
    'Kelas 10 SMA','Kelas 11 SMA','3 SMA',
  ];
  static const _jkList = ['Laki-laki','Perempuan'];

  @override
  void initState() {
    super.initState();
    context.read<StudentProfileCubit>().loadProfile();
    // Default fetch provinces immediately so the dropdown starts loading
    context.read<RegionCubit>().fetchProvinces();
  }

  void _initData(dynamic bio) {
    _namaCtrl.text = bio.name ?? '';
    _waCtrl.text = bio.telephoneNumber ?? '';
    
    if (bio.dateOfBirth != null && bio.dateOfBirth!.length >= 10) {
      // Assume format YYYY-MM-DD HH:MM:SS from JSON, slice to YYYY-MM-DD
      final ymd = bio.dateOfBirth!.substring(0, 10).split('-');
      if (ymd.length == 3) {
        _tglLahirCtrl.text = '${ymd[2]}/${ymd[1]}/${ymd[0]}';
      }
    }

    if (bio.className != null && _kelasList.contains(bio.className)) {
      _kelas = bio.className;
    }
    _classId = bio.classId;

    if (bio.gender != null) {
      if (bio.gender!.toLowerCase() == 'male' || bio.gender!.toLowerCase() == 'laki-laki') {
        _jenisKelamin = 'Laki-laki';
      } else if (bio.gender!.toLowerCase() == 'female' || bio.gender!.toLowerCase() == 'perempuan') {
        _jenisKelamin = 'Perempuan';
      }
    }

    if (bio.homeAddress != null) {
      context.read<RegionCubit>().prefillRegions(
        provinceName: bio.homeAddress!.province,
        regencyName: bio.homeAddress!.regency,
        districtName: bio.homeAddress!.district,
        subdistrictName: bio.homeAddress!.subdistrict,
      );
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _waCtrl.dispose();
    _tglLahirCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 8, 20),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      _tglLahirCtrl.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void _onSimpan() {
    FocusScope.of(context).unfocus();

    String? formattedDate;
    if (_tglLahirCtrl.text.isNotEmpty) {
      final parts = _tglLahirCtrl.text.split('/');
      if (parts.length == 3) {
        formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}'; // YYYY-MM-DD
      }
    }

    String? genderVal;
    if (_jenisKelamin == 'Laki-laki') genderVal = 'male';
    if (_jenisKelamin == 'Perempuan') genderVal = 'female';

    final regionState = context.read<RegionCubit>().state;
    final prov = regionState.selectedProvince?.name;
    final reg = regionState.selectedRegency?.name;
    final dist = regionState.selectedDistrict?.name;
    final subdist = regionState.selectedSubdistrict?.name;

    final requestData = <String, dynamic>{
      if (_namaCtrl.text.isNotEmpty) 'name': _namaCtrl.text,
      if (_classId != null) 'class_id': _classId, // Ideally selected from dropdown mapping
      if (_waCtrl.text.isNotEmpty) 'telephone_number': _waCtrl.text,
      if (formattedDate != null) 'date_of_birth': formattedDate,
      if (genderVal != null) 'gender': genderVal,
      if (prov != null) 'province': prov,
      if (reg != null) 'regency': reg,
      if (dist != null) 'district': dist,
      if (subdist != null) 'subdistrict': subdist,
      // Default to Islam for demo
      'religion': 'islam',
    };

    context.read<StudentProfileCubit>().updateBiodata(requestData);
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.successGreen, width: 2.5),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.successGreen, size: 38),
              ),
              const SizedBox(height: 20),
              const Text('Berhasil!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Load the profile again to get fresh data
                    context.read<StudentProfileCubit>().loadProfile();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kembali ke Profil', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentProfileCubit, StudentProfileState>(
      listener: (context, state) {
        if (state is StudentProfileLoaded) {
          _initData(state.biodata);
        } else if (state is StudentProfileUpdateSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is StudentProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is StudentPhotoUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.read<StudentProfileCubit>().loadProfile();
        } else if (state is StudentPhotoUploadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          title: const Text('Edit Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ),
        bottomNavigationBar: BlocBuilder<StudentProfileCubit, StudentProfileState>(
          builder: (context, state) {
            final isLoading = state is StudentProfileUpdating || state is StudentPhotoUploading;
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onSimpan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : const Text('Simpan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Avatar + camera icon
              BlocBuilder<StudentProfileCubit, StudentProfileState>(
                builder: (context, state) {
                  String? photoUrl;
                  if (state is StudentProfileLoaded) {
                    photoUrl = state.biodata.profilePhotoUrl;
                  }

                  return GestureDetector(
                    onTap: () {
                      // Call uploadProfilePhoto logic here, using mock or image picker
                      // For now, let's just trigger a dummy upload error or success
                      // Normally this would open image_picker
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: photoUrl != null && photoUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(photoUrl, width: 80, height: 80, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Text('M', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
                                )
                              : Text('M', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Detail Pribadi
              _buildCard('Detail Pribadi', [
                _field('Nama Lengkap', _namaCtrl),
                _dropdown('Kelas', _kelas, _kelasList, (v) {
                  setState(() {
                    _kelas = v;
                    _classId = 1; // dummy class id logic
                  });
                }),
                _dropdown('Jenis Kelamin', _jenisKelamin, _jkList, (v) => setState(() => _jenisKelamin = v)),
                _datePicker('Tanggal Lahir', _tglLahirCtrl),
                _phoneField('Nomor WhatsApp', _waCtrl),
              ]),

              const SizedBox(height: 16),

              BlocBuilder<RegionCubit, RegionState>(
                builder: (context, regionState) {
                  return _buildCard('Detail Alamat', [
                    _buildDropdownSection(
                      label: 'Provinsi',
                      hint: regionState.isLoading 
                          ? 'Sedang memuat...' 
                          : (regionState.provinces.isEmpty ? 'Gagal memuat data / Kosong' : 'Pilih Provinsi'),
                      value: regionState.selectedProvince,
                      items: regionState.provinces,
                      isEnabled: !regionState.isLoading && regionState.provinces.isNotEmpty,
                      onChanged: (val) {
                        if (val != null) context.read<RegionCubit>().selectProvince(val);
                      },
                    ),
                    _buildDropdownSection(
                      label: 'Kota/Kabupaten',
                      hint: 'Pilih Kota/Kabupaten',
                      value: regionState.selectedRegency,
                      items: regionState.regencies,
                      isEnabled: regionState.regencies.isNotEmpty && regionState.selectedProvince != null,
                      onChanged: (val) {
                        if (val != null) context.read<RegionCubit>().selectRegency(val);
                      },
                    ),
                    _buildDropdownSection(
                      label: 'Kecamatan',
                      hint: 'Pilih Kecamatan',
                      value: regionState.selectedDistrict,
                      items: regionState.districts,
                      isEnabled: regionState.districts.isNotEmpty && regionState.selectedRegency != null,
                      onChanged: (val) {
                        if (val != null) context.read<RegionCubit>().selectDistrict(val);
                      },
                    ),
                    _buildDropdownSection(
                      label: 'Desa/Kelurahan',
                      hint: 'Pilih Desa/Kelurahan',
                      value: regionState.selectedSubdistrict,
                      items: regionState.subdistricts,
                      isEnabled: regionState.subdistricts.isNotEmpty && regionState.selectedDistrict != null,
                      onChanged: (val) {
                        if (val != null) context.read<RegionCubit>().selectSubdistrict(val);
                      },
                    ),
                  ]);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> fields) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            ...fields,
          ],
        ),
      );

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)));

  InputDecoration _inputDeco({String? hint, Widget? prefix, Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      );

  Widget _field(String label, TextEditingController ctrl, {String? hint}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(controller: ctrl, decoration: _inputDeco(hint: hint ?? label)),
      ]));

  Widget _phoneField(String label, TextEditingController ctrl, {String? hint}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDeco(hint: hint, prefix: const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 18))),
      ]));

  Widget _datePicker(String label, TextEditingController ctrl) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
            controller: ctrl,
            readOnly: true,
            onTap: _pickDate,
            decoration: _inputDeco(prefix: const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18))),
      ]));

  Widget _dropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    // Determine enabled state based on parent dropdown selection
    final enabled = items.isNotEmpty;
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label(label),
          Opacity(
              opacity: enabled ? 1 : 0.45,
              child: DropdownButtonFormField<String>(
                value: (value != null && items.contains(value)) ? value : null,
                onChanged: enabled ? onChanged : null,
                decoration: _inputDeco(hint: 'Pilih $label'),
                icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textSecondary),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                isExpanded: true,
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
              )),
        ]));
  }

  Widget _buildDropdownSection({
    required String label,
    required String hint,
    required RegionEntity? value,
    required List<RegionEntity> items,
    required bool isEnabled,
    required ValueChanged<RegionEntity?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          Opacity(
            opacity: isEnabled ? 1.0 : 0.45,
            child: IgnorePointer(
              ignoring: !isEnabled,
              child: DropdownButtonFormField<RegionEntity>(
                value: items.contains(value) ? value : null,
                onChanged: onChanged,
                decoration: _inputDeco(hint: hint),
                icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textSecondary),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                isExpanded: true,
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.name, style: const TextStyle(fontSize: 13)))).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}