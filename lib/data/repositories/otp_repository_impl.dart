// lib/src/data/repositories/user_repository_impl.dart
import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/data/models/otp_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_response.dart';
import 'package:lazuadry_mobile_fe/domain/entities/otp_verification.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/otp_repository.dart';

class OtpRepositoryImpl implements OtpRepository {
  final ApiClient client;
  OtpRepositoryImpl(this.client);

  @override
  Future<OtpResult> sendEmail(String email) async {
    try{

      // 2. Kirim POST request
      final response = await client.dio.post(
        '/registerOtpEmail',
        data: {'email': email},
      );

      return OtpModel.fromJson(response.data, response.statusCode!);

    } on DioException catch (e) {
      // Dio menganggap status 400-500 sebagai error dan masuk ke catch
      if (e.response != null) {
        return OtpModel.fromJson(e.response!.data, e.response!.statusCode!);
      }
      return OtpFailure(status: "error", message: "Koneksi gagal: ${e.message}");
    }
  }
}