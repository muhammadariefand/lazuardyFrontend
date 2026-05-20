import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentResetPasswordUsecase {
  final AuthRepository repository;
  StudentResetPasswordUsecase(this.repository);

  Future<void> execute({
    required String email,
    required String resetToken,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.studentForgotPasswordReset(
      email: email,
      resetToken: resetToken,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}