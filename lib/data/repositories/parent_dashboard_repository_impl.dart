import '../../domain/entities/parent_dashboard_entity.dart';
import '../../domain/repositories/parent_dashboard_repository.dart';
import '../datasources/parent_dashboard_remote_ds.dart';

class ParentDashboardRepositoryImpl implements ParentDashboardRepository {
  final ParentDashboardRemoteDataSource remoteDataSource;

  ParentDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ParentDashboardEntity> getDashboard() async {
    return await remoteDataSource.getDashboard();
  }
}
