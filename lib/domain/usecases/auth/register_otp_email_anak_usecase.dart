import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class RegisterOtpEmailAnakUsecase {
  final AuthRepository repository;

  RegisterOtpEmailAnakUsecase({required this.repository});
  
  Future<void> execute(String email) {
    return repository.registerOtpEmailAnak(email);
  }
}