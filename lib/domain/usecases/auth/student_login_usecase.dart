import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentLoginUsecase {
  final AuthRepository repository;
  StudentLoginUsecase({required this.repository});

  Future<void> execute(String email,String password) {
    return repository.studentLogin(email, password);
  }
}