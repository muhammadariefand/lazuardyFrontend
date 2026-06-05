import 'package:dio/dio.dart';
import '../../domain/entities/server_exception.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_ds.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardEntity> getDashboardData({int page = 1}) async {
    try {
      return await remoteDataSource.getDashboardData(page: page);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ServerException('Unauthorized');
      }
      final data = e.response?.data;
      throw ServerException(
        data is Map && data.containsKey('message')
            ? data['message'].toString()
            : (e.message ?? 'Gagal memuat data dashboard'),
      );
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak diketahui');
    }
  }
}