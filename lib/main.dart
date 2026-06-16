// lib/main.dart
// Entry point — semua route terdaftar dengan logika role-based navigation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/dependency_injection.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/auth/login_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/auth/otp_verification_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/beranda/beranda_orangtua_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/jadwal/jadwal_orangtua_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/laporan/laporan_orangtua_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/login_orang_tua_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/profil/profil_anak_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/register_orang_tua_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/tautkan_akun_anak_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/orang_tua/verifikasi_otp_tautkan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/batalkan_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/booking/booking_berhasil_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/booking/konfirmasi_booking_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/booking/pilih_jadwal_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/booking/pilih_kategori_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/booking/pilih_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/edit_profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/jadwal_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/konfirmasi_pembatalan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/laporan_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/login_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/menu_sidebar/hubungi_kami_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/menu_sidebar/tentang_kami_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/notifikasi/notifikasi_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/otp_verification_forgot_password_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/rekomendasi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/riwayat_pembayaran/riwayat_pembayaran_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/riwayat_sesi/detail_riwayat_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/riwayat_sesi/rating_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/riwayat_sesi/riwayat_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/sesi_dibatalkan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/ulasan_tutor/ulasan_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/beranda_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/manajemen_sesi/manajemen_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/profil_mengajar/profil_mengajar_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/tarik_saldo/tarik_saldo_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/beranda/ulasan_siswa/ulasan_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/booking/form_link_meeting_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/booking/konfirmasi_booking_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/detail_alamat_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/jadwal/jadwal_mengajar_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/notifikasi/notifikasi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/profil/edit_profil_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/profil/profil_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/menunggu_verifikasi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/booking_confirmation_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_profile/tutor_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_dashboard/parent_dashboard_cubit.dart';

// ── Shared ─────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/splash_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tagline_page.dart';
// import 'package:lazuadry_mobile_fe/presentation/pages/auth/otp_verification_page.dart';

// ── Siswa ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/register_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/otp_verification_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/forgot_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/reset_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_pribadi_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_alamat_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beranda_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beli_paket/beli_paket_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beli_paket/pembayaran_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beli_paket/kode_pembayaran_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beli_paket/pembayaran_berhasil_page.dart';

// ── Tutor ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/register_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/otp_verification_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/forgot_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/reset_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/detail_pribadi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_pendaftaran_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_profil_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/dashboard/dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/region/region_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/schedule/schedule_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/report/report_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/student_profile/student_profile_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/tutor_dashboard/tutor_dashboard_cubit.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/parent_profile/parent_profile_cubit.dart';

// ── Orang Tua ──────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const LazuardyApp());
}

