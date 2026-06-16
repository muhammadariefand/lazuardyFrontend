import 'package:lazuadry_mobile_fe/domain/entities/parent_dashboard_entity.dart';
import '../../domain/entities/student_biodata.dart';
import '../../domain/entities/server_exception.dart';
import '../../domain/repositories/parent_dashboard_repository.dart';
import '../datasources/parent_dashboard_remote_ds.dart';

class ParentDashboardRepositoryImpl implements ParentDashboardRepository {
  final ParentDashboardRemoteDataSource remoteDataSource;

  ParentDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ParentDashboardEntity> getDashboard() async {
    try {
      return await remoteDataSource.getDashboard();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }

  @override
  Future<StudentBiodata> getProfile() async {
    try {
      return await remoteDataSource.getProfile();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Terjadi kesalahan yang tidak terduga');
    }
  }
}
