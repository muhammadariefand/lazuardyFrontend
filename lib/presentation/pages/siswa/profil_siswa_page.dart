// lib/presentation/pages/siswa/profil_siswa_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';

const _teal = Color(0xFF3AAFA9);

class ProfilSiswaPage extends StatefulWidget {
  const ProfilSiswaPage({super.key});

  @override
  State<ProfilSiswaPage> createState() => _ProfilSiswaPageState();
}

class _ProfilSiswaPageState extends State<ProfilSiswaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentProfileCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SiswaBottomNav(currentIndex: 3, onTap: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/siswa/beranda');
        if (i == 1) Navigator.pushReplacementNamed(context, '/siswa/jadwal');
        if (i == 2) Navigator.pushReplacementNamed(context, '/siswa/laporan');
      }),
      body: Column(children: [
        Container(color: _teal, padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(alignment: Alignment.centerLeft,
            child: Text('Profil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)))),

        Expanded(
          child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
            builder: (context, state) {
              if (state is StudentProfileLoading || state is StudentProfileInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is StudentProfileError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<StudentProfileCubit>().loadProfile(),
                          child: const Text('Coba Lagi'),
                        )
                      ],
                    ),
                  ),
                );
              }

              if (state is StudentProfileLoaded) {
                final biodata = state.biodata;
                final initialName = biodata.name != null && biodata.name!.isNotEmpty 
                    ? biodata.name![0].toUpperCase() 
                    : '?';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    const SizedBox(height: 8),

                    // Header user
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _teal.withOpacity(0.4)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Row(children: [
                        if (biodata.profilePhotoUrl != null && biodata.profilePhotoUrl!.isNotEmpty)
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(biodata.profilePhotoUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 64, height: 64, decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                            alignment: Alignment.center, child: Text(initialName, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.grey.shade600)),
                          ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(biodata.name ?? '-',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          Text(biodata.email ?? '-', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(biodata.telephoneNumber ?? '-', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          SizedBox(width: 100, height: 32, child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/siswa/edit-profil'),
                            style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white, elevation: 0,
                              padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                            child: const Text('Edit Profil', style: TextStyle(fontSize: 12)),
                          )),
                        ])),
                      ]),
                    ),

                    const SizedBox(height: 16),

                    // Detail Pribadi (read-only)
                    _buildSection('Detail Pribadi', [
                      _FieldView('Nama Lengkap', biodata.name ?? '-'),
                      _FieldView('Kelas', biodata.className ?? '-'),
                      _FieldView('Jenis Kelamin', biodata.gender ?? '-'),
                      _FieldView('Tanggal Lahir', biodata.dateOfBirth?.split(' ')[0] ?? '-'),
                      _FieldView('Nomor WhatsApp', biodata.telephoneNumber ?? '-'),
                    ]),

                    const SizedBox(height: 16),

                    // Detail Alamat (read-only)
                    _buildSection('Detail Alamat', [
                      _FieldView('Provinsi', biodata.homeAddress?.province ?? '-'),
                      _FieldView('Kota/Kabupaten', biodata.homeAddress?.regency ?? '-'),
                      _FieldView('Kecamatan', biodata.homeAddress?.district ?? '-'),
                      _FieldView('Desa/Kelurahan', biodata.homeAddress?.subdistrict ?? '-'),
                    ]),

                    const SizedBox(height: 24),
                  ]),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildSection(String title, List<_FieldView> fields) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _teal.withOpacity(0.4)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 14),
      ...fields.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200)),
            child: Text(f.value, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary))),
        ]),
      )),
    ]),
  );
}

class _FieldView {
  final String label, value;
  const _FieldView(this.label, this.value);
}