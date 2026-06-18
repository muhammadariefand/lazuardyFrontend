import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    final loginRes = await dio.post(
      'https://lazuardybackend-hexa.onrender.com/api/login',
      data: {'email': 'test500@test.com', 'password': 'password123'},
      options: Options(headers: {'Accept': 'application/json'}),
    );
    print('LOGIN: ${loginRes.data}');
    final token = loginRes.data['access_token'];

    final dashRes = await dio.get(
      'https://lazuardybackend-hexa.onrender.com/api/tutor/dashboard/homepage',
      options: Options(headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    print('DASHBOARD: ${dashRes.data}');
  } on DioException catch (e) {
    print('STATUS: ${e.response?.statusCode}');
    print('DATA: ${e.response?.data}');
  }
}
