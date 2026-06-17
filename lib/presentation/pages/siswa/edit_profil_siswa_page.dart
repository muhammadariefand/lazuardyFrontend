import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_state.dart';


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
  String? _provinsi;
  String? _kota;
  String? _kecamatan;
  String? _desa;

  // We add 'kelas 1' to match JSON for simplicity, and some mock regions
  static const _kelasList = [
    'kelas 1','Kelas 1 SD','Kelas 2 SD','Kelas 3 SD','Kelas 4 SD','Kelas 5 SD','Kelas 6 SD',
    'Kelas 7 SMP','Kelas 8 SMP','Kelas 9 SMP',
    'Kelas 10 SMA','Kelas 11 SMA','3 SMA',
  ];
  static const _jkList = ['Laki-laki','Perempuan'];
  static const _provinsiList = ['DI Yogyakarta','DKI Jakarta','Jawa Barat','Jawa Tengah','Jawa Timur'];
  
  static const _kotaList = {
    'DI Yogyakarta': ['Kota Yogyakarta','Kab. Sleman','Bantul','Kulon Progo','Gunungkidul'],
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Selatan', 'Jakarta Barat']
  };
  
  static const _kecamatanList = {
    'Kab. Sleman': ['Depok','Mlati','Gamping','Godean'],
    'Jakarta Pusat': ['Tanah Abang', 'Menteng']
  };
  
  static const _desaList = {
    'Depok': ['Catur Tunggal','Condong Catur','Maguwoharjo','Caturtunggal'],
    'Tanah Abang': ['Bendungan Hilir', 'Karet Tengsin']
  };

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    final state = context.read<StudentProfileCubit>().state;
    if (state is StudentProfileLoaded) {
      final bio = state.biodata;
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
        if (_provinsiList.contains(bio.homeAddress!.province)) {
          _provinsi = bio.homeAddress!.province;
        } else {
          // just to ensure it shows if the list is limited
          _provinsi = null; 
        }

        if (_provinsi != null && (_kotaList[_provinsi]?.contains(bio.homeAddress!.regency) ?? false)) {
          _kota = bio.homeAddress!.regency;
        }

        if (_kota != null && (_kecamatanList[_kota]?.contains(bio.homeAddress!.district) ?? false)) {
          _kecamatan = bio.homeAddress!.district;
        }

        if (_kecamatan != null && (_desaList[_kecamatan]?.contains(bio.homeAddress!.subdistrict) ?? false)) {
          _desa = bio.homeAddress!.subdistrict;
        }
      }
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

    final requestData = <String, dynamic>{
      if (_namaCtrl.text.isNotEmpty) 'name': _namaCtrl.text,
      if (_classId != null) 'class_id': _classId, // Ideally selected from dropdown mapping
      if (_waCtrl.text.isNotEmpty) 'telephone_number': _waCtrl.text,
      if (formattedDate != null) 'date_of_birth': formattedDate,
      if (genderVal != null) 'gender': genderVal,
      if (_provinsi != null) 'province': _provinsi,
      if (_kota != null) 'regency': _kota,
      if (_kecamatan != null) 'district': _kecamatan,
      if (_desa != null) 'subdistrict': _desa,
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
        if (state is StudentProfileUpdateSuccess) {
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

              // Detail Alamat
              _buildCard('Detail Alamat', [
                _dropdown('Provinsi', _provinsi, _provinsiList, (v) => setState(() {
                      _provinsi = v;
                      _kota = null;
                      _kecamatan = null;
                      _desa = null;
                    })),
                _dropdown('Kota/Kabupaten', _kota, _kotaList[_provinsi] ?? [], (v) => setState(() {
                      _kota = v;
                      _kecamatan = null;
                      _desa = null;
                    })),
                _dropdown('Kecamatan', _kecamatan, _kecamatanList[_kota] ?? [], (v) => setState(() {
                      _kecamatan = v;
                      _desa = null;
                    })),
                _dropdown('Desa/Kelurahan', _desa, _desaList[_kecamatan] ?? [], (v) => setState(() => _desa = v)),
              ]),

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
}