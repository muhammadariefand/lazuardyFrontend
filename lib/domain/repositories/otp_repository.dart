// lib/src/domain/repositories/user_repository.dart
// Ini adalah "PORT"
import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_verification.dart';

abstract class OtpRepository {
  Future<OtpResult> sendEmail(String email);
}