class LazuardyApp extends StatelessWidget {
  const LazuardyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: MaterialApp(
        title: 'Bimbel Lazuardy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        routes: {
          // ── Entry ─────────────────────────────────────────────
          '/': (_) => const SplashPage(),
          '/tagline': (_) => const TaglinePage(),
          '/login': (_) => const LoginPage(),
          '/register/verifikasi-otp': (_) => const OtpVerificationPage(),

          '/siswa/login': (_) => const LoginSiswaPage(),

          // ── Siswa: Register flow ───────────────────────────────
          '/siswa/register': (_) => const RegisterSiswaPage(),
          '/siswa/detail-pribadi': (_) => const DetailPribadiSiswaPage(),
          '/siswa/detail-alamat': (context) => BlocProvider<RegionCubit>(
            create: (context) => sl<RegionCubit>(),
            child: const DetailAlamatSiswaPage(),
          ),
          '/siswa/otp-verification': (context) =>
              const OtpVerificationSiswaPage(),
          // '/siswa/otp-verification': (ctx) {
          //   final args = ModalRoute.of(ctx)?.settings.arguments
          //       as Map<String, String>?;
          //   return OtpVerificationSiswaPage(
          //     email: args?['email'],
          //     context: args?['context'] ?? 'register',
          //   );

          // ── Siswa: Auth flow ───────────────────────────────────
          '/siswa/forgot-password': (_) => const ForgotPasswordSiswaPage(),
          '/siswa/otp-verification-forgot-password': (_) =>
              const OtpVerificationForgotPasswordPage(),
          '/siswa/reset-password': (_) => const ResetPasswordSiswaPage(),

          // ── Siswa: Menu Sidebar ────────────────────────────────────
          '/siswa/hubungi-kami': (_) => const HubungiKamiPage(),
          '/siswa/tentang-kami': (_) => const TentangKamiPage(),

          // ── Siswa: Notifikasi ────────────────────────────────────────
          '/siswa/notifikasi': (_) => const NotifikasiSiswaPage(),

          // ── Siswa: Dashboard ────────────────────────────────────────
          '/siswa/beranda': (context) => BlocProvider<DashboardCubit>(
            create: (context) => sl<DashboardCubit>(),
            child: const BerandaSiswaPage(),
          ),
          '/siswa/jadwal': (context) => BlocProvider<ScheduleCubit>(
            create: (_) => sl<ScheduleCubit>(),
            child: const JadwalSiswaPage(),
          ),
          '/siswa/detail-sesi': (_) => const DetailSesiPage(),
          '/siswa/batalkan-sesi': (_) => const BatalkanSesiPage(),
          '/siswa/konfirmasi-pembatalan': (_) =>
              const KonfirmasiPembatalanPage(),
          '/siswa/sesi-dibatalkan': (_) => const SesiDibatalkanPage(),
          '/siswa/laporan': (context) => BlocProvider<ReportCubit>(
            create: (_) => sl<ReportCubit>(),
            child: const LaporanSiswaPage(),
          ),
          '/siswa/profil': (context) => BlocProvider<StudentProfileCubit>(
            create: (_) => sl<StudentProfileCubit>(),
            child: const ProfilSiswaPage(),
          ),
          '/siswa/edit-profil': (context) => BlocProvider<StudentProfileCubit>(
            create: (_) => sl<StudentProfileCubit>(),
            child: const EditProfilSiswaPage(),
          ),
          '/siswa/rekomendasi-tutor': (_) => const RekomendasiTutorPage(),

          // ── Siswa: Beli Paket ────────────────────────────────────────
          '/siswa/beli-paket': (_) => BeliPaketPage(),
          '/siswa/pembayaran': (_) => PembayaranPage(),
          '/siswa/kode-pembayaran': (_) => KodePembayaranPage(),
          '/siswa/pembayaran-berhasil': (_) => PembayaranBerhasilPage(),

          // ── Siswa: Booking ────────────────────────────────────────
          '/siswa/booking/pilih-kategori': (_) => const PilihKategoriPage(),
          '/siswa/booking/pilih-tutor': (_) => const PilihTutorPage(),
          '/siswa/booking/pilih-jadwal': (_) => const PilihJadwalPage(),
          '/siswa/booking/konfirmasi': (_) => const KonfirmasiBookingPage(),
          '/siswa/booking/berhasil': (_) => const BookingBerhasilPage(),

          // ── Siswa: Riwayat Sesi ────────────────────────────────────────
          '/siswa/riwayat-sesi': (_) => const RiwayatSesiPage(),
          '/siswa/riwayat-sesi/detail': (_) => const DetailRiwayatSesiPage(),
          '/siswa/riwayat-sesi/rating': (_) => const RatingTutorPage(),

          // ── Siswa: Riwayat Ulasan Tutor ────────────────────────────────
          '/siswa/ulasan-tutor': (_) => const UlasanTutorPage(),

          // ── Siswa: Riwayat Pembayaran ────────────────────────────────
          '/siswa/riwayat-pembayaran': (_) => const RiwayatPembayaranPage(),

          // ── Tutor: Register flow ───────────────────────────────
          '/tutor/register': (_) => const RegisterTutorPage(),
          '/tutor/detail-pribadi': (_) => const DetailPribadiTutorPage(),
          '/tutor/detail-alamat': (_) => const DetailAlamatTutorPage(),
          '/tutor/formulir-pendaftaran': (_) =>
              const FormulirPendaftaranTutorPage(),
          '/tutor/formulir-profil': (_) => const FormulirProfilTutorPage(),
          '/tutor/menunggu-verifikasi': (_) => const MenungguVerifikasiPage(),
          '/tutor/otp': (ctx) {
            final args =
                ModalRoute.of(ctx)?.settings.arguments as Map<String, String>?;
            return OtpVerificationTutorPage(
              email: args?['email'],
              context: args?['context'] ?? 'register',
            );
          },

          // ── Tutor: Auth flow ───────────────────────────────────
          '/tutor/forgot-password': (_) => const ForgotPasswordTutorPage(),
          '/tutor/reset-password': (_) => const ResetPasswordTutorPage(),

          // ── Tutor: Home (TODO) ─────────────────────────────────
          '/tutor/beranda': (context) => BlocProvider<TutorDashboardCubit>(
            create: (_) => sl<TutorDashboardCubit>(),
            child: const BerandaTutorPage(),
          ),
          '/tutor/jadwal': (context) => BlocProvider<ScheduleCubit>(
            create: (_) => sl<ScheduleCubit>(),
            child: const JadwalMengajarPage(),
          ),
          '/tutor/konfirmasi-booking': (context) => MultiBlocProvider(
            providers: [
              BlocProvider<ScheduleCubit>(create: (_) => sl<ScheduleCubit>()),
              BlocProvider<BookingConfirmationCubit>(create: (_) => sl<BookingConfirmationCubit>()),
            ],
            child: const KonfirmasiBookingTutorPage(),
          ),
          '/tutor/form-link-meeting': (context) => BlocProvider<BookingConfirmationCubit>(
            create: (_) => sl<BookingConfirmationCubit>(),
            child: const FormLinkMeetingPage(),
          ),
          '/tutor/profil': (context) => BlocProvider<TutorProfileCubit>(
            create: (_) => sl<TutorProfileCubit>(),
            child: const ProfilTutorPage(),
          ),
          '/tutor/edit-profil': (context) => BlocProvider<TutorProfileCubit>(
            create: (_) => sl<TutorProfileCubit>(),
            child: const EditProfilTutorPage(),
          ),

          // ── Siswa: Menu Sidebar ────────────────────────────────────
          '/tutor/hubungi-kami': (_) => const HubungiKamiPage(),
          '/tutor/tentang-kami': (_) => const TentangKamiPage(),

          // ── Tutor: Notifikasi ────────────────────────────────────────
          '/tutor/notifikasi': (_) => const NotifikasiTutorPage(),

          // ── Tutor: Manajemen Sesi ─────────────────────────────
          '/tutor/manajemen-sesi': (_) => const ManajemenSesiPage(),

          // ── Tutor: Profil Mengajar ─────────────────────────────
          '/tutor/profil-mengajar': (_) => const ProfilMengajarPage(),

          // ── Tutor: Ulasan Siswa ─────────────────────────────
          '/tutor/ulasan-siswa': (_) => const UlasanSiswaPage(),

          // ── Tutor: Tarik Saldo ─────────────────────────────
          '/tutor/tarik-saldo': (_) => const TarikSaldoPage(),

          // ── Orang Tua ─────────────────────
          '/orang-tua/register': (_) => const RegisterOrangTuaPage(),
          '/orang-tua/login': (_) => const LoginOrangTuaPage(),
          '/orang-tua/otp-verification': (_) =>
              const OtpVerificationTutorPage(),
          '/orang-tua/forgot-password': (_) => const ForgotPasswordTutorPage(),
          '/orang-tua/reset-password': (_) => const ResetPasswordTutorPage(),
          '/orang-tua/tautkan-akun-anak': (_) => const TautkanAkunAnakPage(),
          '/orang-tua/verifikasi-otp-akun-anak': (_) => const VerifikasiOtpTautkanPage(),

          // ── Orang Tua: Home ─────────────────────────────
          '/orang-tua/beranda': (context) => BlocProvider<ParentDashboardCubit>(
            create: (_) => sl<ParentDashboardCubit>(),
            child: const BerandaOrangtuaPage(),
          ),

          // ── Orang Tua: Menu Sidebar ────────────────────────────────────
          '/orang-tua/hubungi-kami': (_) => const HubungiKamiPage(),
          '/orang-tua/tentang-kami': (_) => const TentangKamiPage(),
          '/orang-tua/notifikasi': (_) => const NotifikasiSiswaPage(),

          // ── Orang Tua: Jadwal ─────────────────────────────
          '/orang-tua/jadwal-anak': (context) => BlocProvider<ScheduleCubit>(
            create: (context) => sl<ScheduleCubit>(),
            child: const JadwalOrangtuaPage(),
          ),

          // ── Orang Tua: Laporan ─────────────────────────────
          '/orang-tua/laporan-anak': (context) => BlocProvider<ReportCubit>(
            create: (_) => sl<ReportCubit>(),
            child: const LaporanOrangtuaPage(),
          ),

          // ── Orang Tua: Profil Anak ─────────────────────────────
          '/orang-tua/profil-anak': (context) => BlocProvider<ParentProfileCubit>(
            create: (_) => sl<ParentProfileCubit>(),
            child: const ProfilAnakPage(),
          ),
        },
      ),
    );
  }
}
