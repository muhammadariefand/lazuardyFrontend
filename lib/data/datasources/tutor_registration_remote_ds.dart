import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/core/network/api_client.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/subject_entity.dart';

class TutorRegistrationRemoteDataSource {
  final ApiClient client;
  TutorRegistrationRemoteDataSource(this.client);

  Future<String> validateBankAccount(String bankCode, String accountNumber) async {
    try {
      final response = await client.dio.post(
        '/validateBankAccount',
        data: {
          'bank_code': bankCode,
          'account_number': accountNumber,
        },
      );
      if (response.data['status'] == 'success') {
        return response.data['account_holder_name'] ?? '';
      } else {
        throw ServerException(response.data['message'] ?? 'Gagal memverifikasi rekening');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi rekening gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 400) {
         final data = e.response?.data;
         throw ServerException(data?['message'] ?? 'Permintaan tidak valid');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<List<SubjectEntity>> getSubjectByClass(int classId) async {
    try {
      final response = await client.dio.get(
        '/getSubjectByClass',
        queryParameters: {'classId': classId},
      );
      if (response.data['success'] == 'success') {
        final List data = response.data['data']['data'];
        return data.map((json) => SubjectEntity.fromJson(json)).toList().cast<SubjectEntity>();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ServerException('Permintaan tidak valid');
      } else if (e.response?.statusCode == 500) {
        throw ServerException('Server sedang gangguan, coba lagi nanti.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }

  Future<Map<String, dynamic>> tutorRegister(FormData formData) async {
    try {
      final response = await client.dio.post(
        '/tutorRegister',
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw ServerException(
          data['message'] ?? 'Validasi gagal',
          errors: data['errors'],
        );
      } else if (e.response?.statusCode == 500) {
        print('SERVER ERROR 500: ${e.response?.data}');
        throw ServerException('Gagal melakukan registrasi tentor.');
      } else {
        throw ServerException('Terjadi kesalahan yang tidak diketahui.');
      }
    }
  }
}
