// lib/src/domain/entities/otp_response.dart

sealed class OtpResult {}

class OtpSuccess extends OtpResult {
  final String status;
  OtpSuccess({required this.status});
}

class OtpFailure extends OtpResult {
  final String status;
  final String message; // Pesan error umum
  OtpFailure({required this.status, required this.message});
}