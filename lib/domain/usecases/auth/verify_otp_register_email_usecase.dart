import 'package:lazuadry_mobile_fe/domain/repositories/auth_repository.dart';

class StudentVerifyOtpRegisterEmailUsecase {
  final AuthRepository repository;
  
  StudentVerifyOtpRegisterEmailUsecase({required this.repository});

  Future<void> execute(String email,String otp) async {
    return repository.studentVerifyOtpRegisterEmail(
      email: email, 
      otp: otp,
    );
  }
}