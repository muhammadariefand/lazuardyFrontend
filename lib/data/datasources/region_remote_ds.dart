import 'package:dio/dio.dart';
import 'dart:convert';
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
      final response = await client.get('$_baseUrl/provinces.json');
      final String source = response.data is String ? response.data : jsonEncode(response.data);
      final List data = jsonDecode(source);
      return data.map((x) => RegionModel.fromJson(x as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchRegencies(String provinceId) async {
    try {
      final response = await client.get('$_baseUrl/regencies/$provinceId.json');
      final String source = response.data is String ? response.data : jsonEncode(response.data);
      final List data = jsonDecode(source);
      return data.map((x) => RegionModel.fromJson(x as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchDistricts(String regencyId) async {
    try {
      final response = await client.get('$_baseUrl/districts/$regencyId.json');
      final String source = response.data is String ? response.data : jsonEncode(response.data);
      final List data = jsonDecode(source);
      return data.map((x) => RegionModel.fromJson(x as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchSubdistricts(String districtId) async {
    try {
      final response = await client.get('$_baseUrl/villages/$districtId.json');
      final String source = response.data is String ? response.data : jsonEncode(response.data);
      final List data = jsonDecode(source);
      return data.map((x) => RegionModel.fromJson(x as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}