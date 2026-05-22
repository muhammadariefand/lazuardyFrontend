import 'package:lazuadry_mobile_fe/data/datasources/region_remote_ds.dart';
import 'package:lazuadry_mobile_fe/domain/entities/region_entity.dart';
import 'package:lazuadry_mobile_fe/domain/repositories/region_repository.dart';

class RegionRepositoryImpl implements RegionRepository {
  final RegionRemoteDataSource remoteDataSource;

  RegionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RegionEntity>> getProvinces() async => await remoteDataSource.fetchProvinces();

  @override
  Future<List<RegionEntity>> getRegencies(String provinceId) async => await remoteDataSource.fetchRegencies(provinceId);

  @override
  Future<List<RegionEntity>> getDistricts(String regencyId) async => await remoteDataSource.fetchDistricts(regencyId);

  @override
  Future<List<RegionEntity>> getSubdistricts(String districtId) async => await remoteDataSource.fetchSubdistricts(districtId);
}