import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

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
      await remoteDataSource.studentRgister(request);
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