import 'package:dio/dio.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/entities/paginated_data_entity.dart';
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
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      throw Exception(e.message ?? 'Gagal mengambil data laporan.');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga saat mengambil laporan.');
    }
  }
}
