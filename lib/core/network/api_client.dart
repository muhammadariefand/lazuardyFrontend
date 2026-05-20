import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/constants/app_constants.dart';
class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ),
  );
}