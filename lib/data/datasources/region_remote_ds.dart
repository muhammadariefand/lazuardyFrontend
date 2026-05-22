import 'package:dio/dio.dart';
import 'package:lazuadry_mobile_fe/data/models/region_model.dart';

abstract class RegionRemoteDataSource {
  Future<List<RegionModel>> fetchProvinces();
  Future<List<RegionModel>> fetchRegencies(String provinceId);
  Future<List<RegionModel>> fetchDistricts(String regencyId);
  Future<List<RegionModel>> fetchSubdistricts(String districtId);
}

class RegionRemoteDataSourceImpl implements RegionRemoteDataSource {
  final Dio client; 

  RegionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RegionModel>> fetchProvinces() async {
    final response = await client.get('/api/provinces'); // Sesuaikan endpoint BE
    return (response.data['data'] as List).map((x) => RegionModel.fromJson(x)).toList();
  }

  @override
  Future<List<RegionModel>> fetchRegencies(String provinceId) async {
    final response = await client.get('/api/regencies/$provinceId'); // Sesuaikan endpoint
    return (response.data['data'] as List).map((x) => RegionModel.fromJson(x)).toList();
  }

  @override
  Future<List<RegionModel>> fetchDistricts(String regencyId) async {
    final response = await client.get('/api/districts/$regencyId'); // Sesuaikan endpoint
    return (response.data['data'] as List).map((x) => RegionModel.fromJson(x)).toList();
  }

  @override
  Future<List<RegionModel>> fetchSubdistricts(String districtId) async {
    final response = await client.get('/api/subdistricts/$districtId'); // Sesuaikan endpoint
    return (response.data['data'] as List).map((x) => RegionModel.fromJson(x)).toList();
  }
}