import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/constants/app_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required Future<String?> Function() getToken}) : dio = Dio(
    BaseOptions(
      baseUrl: AppApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // Hanya kirim token ke backend base URL, tidak ke API eksternal (misal: API wilayah)
            final isBackendRequest = !options.path.startsWith('http') || 
                options.path.startsWith(AppApiConstants.baseUrl);
                
            if (isBackendRequest) {
              final token = await getToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            }
          } catch (_) {
            // Biarkan request berlanjut jika terjadi error mengambil token
          }
          return handler.next(options);
        },
      ),
    );
  }
}