import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/tutor_dashboard_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';

abstract class TutorDashboardRemoteDataSource {
  Future<TutorDashboardModel> getHomepage({int notificationPage = 1});
  Future<Map<String, dynamic>> getTutorReviews({
    int? studentId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  });
}

class TutorDashboardRemoteDataSourceImpl implements TutorDashboardRemoteDataSource {
  final Dio dio;

  TutorDashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<TutorDashboardModel> getHomepage({int notificationPage = 1}) async {
    final response = await dio.get(
      '/tutor/dashboard/homepage',
      queryParameters: {'notification_page': notificationPage},
    );

    if (response.data is Map<String, dynamic>) {
      final responseData = response.data as Map<String, dynamic>;

      final status = responseData['status']?.toString().toLowerCase();
      if (status == 'success' && responseData['data'] != null) {
        final dataMap = responseData['data'] as Map<String, dynamic>;

        // WORKAROUND: Ambil avg_rating dari endpoint review karena API homepage mengembalikan null
        try {
          final reviewRes = await dio.get('/tutor/review', queryParameters: {'pagination': 1});
          if (reviewRes.data is Map) {
            final reviewData = reviewRes.data as Map<String, dynamic>;
            if (reviewData['status']?.toString().toLowerCase() == 'success') {
              final avgRating = reviewData['avg_rating'];
              if (dataMap['tutor'] != null && dataMap['tutor'] is Map) {
                dataMap['tutor']['avgRate'] = avgRating;
              }
            }
          }
        } catch (_) {
          // Abaikan jika gagal
        }

        return TutorDashboardModel.fromJson(dataMap);
      }
    }

    throw Exception('Format respon homepage tutor tidak valid');
  }

  @override
  Future<Map<String, dynamic>> getTutorReviews({
    int? studentId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (studentId != null) 'student_id': studentId,
        if (minRating != null) 'min_rating': minRating,
        if (maxRating != null) 'max_rating': maxRating,
        if (page != null) 'page': page,
        'pagination': pagination,
      };

      final response = await dio.get(
        '/tutor/review',
        queryParameters: queryParams,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['status']?.toString().toLowerCase() == 'success' &&
          responseData['data'] != null) {
        return responseData;
      }
      throw ServerException('Format respon ulasan tidak valid');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Sesi telah berakhir, silakan login kembali');
      }
      if (e.response?.statusCode == 403) {
        throw ServerException(e.response?.data['message'] ?? 'Forbidden');
      }
      String errorMessage = 'Terjadi kesalahan pada server';
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
