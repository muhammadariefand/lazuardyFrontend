import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';

class GetProvincesUseCase {
  final RegionRepository repository;
  GetProvincesUseCase(this.repository);

  Future<List<RegionEntity>> execute() async => await repository.getProvinces();
}