import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/datasources/tutor_dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/server_exception.dart';
import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';
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
}
