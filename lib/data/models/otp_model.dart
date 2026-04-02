// lib/src/data/models/otp_model.dart

import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';

class OtpModel {
  static OtpResult fromJson(Map<String, dynamic> json, int statusCode) {
    if (statusCode == 200 || statusCode == 201) {
      return OtpSuccess(
        status: json['status'],
      );
    } else {
      return OtpFailure(
        status: json['status'],
        message: json['message'] ?? 'Terjadi kesalahan',
      );
    }
  }
}