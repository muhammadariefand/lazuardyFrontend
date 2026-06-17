// lib/core/constants/app_assets.dart
// Sentralisasi semua path asset agar tidak ada typo di seluruh codebase

class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';

  // =====================
  // LOGOS & BRANDING
  // =====================

  /// Logo ikon + nama "Bimbel Lazuardy" + tagline (background hitam)
  static const String logoFull = '$_images/logo_lazuardi.png';

  /// Logo ikon + nama di samping kanan (horizontal, transparan)
  static const String logoHorizontal = '$_images/logo_memanjang.png';

  /// Logo ikon saja tanpa teks (transparan)
  static const String logoIcon = '$_images/logo_lazuardi_noText.png';

  // =====================
  // ICONS
  // =====================

  /// Google logo untuk OAuth button
  static const String googleLogo = '$_images/google_logo.png';

  /// Facebook logo untuk OAuth button
  static const String facebookLogo = '$_images/facebook_logo.png';

  /// Dashboard Menu Icons (Illustrations)
  static const String iconBooking = '$_icons/icon_booking.png';
  static const String iconRiwayatSesi = '$_icons/icon_riwayat_sesi.png';
  static const String iconRiwayatUlasan = '$_icons/icon_riwayat_ulasan.png';
  static const String iconRiwayatPembayaran = '$_icons/icon_riwayat_pembayaran.png';

  // =====================
  // ILLUSTRATIONS / OTHERS
  // =====================
  
  // (Tambahkan ilustrasi kosong, empty state, dll di sini nanti)
}