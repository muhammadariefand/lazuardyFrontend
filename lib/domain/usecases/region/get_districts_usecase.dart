import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';

class GetDistrictsUseCase {
  final RegionRepository repository;
  GetDistrictsUseCase(this.repository);

  Future<List<RegionEntity>> execute(String regencyId) async => await repository.getDistricts(regencyId);
}