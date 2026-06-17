import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/orangtua_bottom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_profile/parent_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';


class ProfilAnakPage extends StatefulWidget {
  const ProfilAnakPage({super.key});

  @override
  State<ProfilAnakPage> createState() => _ProfilAnakPageState();
}

class _ProfilAnakPageState extends State<ProfilAnakPage> {
  @override
  void initState() {
    super.initState();
    // Load profile on initialization
    context.read<ParentProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: OrangTuaBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/orang-tua/beranda');
          if (i == 1) Navigator.pushReplacementNamed(context, '/orang-tua/jadwal-anak');
          if (i == 2) Navigator.pushReplacementNamed(context, '/orang-tua/laporan-anak');
        },
      ),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: BlocBuilder<ParentProfileCubit, ParentProfileState>(
              builder: (context, state) {
                if (state is ParentProfileLoading || state is ParentProfileInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ParentProfileError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<ParentProfileCubit>().loadProfile(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ParentProfileLoaded) {
                  return _buildContent(state.profile);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StudentBiodata profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // ── Card Header ─────────────────────────────
          _buildHeaderCard(profile),
          const SizedBox(height: 14),

          // ── Card Detail Pribadi ──────────────────────
          _buildSectionCard(
            title: 'Detail Pribadi',
            fields: [
              _FieldItem('Nama Lengkap', profile.name ?? '-'),
              _FieldItem('Kelas', profile.className ?? '-'),
              _FieldItem('Jenis Kelamin', profile.gender ?? '-'),
              _FieldItem('Tanggal Lahir', profile.dateOfBirth ?? '-'),
              _FieldItem('Nomor WhatsApp', profile.telephoneNumber ?? '-'),
            ],
          ),
          const SizedBox(height: 14),

          // ── Card Detail Alamat ───────────────────────
          _buildSectionCard(
            title: 'Detail Alamat',
            fields: [
              _FieldItem('Provinsi', profile.homeAddress?.province ?? '-'),
              _FieldItem('Kota/Kabupaten', profile.homeAddress?.regency ?? '-'),
              _FieldItem('Kecamatan', profile.homeAddress?.district ?? '-'),
              _FieldItem('Kelurahan', profile.homeAddress?.subdistrict ?? '-'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Profil Anak',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Card Header ───────────────────────────────────────────────
  Widget _buildHeaderCard(StudentBiodata profile) {
    final initials = profile.name != null && profile.name!.isNotEmpty
        ? profile.name![0].toUpperCase()
        : 'M';

    return _cardWrapper(
      child: Row(
        children: [
          // Avatar lingkaran
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFCFE3F3),
              shape: BoxShape.circle,
            ),
            child: profile.profilePhotoUrl != null && profile.profilePhotoUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      profile.profilePhotoUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name ?? 'Nama Tidak Diketahui',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email ?? 'Email tidak tersedia',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.telephoneNumber ?? 'Nomor telepon tidak tersedia',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Section dengan list field ───────────────────────────
  Widget _buildSectionCard({
    required String title,
    required List<_FieldItem> fields,
  }) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...fields.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFieldRow(f.label, f.value),
              )),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDDDDDD)),
          ),
          child: Text(
            value,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  // ── Shared ────────────────────────────────────────────────────
  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldItem {
  final String label;
  final String value;
  const _FieldItem(this.label, this.value);
}