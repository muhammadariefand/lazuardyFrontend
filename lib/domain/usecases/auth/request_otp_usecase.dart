import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentRequestOtpUsecase {
  final AuthRepository repository;
  StudentRequestOtpUsecase(this.repository);

  Future<void> execute(String email) async => await repository.studentForgotPasswordRequest(email);
}