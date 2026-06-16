import '../entities/package_entity.dart';
import '../entities/order_result_entity.dart';

abstract class PackageRepository {
  Future<List<PackageEntity>> getPackages();
  Future<PackageEntity> getPackageDetail(int id);
  Future<OrderResultEntity> orderPackages(List<Map<String, int>> packages);
}
