import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_state.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_bottom_nav.dart';
import 'package:lazuadry_mobile_fe/presentation/widgets/siswa_drawer.dart';
import '../../../domain/entities/dashboard_entity.dart';

const _navy = Color(0xFF24326B);
const _teal = Color(0xFF2C8AA4);
const _starYellow = Color(0xFFFFB800);

class BerandaSiswaPage extends StatefulWidget {
  const BerandaSiswaPage({super.key});
  @override
  State<BerandaSiswaPage> createState() => _BerandaSiswaPageState();
}

class _BerandaSiswaPageState extends State<BerandaSiswaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman pertama kali dibuka
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _teal,
      // Drawer dan BottomNav tetap menggunakan data dinamis nanti jika diperlukan, 
      // untuk saat ini kita biarkan statis sesuai desain awal.
      drawer: const SiswaDrawer(nama: 'Siswa', inisial: 'S'),
      bottomNavigationBar: SiswaBottomNav(
          currentIndex: 0,
          onTap: (i) {
            if (i == 1) Navigator.pushReplacementNamed(context, '/siswa/jadwal');
            if (i == 2) Navigator.pushReplacementNamed(context, '/siswa/laporan');
            if (i == 3) Navigator.pushReplacementNamed(context, '/siswa/profil');
          }),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Memungkinkan user menarik layar ke bawah untuk refresh data
            await context.read<DashboardCubit>().loadDashboard();
          },
          child: BlocConsumer<DashboardCubit, DashboardState>(
            listener: (context, state) {
              if (state is DashboardError && 
                  (state.message.contains('Gagal memuat data, silakan coba lagi') || state.message.contains('401'))) {
                Navigator.of(context).pushReplacementNamed('/siswa/login');
              }
            },
            builder: (context, state) {
              if (state is DashboardLoading || state is DashboardInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 50),
                      const SizedBox(height: 16),
                      Text(state.message, style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                );
              } else if (state is DashboardLoaded) {
                // DATA BERHASIL DIAMBIL, RENDER UI UTAMA
                final data = state.dashboardData;
                return Column(
                  children: [
                    _buildAppBar(data.userName),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            // Menampilkan Banner Warning jika data warning > 0
                            if (data.warning > 0) ...[
                              _buildWarningBanner(data.warning),
                              const SizedBox(height: 12)
                            ],
                            _buildKartuSesi(context, data.session),
                            const SizedBox(height: 20),
                            _buildMenuGrid(),
                            const SizedBox(height: 24),
                            _buildNotifikasiSection(data),
                            const SizedBox(height: 24),
                            _buildRekomendasiSection(data),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(String namaSiswa) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/siswa/notifikasi'),
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textPrimary, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Selamat datang ',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    Text('👋', style: TextStyle(fontSize: 13)),
                  ],
                ),
                Text(namaSiswa,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
          ],
        ),
      );

  Widget _buildWarningBanner(int warningCount) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF92400E), height: 1.5),
                  children: [
                    TextSpan(
                        text: 'Peringatan ($warningCount/3)\n',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(
                        text:
                            'Anda telah menerima $warningCount peringatan.\nJika mencapai 3 peringatan, akun akan '),
                    const TextSpan(
                        text: 'disuspend selama 7 hari',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const TextSpan(text: '.\nMohon gunakan platform sesuai ketentuan.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildKartuSesi(BuildContext context, int sesiDimiliki) {
    // Karena di API hanya mengembalikan "session" (jumlah sesi yang dimiliki)
    // Untuk saat ini kita anggap sesiTersisa = sesiDimiliki.
    // Jika kamu punya perhitungan lain dari API (misal maxSesi), ubah bagian ini.
    final int sesiTotal = sesiDimiliki > 0 ? sesiDimiliki : 1; 
    final double progress = sesiDimiliki / sesiTotal; // Contoh logika sementara

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Paket Tersisa',
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$sesiDimiliki',
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1)),
              const SizedBox(width: 4),
              Text('/$sesiTotal',
                  style: const TextStyle(fontSize: 18, color: AppColors.textSecondary)),
            ],
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Text('Total: $sesiTotal',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(_navy),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/siswa/beli-paket');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Beli Paket',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final items = [
      ('📚', 'Booking\n  ', '/siswa/booking/pilih-kategori'),
      ('🕐', 'Riwayat\nSesi', '/siswa/riwayat-sesi'),
      ('⭐', 'Riwayat\nUlasan Tutor', '/siswa/ulasan-tutor'),
      ('💳', 'Riwayat\nPembayaran', '/siswa/riwayat-pembayaran'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          final w = (MediaQuery.of(context).size.width - 32 - 24) / 4;
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, item.$3),
            child: Container(
              width: w,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.$1, style: const TextStyle(fontSize: 30)),
                  const SizedBox(height: 8),
                  Text(item.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.3)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotifikasiSection(DashboardEntity data) {
    final notifs = data.notifications.data;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifikasi',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/siswa/notifikasi'),
                child: const Row(
                  children: [
                    Text('Lihat semua',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (notifs.isEmpty)
            const Center(
              child: Text('Tidak ada notifikasi', style: TextStyle(color: Colors.white)),
            )
          else
            ...notifs.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: _teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(9)),
                            child: const Icon(Icons.notifications_active,
                                color: _teal, size: 18)), // Placeholder Icon
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(n.title,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(n.body,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildRekomendasiSection(DashboardEntity data) {
    final tutors = data.tutorRecommendations.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Rekomendasi Tutor',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/siswa/rekomendasi-tutor'),
                child: const Row(
                  children: [
                    Text('Lihat semua',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (tutors.isEmpty)
          const Center(
              child: Text('Belum ada rekomendasi tutor',
                  style: TextStyle(color: Colors.white)))
        else
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: tutors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final t = tutors[i];
                // Ekstrak Inisial dari Nama (misal "Demo Tutor" -> "D")
                final inisial = t.name.isNotEmpty ? t.name[0].toUpperCase() : '?';

                return Container(
                  width: 210,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Text(inisial,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey.shade500))),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary)),
                                Text(
                                    t.learningMethods.isNotEmpty
                                        ? t.learningMethods.first
                                        : 'Umum', // Ambil metode pertama jika ada
                                    style: const TextStyle(
                                        fontSize: 11, color: AppColors.textSecondary)),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: _starYellow, size: 13),
                                    const SizedBox(width: 2),
                                    Text('${t.avgRate ?? 0.0}',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(t.description ?? 'Belum ada deskripsi profil.',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              height: 1.5,
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}