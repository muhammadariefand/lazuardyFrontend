import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';

class GetSubdistrictsUseCase {
  final RegionRepository repository;
  GetSubdistrictsUseCase(this.repository);

  Future<List<RegionEntity>> execute(String districtId) async => await repository.getSubdistricts(districtId);
}