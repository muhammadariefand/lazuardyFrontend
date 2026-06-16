import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class VerifyOtpTautkanAkunAnakUsecase {
  final AuthRepository repository;

  VerifyOtpTautkanAkunAnakUsecase({required this.repository});
  
  Future<void> execute(String email, String otp) {
    return repository.verifyOtpTautkanAkunAnak(email, otp);
  }
}