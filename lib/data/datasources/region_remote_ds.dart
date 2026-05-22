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

  // Helper method untuk memproses data secara aman
  List<RegionModel> _mapResponse(Response response) {
    dynamic rawData;

    // Cek apakah response.data adalah Map yang punya key 'data'
    if (response.data is Map<String, dynamic> && response.data['data'] != null) {
      rawData = response.data['data'];
    } 
    // Cek apakah response.data itu sendiri adalah List
    else if (response.data is List) {
      rawData = response.data;
    } 
    else {
      throw Exception("Format response wilayah tidak dikenali");
    }

    return (rawData as List).map((x) => RegionModel.fromJson(x)).toList();
  }

  @override
  Future<List<RegionModel>> fetchProvinces() async {
    try {
      final response = await client.get('/api/provinces');
      return _mapResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchRegencies(String provinceId) async {
    try {
      final response = await client.get('/api/regencies/$provinceId');
      return _mapResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  // Terapkan hal yang sama untuk Districts dan Subdistricts...
  @override
  Future<List<RegionModel>> fetchDistricts(String regencyId) async {
    try {
      final response = await client.get('/api/districts/$regencyId');
      return _mapResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RegionModel>> fetchSubdistricts(String districtId) async {
    final response = await client.get('/api/subdistricts/$districtId');
    return _mapResponse(response);
  }
}