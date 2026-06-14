import 'package:dio/dio.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/paginated_data_entity.dart';
import '../../domain/entities/server_exception.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_ds.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedDataEntity<ReportEntity>> getReports({required int page}) async {
    try {
      final result = await remoteDataSource.getReports(page: page);
      return result;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      // 401 Unauthorized
      if (statusCode == 401) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Sesi Anda telah berakhir. Silakan login kembali.');
      }

      // 403 Forbidden
      if (statusCode == 403) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Anda tidak memiliki akses ke halaman ini.');
      }

      // 404 Not Found
      if (statusCode == 404) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Data siswa tidak ditemukan.');
      }

      // 422 Validation Error
      if (statusCode == 422) {
        final message = data is Map ? data['message']?.toString() : null;
        final errors = data is Map && data['errors'] is Map
            ? Map<String, dynamic>.from(data['errors'] as Map)
            : null;
        throw ServerException(
          message ?? 'Data tidak valid.',
          errors: errors,
        );
      }

      // 500+ Server Error
      if (statusCode != null && statusCode >= 500) {
        final message = data is Map ? data['message']?.toString() : null;
        throw ServerException(message ?? 'Terjadi kesalahan pada server. Silakan coba lagi nanti.');
      }

      // Error lainnya
      final fallbackMessage = data is Map && data.containsKey('message')
          ? data['message'].toString()
          : (e.message ?? 'Gagal mengambil data laporan.');
      throw ServerException(fallbackMessage);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan tidak terduga saat mengambil laporan.');
    }
  }
}
