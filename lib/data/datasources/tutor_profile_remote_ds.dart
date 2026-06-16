import 'package:dio/dio.dart';
import '../models/tutor_model.dart';
import '../../domain/entities/server_exception.dart';

abstract class TutorProfileRemoteDataSource {
  Future<TutorModel> getTutorProfile();
  Future<void> updateTutorBiodata(Map<String, dynamic> data);
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName);
}

class TutorProfileRemoteDataSourceImpl implements TutorProfileRemoteDataSource {
  final Dio dio;

  TutorProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<TutorModel> getTutorProfile() async {
    try {
      final response = await dio.get('/tutor/biodata');
      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['status'] == 'success') {
        return TutorModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Gagal memuat profil tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      throw ServerException(e.message ?? 'Terjadi kesalahan pada server');
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTutorBiodata(Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/tutor/profile', data: data);
      final responseData = response.data as Map<String, dynamic>;

      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal memperbarui biodata tutor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException('Akses ditolak: Endpoint ini hanya untuk role tutor');
      }
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'Data tidak valid');
      }
      String errorMessage = 'Gagal memperbarui biodata tutor';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<void> updateProfilePhoto(List<int> fileBytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'profile_picture': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
        ),
      });

      final response = await dio.patch(
        '/updateProfilePhoto',
        data: formData,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status'] != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal memperbarui foto profil');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'File foto tidak valid');
      }
      String errorMessage = 'Gagal memperbarui foto profil';
      if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw ServerException(errorMessage);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }
}
