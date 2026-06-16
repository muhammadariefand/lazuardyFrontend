import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class OtpRegisterEmailUsecase {
  final AuthRepository repository;

  OtpRegisterEmailUsecase(this.repository);

  Future<void> execute(String email) async {
    // await repository.registerOtpEmail(email);
  }
}