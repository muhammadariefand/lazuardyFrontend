import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_state.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_state.dart';


class EditProfilTutorPage extends StatefulWidget {
  const EditProfilTutorPage({super.key});
  @override
  State<EditProfilTutorPage> createState() => _EditProfilTutorPageState();
}

class _EditProfilTutorPageState extends State<EditProfilTutorPage> {
  // ── Controllers ────────────────────────────────────────────────
  final _namaCtrl      = TextEditingController();
  final _waCtrl        = TextEditingController();
  final _tglLahirCtrl  = TextEditingController();
  final _rekeningCtrl  = TextEditingController();

  // ── Dropdown values ────────────────────────────────────────────
  String? _jenisKelamin;
  String? _bank;
  String? _provinsi;
  String? _kota;
  String? _kecamatan;
  String? _desa;

  // ── Lists ──────────────────────────────────────────────────────
  static const _jkList      = ['Laki-laki', 'Perempuan'];
  static const _bankList    = ['BCA', 'BRI', 'BNI', 'BSI', 'Mandiri', 'CIMB', 'Danamon'];

  @override
  void initState() {
    super.initState();
    context.read<TutorProfileCubit>().fetchProfile();
    context.read<RegionCubit>().fetchProvinces();
  }

  void _initData(dynamic bio) {
    _namaCtrl.text = bio.name;
    _waCtrl.text = bio.telephoneNumber ?? '';
    _rekeningCtrl.text = bio.accountNumber ?? '';
    
    if (bio.dateOfBirth != null && bio.dateOfBirth!.length >= 10) {
      // Assume format YYYY-MM-DD, slice to YYYY-MM-DD
      final ymd = bio.dateOfBirth!.substring(0, 10).split('-');
      if (ymd.length == 3) {
        _tglLahirCtrl.text = '${ymd[2]}/${ymd[1]}/${ymd[0]}';
      }
    }

    if (bio.gender != null) {
      if (bio.gender!.toLowerCase() == 'male' || bio.gender!.toLowerCase() == 'laki-laki') {
        _jenisKelamin = 'Laki-laki';
      } else if (bio.gender!.toLowerCase() == 'female' || bio.gender!.toLowerCase() == 'perempuan') {
        _jenisKelamin = 'Perempuan';
      }
    }

    if (bio.bankCode != null && _bankList.contains(bio.bankCode)) {
      _bank = bio.bankCode;
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
    _rekeningCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 5, 14),
      firstDate: DateTime(1950),
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

    final requestData = <String, dynamic>{
      if (_namaCtrl.text.isNotEmpty) 'name': _namaCtrl.text,
      if (_waCtrl.text.isNotEmpty) 'telephone_number': _waCtrl.text,
      if (formattedDate != null) 'date_of_birth': formattedDate,
      if (genderVal != null) 'gender': genderVal,
      if (_bank != null) 'bank_code': _bank,
      if (_rekeningCtrl.text.isNotEmpty) 'account_number': _rekeningCtrl.text,
      if (regionState.selectedProvince != null) 'province': regionState.selectedProvince!.name,
      if (regionState.selectedRegency != null) 'regency': regionState.selectedRegency!.name,
      if (regionState.selectedDistrict != null) 'district': regionState.selectedDistrict!.name,
      if (regionState.selectedSubdistrict != null) 'subdistrict': regionState.selectedSubdistrict!.name,
    };

    context.read<TutorProfileCubit>().updateBiodata(requestData);
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
                    context.read<TutorProfileCubit>().fetchProfile();
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
    return BlocListener<TutorProfileCubit, TutorProfileState>(
      listener: (context, state) {
        if (state is TutorProfileLoaded) {
          _initData(state.tutor);
        } else if (state is TutorProfileUpdateSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is TutorProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is TutorPhotoUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TutorProfileCubit>().fetchProfile();
        } else if (state is TutorPhotoUploadError) {
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
        bottomNavigationBar: BlocBuilder<TutorProfileCubit, TutorProfileState>(
          builder: (context, state) {
            final isLoading = state is TutorProfileUpdating || state is TutorPhotoUploading;
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
              BlocBuilder<TutorProfileCubit, TutorProfileState>(
                builder: (context, state) {
                  String? photoUrl;
                  if (state is TutorProfileLoaded) {
                    photoUrl = state.tutor.profilePhotoUrl;
                  }

                  return GestureDetector(
                    onTap: () {
                      // Call uploadProfilePhoto logic here
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
                                    errorBuilder: (_, __, ___) => Text('T', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
                                )
                              : Text('T', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
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
                _dropdown('Jenis Kelamin', _jenisKelamin, _jkList, (v) => setState(() => _jenisKelamin = v)),
                _datePicker('Tanggal Lahir', _tglLahirCtrl),
                _phoneField('Nomor WhatsApp', _waCtrl),
              ]),

              const SizedBox(height: 16),

              // Informasi Rekening
              _buildCard('Informasi Rekening', [
                _dropdown('Pilih Bank', _bank, _bankList, (v) => setState(() => _bank = v)),
                _field('Nomor Rekening', _rekeningCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
              ]),

              const SizedBox(height: 16),

              // Detail Alamat
              BlocBuilder<RegionCubit, RegionState>(
                builder: (context, regionState) {
                  return _buildCard('Detail Alamat', [
                    // Dropdown Provinsi
                    _dropdownRegion<String>(
                      'Provinsi',
                      regionState.selectedProvince?.id,
                      regionState.provinces.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name, style: const TextStyle(fontSize: 13)))).toList(),
                      (val) {
                        if (val != null) {
                          final selected = regionState.provinces.firstWhere((p) => p.id == val);
                          context.read<RegionCubit>().selectProvince(selected);
                        }
                      },
                      isEnabled: regionState.provinces.isNotEmpty,
                    ),
                    // Dropdown Kota
                    _dropdownRegion<String>(
                      'Kota/Kabupaten',
                      regionState.selectedRegency?.id,
                      regionState.regencies.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name, style: const TextStyle(fontSize: 13)))).toList(),
                      (val) {
                        if (val != null) {
                          final selected = regionState.regencies.firstWhere((r) => r.id == val);
                          context.read<RegionCubit>().selectRegency(selected);
                        }
                      },
                      isEnabled: regionState.regencies.isNotEmpty,
                    ),
                    // Dropdown Kecamatan
                    _dropdownRegion<String>(
                      'Kecamatan',
                      regionState.selectedDistrict?.id,
                      regionState.districts.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name, style: const TextStyle(fontSize: 13)))).toList(),
                      (val) {
                        if (val != null) {
                          final selected = regionState.districts.firstWhere((d) => d.id == val);
                          context.read<RegionCubit>().selectDistrict(selected);
                        }
                      },
                      isEnabled: regionState.districts.isNotEmpty,
                    ),
                    // Dropdown Desa
                    _dropdownRegion<String>(
                      'Desa/Kelurahan',
                      regionState.selectedSubdistrict?.id,
                      regionState.subdistricts.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, style: const TextStyle(fontSize: 13)))).toList(),
                      (val) {
                        if (val != null) {
                          final selected = regionState.subdistricts.firstWhere((s) => s.id == val);
                          context.read<RegionCubit>().selectSubdistrict(selected);
                        }
                      },
                      isEnabled: regionState.subdistricts.isNotEmpty,
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

  Widget _field(String label, TextEditingController ctrl, {String? hint, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label(label),
        TextFormField(
          controller: ctrl,
          decoration: _inputDeco(hint: hint ?? label),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
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

  Widget _dropdownRegion<T>(String label, T? value, List<DropdownMenuItem<T>> items, ValueChanged<T?> onChanged, {bool isEnabled = true}) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label(label),
          Opacity(
              opacity: isEnabled ? 1 : 0.45,
              child: DropdownButtonFormField<T>(
                value: value,
                onChanged: isEnabled ? onChanged : null,
                decoration: _inputDeco(hint: 'Pilih $label'),
                icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.textSecondary),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                isExpanded: true,
                items: items,
              )),
        ]));
  }
}