// lib/presentation/pages/tutor/profil/profil_tutor_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/tutor_buttom_nav.dart';


class ProfilTutorPage extends StatefulWidget {
  const ProfilTutorPage({super.key});

  @override
  State<ProfilTutorPage> createState() => _ProfilTutorPageState();
}

class _ProfilTutorPageState extends State<ProfilTutorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TutorProfileCubit>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: TutorBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/tutor/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/tutor/jadwal');
          if (i == 2) Navigator.pushReplacementNamed(context, '/tutor/konfirmasi-booking');
        },
      ),
      body: Column(children: [
        // ── Teal header ─────────────────────────────────────────
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Profil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                    color: Colors.white)),
          ),
        ),

        Expanded(
          child: BlocBuilder<TutorProfileCubit, TutorProfileState>(
            builder: (context, state) {
              if (state is TutorProfileLoading || state is TutorProfileInitial) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (state is TutorProfileError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<TutorProfileCubit>().fetchProfile(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (state is TutorProfileLoaded) {
                final tutor = state.tutor;
                final inisial = tutor.name.isNotEmpty ? tutor.name[0].toUpperCase() : '?';

                final detailPribadi = [
                  _FieldView('Nama Lengkap', tutor.name),
                  _FieldView('Jenis Kelamin', tutor.gender ?? '-'),
                  _FieldView('Tanggal Lahir', tutor.dateOfBirth ?? '-'),
                  _FieldView('Nomor WhatsApp', tutor.telephoneNumber ?? '-'),
                  _FieldView('Pilih Bank', tutor.bankCode ?? '-'),
                  _FieldView('Nomor Rekening', tutor.accountNumber ?? '-'),
                ];

                final addr = tutor.homeAddress;
                final formattedAddress = addr != null
                    ? '${addr.subdistrict}, ${addr.district}, ${addr.regency}, ${addr.province}'
                    : '-';

                final detailAlamat = [
                  _FieldView('Alamat Lengkap', formattedAddress),
                ];

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => context.read<TutorProfileCubit>().fetchProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      const SizedBox(height: 8),

                      // ── Kartu header user ────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                        ),
                        child: Row(children: [
                          // Avatar lingkaran
                          Container(
                            width: 64, height: 64,
                            decoration: const BoxDecoration(
                              color: Color(0xFFB2EBF2), shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(inisial,
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w700,
                                    color: AppColors.secondary)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(tutor.name,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary)),
                            Text(tutor.email ?? '-',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text(tutor.telephoneNumber ?? '-',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const SizedBox(height: 8),
                            // Tombol Edit Profil
                            SizedBox(
                              width: 110, height: 32,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/tutor/edit-profil'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Edit Profil',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ])),
                        ]),
                      ),

                      const SizedBox(height: 16),

                      // ── Detail Pribadi ───────────────────────────────────
                      _buildSection('Detail Pribadi', detailPribadi),
                      const SizedBox(height: 16),

                      // ── Detail Alamat ────────────────────────────────────
                      _buildSection('Detail Alamat', detailAlamat),
                      const SizedBox(height: 24),
                    ]),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildSection(String title, List<_FieldView> fields) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 14),
        ...fields.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.label,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(f.value,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary)),
            ),
          ]),
        )),
      ]),
    );
  }
}

class _FieldView {
  final String label, value;
  const _FieldView(this.label, this.value);
}