// import 'package:lazuadry_mobile_fe/domain/entities/student.dart';

import 'package:lazuadry_mobile_fe/data/models/auth/register_student_request.dart';
import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

abstract class AuthRepository {
  Future<void> studentRegisterOtpEmail(String email);

  Future<void> studentVerifyOtpRegisterEmail({
    required String email,
    required String otp,
  });

  Future<void> studentRegister(RegisterStudentRequest request);

  Future<void> studentLogin(String email, String password);
  
  // Forgot password flows
  Future<void> studentForgotPasswordRequest(String email);
  Future<String> studentForgotPasswordVerify(String email, String otp);
  Future<void> studentForgotPasswordReset({
    required String email,
    required String resetToken,
    required String password,
    required String confirmPassword,
  });
}