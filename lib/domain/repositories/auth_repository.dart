// import 'package:lazuadry_mobile_fe/domain/entities/student.dart';

import 'package:lazuadry_mobile_fe/domain/entities/student_biodata.dart';

abstract class AuthRepository {
  Future<void> studentRegisterOtpEmail(String email);
  Future<void> studentVerifyOtpRegisterEmail({
    required String email,
    required String otp,
  });
}