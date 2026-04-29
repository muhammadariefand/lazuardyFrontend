import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/models/student_model.dart';
import 'package:lazuadry_mobile_fe/data/models/user_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

class AuthRemoteDataSource {
  final ApiClient client;
  AuthRemoteDataSource(this.client);

  Future<UserModel> login(String email, String password) async {
    final response = await client.dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    return UserModel.fromJson(response.data['user']);
  }


  Future<void> studentRegisterOtpEmail(String email) async {
    try {
      final response = await client.dio.post('/registerOtpEmail', data: {'email': email});
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal', 
          errors: data['errors'], 
        );
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }
}