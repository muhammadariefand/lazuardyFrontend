import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_local_ds.dart';
import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/auth/register_student_request.dart';
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
      final response = await remoteDataSource.studentRegister(request);
      
      final token = response['access_token'] 
          ?? response['token']
          ?? response['data']?['token']
          ?? response['data']?['access_token'];
      
      await localDataSource.saveUserToken(token);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal melakukan registrasi');
    }
  }

  @override
  Future<void> studentLogin(String email, String password) async {
    try {
      final response = await remoteDataSource.studentLogin(email, password);

      // Coba semua kemungkinan key yang biasa dipakai backend
      final token = response['access_token'] 
          ?? response['token']
          ?? response['data']?['token']
          ?? response['data']?['access_token'];
      
      await localDataSource.saveUserToken(token);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal melakukan login');
    }
  }

  @override
  Future<void> studentForgotPasswordRequest(String email) async {
    try {
      await remoteDataSource.studentForgotPasswordRequest(email);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal mengirim permintaan OTP');
    }
  }

  @override
  Future<String> studentForgotPasswordVerify(String email, String otp) async {
    try {
      final token = await remoteDataSource.studentForgotPasswordVerify(email, otp);
      return token;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memverifikasi OTP');
    }
  }

  @override
  Future<void> studentForgotPasswordReset({
    required String email,
    required String resetToken,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.studentForgotPasswordReset(
        email: email,
        resetToken: resetToken,
        password: password,
        confirmPassword: confirmPassword,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal mereset password');
    }
  }
}