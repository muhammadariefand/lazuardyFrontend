class AppApiConstants {
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String baseUrl = 'https://lazuardybackend-hexa.onrender.com/api';
  // static const String baseUrl = 'https://overtime-icky-covenant.ngrok-free.dev/api';
  // static const String baseUrl = 'http://10.255.108.21:8000/api';
  // static const String baseUrl = 'http://10.33.35.10:8000/api';

  static const String storageUrl = 'https://lazuardybackend-hexa.onrender.com/storage/';

  static String? getImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    if (path.startsWith('/')) {
      return '$storageUrl${path.substring(1)}';
    }
    return '$storageUrl$path';
  }
}