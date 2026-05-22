import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_ds.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardEntity> getDashboardData({int page = 1}) async {
    try {
      // Karena DashboardModel turunan (extends) dari DashboardEntity, kita bisa langsung mengembalikannya
      return await remoteDataSource.getDashboardData(page: page);
    } catch (e) {
      rethrow;
    }
  }
}