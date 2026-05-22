import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';

class GetRegenciesUseCase {
  final RegionRepository repository;
  GetRegenciesUseCase(this.repository);

  Future<List<RegionEntity>> execute(String provinceId) async => await repository.getRegencies(provinceId);
}