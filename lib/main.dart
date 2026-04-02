// lib/main.dart
// Entry point — semua route terdaftar dengan logika role-based navigation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/dependency_injection.dart';
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

// ── Tutor ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/register_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/otp_verification_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/forgot_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/reset_password_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/detail_pribadi_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_pendaftaran_tutor_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/formulir_profil_tutor_page.dart';

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
          '/siswa/register': (_) => const RegisterSiswaPage(),
          '/siswa/detail-pribadi': (_) => const DetailPribadiSiswaPage(),
          '/siswa/detail-alamat': (_) => const DetailAlamatSiswaPage(),
          '/siswa/otp': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments
                as Map<String, String>?;
            return OtpVerificationSiswaPage(
              email: args?['email'],
              context: args?['context'] ?? 'register',
            );
          },

          // ── Siswa: Auth flow ───────────────────────────────────
          '/siswa/forgot-password': (_) => const ForgotPasswordSiswaPage(),
          '/siswa/reset-password': (_) => const ResetPasswordSiswaPage(),

          // ── Siswa: Home ────────────────────────────────────────
          // '/siswa/beranda': (_) => const BerandaSiswaPage(),

          // ── Tutor: Register flow ───────────────────────────────
          '/tutor/register': (_) => const RegisterTutorPage(),
          '/tutor/detail-pribadi': (_) => const DetailPribadiTutorPage(),
          '/tutor/formulir-pendaftaran': (_) =>
              const FormulirPendaftaranTutorPage(),
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