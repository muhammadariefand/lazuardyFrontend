import '../../domain/entities/package_entity.dart';
import '../../domain/entities/order_result_entity.dart';
import '../../domain/repositories/package_repository.dart';
import '../datasources/package_remote_ds.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remoteDataSource;

  PackageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PackageEntity>> getPackages() async {
    return await remoteDataSource.getPackages();
  }

  @override
  Future<PackageEntity> getPackageDetail(int id) async {
    return await remoteDataSource.getPackageDetail(id);
  }

  @override
  Future<OrderResultEntity> orderPackages(List<Map<String, int>> packages) async {
    return await remoteDataSource.orderPackages(packages);
  }
}
