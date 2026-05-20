import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentVerifyOtpUsecase {
  final AuthRepository repository;
  StudentVerifyOtpUsecase(this.repository);

  Future<String> execute(String email, String otp) async => await repository.studentForgotPasswordVerify(email, otp);
}