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
  
  // Menggunakan URL resmi dari Emsifa (sementara tanpa fork untuk mempercepat progres)
  final String _baseUrl = 'https://www.emsifa.com/api-wilayah-indonesia/api';

  RegionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RegionModel>> fetchProvinces() async {
    try {
      // Endpoint sesuai dokumentasi: /provinces.json
      final response = await client.get('$_baseUrl/provinces.json');
      return (response.data as List).map((x) => RegionModel.fromJson(x)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchRegencies(String provinceId) async {
    try {
      // Endpoint sesuai dokumentasi: /regencies/{provinceId}.json
      final response = await client.get('$_baseUrl/regencies/$provinceId.json');
      return (response.data as List).map((x) => RegionModel.fromJson(x)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchDistricts(String regencyId) async {
    try {
      // Endpoint sesuai dokumentasi: /districts/{regencyId}.json
      final response = await client.get('$_baseUrl/districts/$regencyId.json');
      return (response.data as List).map((x) => RegionModel.fromJson(x)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchSubdistricts(String districtId) async {
    try {
      // PENTING: Dokumentasi Emsifa menggunakan nama 'villages', bukan 'subdistricts'
      final response = await client.get('$_baseUrl/villages/$districtId.json');
      return (response.data as List).map((x) => RegionModel.fromJson(x)).toList();
    } catch (e) {
      rethrow;
    }
  }
}