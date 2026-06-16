import '../../entities/package_entity.dart';
import '../../repositories/package_repository.dart';

class GetPackagesUseCase {
  final PackageRepository repository;

  GetPackagesUseCase(this.repository);

  Future<List<PackageEntity>> execute() {
    return repository.getPackages();
  }
}
