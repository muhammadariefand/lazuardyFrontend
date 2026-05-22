import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';

abstract class RegionRepository {
  Future<List<RegionEntity>> getProvinces();
  Future<List<RegionEntity>> getRegencies(String provinceId);
  Future<List<RegionEntity>> getDistricts(String regencyId);
  Future<List<RegionEntity>> getSubdistricts(String districtId);
}