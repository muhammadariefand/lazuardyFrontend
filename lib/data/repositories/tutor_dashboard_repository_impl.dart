import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/tutor_dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/data/models/review_model.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_review_response_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/paginated_data_entity.dart';
import 'package:lazuadry_mobile_fe/domain/entities/review_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/tutor_dashboard_repository.dart';

class TutorDashboardRepositoryImpl implements TutorDashboardRepository {
  final TutorDashboardRemoteDataSource remoteDataSource;

  TutorDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TutorDashboardEntity> getHomepage({int notificationPage = 1}) async {
    try {
      return await remoteDataSource.getHomepage(notificationPage: notificationPage);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      if (statusCode == 400) {
        throw ServerException('Parameter tidak valid.');
      }
      if (statusCode == 401) {
        throw ServerException('Token tidak valid atau tidak ada.');
      }
      if (statusCode == 403) {
        throw ServerException('Tutor belum terverifikasi atau akses ditolak.');
      }
      if (statusCode == 404) {
        throw ServerException('Data tutor tidak ditemukan.');
      }
      if (statusCode != null && statusCode >= 500) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Terjadi kesalahan pada server.');
      }

      final fallbackMessage = data is Map && data.containsKey('message')
          ? data['message'].toString()
          : (e.message ?? 'Gagal mengambil data homepage.');
      throw ServerException(fallbackMessage);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil data homepage.');
    }
  }

  @override
  Future<TutorReviewResponseEntity> getTutorReviews({
    int? studentId,
    int? minRating,
    int? maxRating,
    int? page,
    int pagination = 10,
  }) async {
    try {
      final responseMap = await remoteDataSource.getTutorReviews(
        studentId: studentId,
        minRating: minRating,
        maxRating: maxRating,
        page: page,
        pagination: pagination,
      );

      final avgRating = (responseMap['avg_rating'] as num?)?.toDouble() ?? 0.0;
      final paginationData = responseMap['data'] as Map<String, dynamic>;
      final itemsData = paginationData['data'] as List<dynamic>? ?? [];

      final items = itemsData
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final paginatedReviews = PaginatedDataEntity<ReviewEntity>(
        data: items,
        currentPage: paginationData['current_page'] as int? ?? 1,
        lastPage: paginationData['last_page'] as int? ?? 1,
        total: paginationData['total'] as int? ?? 0,
      );

      return TutorReviewResponseEntity(
        avgRating: avgRating,
        reviews: paginatedReviews,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil ulasan dari siswa.');
    }
  }
}
