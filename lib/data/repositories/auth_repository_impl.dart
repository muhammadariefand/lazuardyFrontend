import 'package:lazuadry_mobile_fe/data/datasources/auth_remote_ds.dart';
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
}