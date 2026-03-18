import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazuadry_mobile_fe/core/theme/app_theme.dart';
import 'package:lazuadry_mobile_fe/dependency_injection.dart';
import 'package:lazuadry_mobile_fe/presentation/state_management/auth/auth_cubit.dart';

// ── Shared ─────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/splash_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/tagline_page.dart';

// ── Siswa ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/login_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/register_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/otp_verification_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/forgot_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/reset_password_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_pribadi_siswa_page.dart';
import 'package:lazuadry_mobile_fe/presentation/pages/siswa/detail_alamat_siswa_page.dart';

// ── Tutor ──────────────────────────────────────────────────────────
import 'package:lazuadry_mobile_fe/presentation/pages/tutor/login_tutor_page.dart';
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
        routes: {
          // ── Shared ────────────────────────────────────────────
          '/': (_) => const SplashPage(),
          '/tagline': (_) => const TaglinePage(),

          // ── Siswa ──────────────────────────────────────────────
          '/siswa/login': (_) => const LoginSiswaPage(),
          '/siswa/register': (_) => const RegisterSiswaPage(),
          '/siswa/otp': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments
                as Map<String, String>?;
            return OtpVerificationSiswaPage(
              email: args?['email'],
              context: args?['context'] ?? 'register',
            );
          },
          '/siswa/forgot-password': (_) => const ForgotPasswordSiswaPage(),
          '/siswa/reset-password': (_) => const ResetPasswordSiswaPage(),
          '/siswa/detail-pribadi': (_) => const DetailPribadiSiswaPage(),
          '/siswa/detail-alamat': (_) => const DetailAlamatSiswaPage(),

          // ── Tutor ──────────────────────────────────────────────
          '/tutor/login': (_) => const LoginTutorPage(),
          '/tutor/register': (_) => const RegisterTutorPage(),
          '/tutor/otp': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments
                as Map<String, String>?;
            return OtpVerificationTutorPage(
              email: args?['email'],
              context: args?['context'] ?? 'register',
            );
          },
          '/tutor/forgot-password': (_) => const ForgotPasswordTutorPage(),
          '/tutor/reset-password': (_) => const ResetPasswordTutorPage(),
          '/tutor/detail-pribadi': (_) => const DetailPribadiTutorPage(),
          '/tutor/formulir-pendaftaran': (_) => const FormulirPendaftaranTutorPage(),
          '/tutor/formulir-profil': (_) => const FormulirProfilTutorPage(),

          // ── Orang Tua ──────────────────────────────────────────
    
        },
      ),
    );
  }
}