import '../../entities/package_entity.dart';
import '../../repositories/package_repository.dart';

class GetPackageDetailUseCase {
  final PackageRepository repository;

  GetPackageDetailUseCase(this.repository);

  Future<PackageEntity> execute(int id) {
    return repository.getPackageDetail(id);
  }
}
