import '../../entities/order_result_entity.dart';
import '../../repositories/package_repository.dart';

class OrderPackagesUseCase {
  final PackageRepository repository;

  OrderPackagesUseCase(this.repository);

  /// [packages] is a list of maps with 'id' and 'quantity' keys.
  Future<OrderResultEntity> execute(List<Map<String, int>> packages) {
    return repository.orderPackages(packages);
  }
}
