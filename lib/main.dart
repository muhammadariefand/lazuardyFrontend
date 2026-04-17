// lib/main.dart
// Entry point — semua route terdaftar dengan logika role-based navigation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/data/repositories/otp_repository_impl.dart';
import 'package:lazuadry_mobile_fe/dependency_injection.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/batalkan_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/edit_profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/jadwal_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/konfirmasi_pembatalan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/laporan_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/sesi_dibatalkan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';

// ── Shared ─────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/splash_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tagline_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/auth/login_page.dart';
// import 'package:lazuadry_mobile_fe/presentation/pages/auth/otp_verification_page.dart';

// ── Siswa ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/register_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/otp_verification_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/forgot_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/reset_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_pribadi_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_alamat_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beranda_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/batalkan_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_sesi_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/edit_profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/jadwal_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/konfirmasi_pembatalan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/laporan_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/profil_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/sesi_dibatalkan_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/beli_paket_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/pembayaran_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/kode_pembayaran_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/pembayaran_berhasil_page.dart';


// ── Tutor ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/register_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/otp_verification_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/forgot_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/reset_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/detail_pribadi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_pendaftaran_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_profil_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/otp/otp_cubit.dart';

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

        // ════════════════════════════════════════════════════════
        // ALUR NAVIGASI
        //
        // SPLASH → TAGLINE → LOGIN (tab pilih role)
        //
        // [LOGIN - TAB SISWA]
        //   Masuk  → /siswa/beranda
        //   Daftar → /siswa/register → /siswa/detail-pribadi
        //          → /siswa/detail-alamat → /siswa/otp → /siswa/beranda
        //   Lupa   → /siswa/forgot-password → /siswa/otp
        //          → /siswa/reset-password → /login
        //
        // [LOGIN - TAB TUTOR]
        //   Masuk  → /tutor/beranda
        //   Daftar → /tutor/register → /tutor/detail-pribadi
        //          → /tutor/formulir-pendaftaran → /tutor/formulir-profil
        //          → /siswa/detail-alamat (shared) → /tutor/otp → /tutor/beranda
        //   Lupa   → /tutor/forgot-password → /tutor/otp
        //          → /tutor/reset-password → /login
        //
        // [LOGIN - TAB ORANG TUA]
        //   Masuk  → /orang-tua/beranda
        //   ❌ TIDAK ada tombol Daftar
        //   ❌ TIDAK ada halaman register orang tua
        // ════════════════════════════════════════════════════════

        routes: {
          // ── Entry ─────────────────────────────────────────────
          '/': (_) => const SplashPage(),
          '/tagline': (_) => const TaglinePage(),
          '/login': (_) => const LoginPage(),

          // ── Siswa: Register flow ───────────────────────────────
          '/siswa/register': (_) => BlocProvider(
              create: (context) => OtpCubit(OtpRepositoryImpl(ApiClient())),
              child: const RegisterSiswaPage(),
            ),
          '/siswa/detail-pribadi': (_) => const DetailPribadiSiswaPage(),
          '/siswa/detail-alamat': (_) => const DetailAlamatSiswaPage(),
          '/siswa/otp-verification': (context) => const OtpVerificationSiswaPage(),
          // '/siswa/otp-verification': (ctx) {
          //   final args = ModalRoute.of(ctx)?.settings.arguments
          //       as Map<String, String>?;
          //   return OtpVerificationSiswaPage(
          //     email: args?['email'],
          //     context: args?['context'] ?? 'register',
          //   );
          

          // ── Siswa: Auth flow ───────────────────────────────────
          '/siswa/forgot-password': (_) => const ForgotPasswordSiswaPage(),
          '/siswa/reset-password': (_) => const ResetPasswordSiswaPage(),

          // ── Siswa: Dashboard ────────────────────────────────────────
          '/siswa/beranda': (_) => const BerandaSiswaPage(),
          '/siswa/jadwal': (_) => const JadwalSiswaPage(),
          '/siswa/detail-sesi': (_) => const DetailSesiPage(),
          '/siswa/batalkan-sesi': (_) => const BatalkanSesiPage(),
          '/siswa/konfirmasi-pembatalan': (_) => const KonfirmasiPembatalanPage(),
          '/siswa/sesi-dibatalkan': (_) => const SesiDibatalkanPage(),
          '/siswa/laporan': (_) => const LaporanSiswaPage(),
          '/siswa/profil': (_) => const ProfilSiswaPage(),
          '/siswa/edit-profil': (_) => const EditProfilSiswaPage(),

          // ── Siswa: Beli Paket ────────────────────────────────────────
          '/siswa/beli-paket': (_) => BeliPaketPage(),
          '/siswa/pembayaran': (_) => PembayaranPage(),
          '/siswa/kode-pembayaran': (_) => KodePembayaranPage(),
          '/siswa/pembayaran-berhasil': (_) => PembayaranBerhasilPage(),

          // ── Tutor: Register flow ───────────────────────────────
          '/tutor/register': (_) => const RegisterTutorPage(),
          '/tutor/detail-pribadi': (_) => const DetailPribadiTutorPage(),
          '/tutor/formulir-pendaftaran': (_) => const FormulirPendaftaranTutorPage(),
          '/tutor/formulir-profil': (_) => const FormulirProfilTutorPage(),
          '/tutor/otp': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments
                as Map<String, String>?;
            return OtpVerificationTutorPage(
              email: args?['email'],
              context: args?['context'] ?? 'register',
            );
          },

          // ── Tutor: Auth flow ───────────────────────────────────
          '/tutor/forgot-password': (_) => const ForgotPasswordTutorPage(),
          '/tutor/reset-password': (_) => const ResetPasswordTutorPage(),

          // ── Tutor: Home (TODO) ─────────────────────────────────
          // '/tutor/beranda': (_) => const BerandaTutorPage(),

          // ── Orang Tua: TIDAK ada register ─────────────────────
          // Orang Tua login memakai akun anak (email+password siswa)
          // Setelah login berhasil diarahkan ke beranda orang tua
          // '/orang-tua/detail-pribadi': (_) => const DetailPribadiOrtuPage(),
          // '/orang-tua/detail-anak': (_) => const DetailAnakPage(),

          // ── Orang Tua: Home (TODO) ─────────────────────────────
          // '/orang-tua/beranda': (_) => const BerandaOrtuPage(),
        },
      ),
    );
  }
}