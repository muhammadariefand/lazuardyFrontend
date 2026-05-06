import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_local_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> studentRegisterOtpEmail(String email) async {
    await remoteDataSource.studentRegisterOtpEmail(email);
  }

  @override
  Future<void> studentVerifyOtpRegisterEmail({
    required String email,
    required String otp,
  }) async {
    await remoteDataSource.studentVerifyOtpRegisterEmail(
      email: email, 
      otp: otp,
    );
  }

  @override
  Future<void> studentRegister(RegisterStudentRequest request) async {
    try {
      await remoteDataSource.studentRegister(request);
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

  @override
  Future<void> studentLogin(String email, String password) async {
    try {
      final response = await remoteDataSource.studentLogin(email, password);
      final token = response['access_token'];
      await localDataSource.saveUserToken(token);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal melakukan login');
    }
  }
}