// lib/core/constants/app_assets.dart
// Sentralisasi semua path asset agar tidak ada typo di seluruh codebase

class AppAssets {
  AppAssets._();

  static const String _base = 'assets/images';

  /// Logo ikon + nama "Bimbel Lazuardy" + tagline (background hitam)
  /// Digunakan di: SplashPage
  static const String logoFull = '$_base/logo_lazuardi.png';

  /// Logo ikon + nama di samping kanan (horizontal, transparan)
  /// Digunakan di: OnboardingPage, DetailPribadiPage, DetailAlamatPage,
  ///              FormulirPendaftaranTutorPage, FormulirProfilTutorPage, dst.
  static const String logoHorizontal = '$_base/logo_memanjang.png';

  /// Logo ikon saja tanpa teks (transparan)
  /// Digunakan di: LoginPage, RegisterPage, OtpPage, ForgotPasswordPage,
  ///              ResetPasswordPage, DetailPribadiSiswaPage
  static const String logoIcon = '$_base/logo_lazuardi_noText.png';

  /// Google logo untuk OAuth button
  static const String googleLogo = '$_base/google_logo.png';

  /// Facebook logo untuk OAuth button
  static const String facebookLogo = '$_base/facebook_logo.png';
}