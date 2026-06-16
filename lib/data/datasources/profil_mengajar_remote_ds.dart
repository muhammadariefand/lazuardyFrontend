import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';

abstract class ProfilMengajarRemoteDataSource {
  Future<Map<String, dynamic>> getTutorSchedules({
    required int tutorId,
    String? day,
  });

  Future<void> updateTeachingProfile({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  });
}

class ProfilMengajarRemoteDataSourceImpl implements ProfilMengajarRemoteDataSource {
  final Dio dio;

  ProfilMengajarRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getTutorSchedules({
    required int tutorId,
    String? day,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'tutor_id': tutorId,
        if (day != null && day.isNotEmpty) 'day': day,
      };

      final response = await dio.get(
        '/schedule/getTutorSchedulesByDay',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() == 'success' &&
          responseData['data'] != null) {
        return responseData['data'] as Map<String, dynamic>;
      }
      throw ServerException('Format respon jadwal tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      String errorMessage = 'Terjadi kesalahan saat mengambil jadwal tutor';
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
  Future<void> updateTeachingProfile({
    required String description,
    required List<String> learningMethods,
    required List<Map<String, String>> schedules,
  }) async {
    try {
      final response = await dio.put(
        '/tutor/teaching-profile',
        data: {
          'description': description,
          'learning_method': learningMethods,
          'schedules': schedules,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() != 'success') {
        throw ServerException(responseData['message'] ?? 'Gagal memperbarui profil mengajar');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 400 || e.response?.statusCode == 422) {
        final data = e.response?.data;
        if (data is Map && data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final messages = errors.values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .join('\n');
          throw ServerException(messages);
        }
        throw ServerException(data?['message'] ?? 'Validasi request gagal');
      }
      String errorMessage = 'Terjadi kesalahan saat memperbarui profil mengajar';
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
