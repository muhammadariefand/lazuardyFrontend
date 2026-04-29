import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentRegisterOtpEmailUsecase {
  final AuthRepository repository;
  StudentRegisterOtpEmailUsecase({required this.repository});

  Future<void> execute(String email) {
    return repository.studentRegisterOtpEmail(email);
  }
}