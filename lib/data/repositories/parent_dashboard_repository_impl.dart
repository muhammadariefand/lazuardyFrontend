import 'package:lazuadry_mobile_fe/data/datasources/parent_dashboard_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/parent_dashboard_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/parent_dashboard_repository.dart';

class ParentDashboardRepositoryImpl implements ParentDashboardRepository {
  final ParentDashboardRemoteDataSource remoteDataSource;

  ParentDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ParentDashboardEntity> getDashboard() async {
    return await remoteDataSource.getDashboard();
  }
}
